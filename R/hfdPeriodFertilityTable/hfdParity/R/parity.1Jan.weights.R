################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 1037 $
## $Date: 2012-01-27 17:41:32 +0100 (Fr, 27. Jan 2012) $
## $Author: Ed $
## $Id: parity.1Jan.weights.R 1037 2012-01-27 16:41:32Z Ed $
##
################################################################################

parity.1Jan.weights <-
function(census.weights, asfr.vv.bo, outfile = NULL) {
## Recalculates census weights from an arbitrary date in year to 1st January
## using fertility rates estimated using Hermite spline interpolation, or, for
## censuses on 31st December, taking these as the weights on 1st January of the
## following year
##
## Based on the method and in part on an original script by Krystof Zeman (VID)
##
## @inputs
## - census.weights is the path to a file containing the parity weights by age
##   on the census data, or a data frame representing this
##   - for the file, CSV format with column heads is assumed and two title rows
##     are skipped
##   - columns Year, Month, Day, Age, Format, w0, w1, ..., wx+ are assumed
##   - data for ages min - max + 1 (e.g. 12-56) are assumed - if there are any
##     gaps in the age range then an error is raised
## - asfr.vv.bo is the path to a file containing the ASFR by VV with birth
##   orders, or a data frame representing this
##   - for the file, table format is assumed and two title rows are skipped
##   - columns Year, ARDY, Cohort, Total, ASFR1, ASFR2, ..., ASFR(x+1)p
##     are assumed
##   - ages min- -> max+ (e.g. 12- -> 55+) are assumed
## - outfile is the path to a file to write the output to, if desired.
## @returns
## - a data frame with the columns Year, Age, w0, w1, ..., wxp

  if (!is.data.frame(census.weights)) {
    census.weights <- read.csv(census.weights, skip = 2, header = TRUE, na.strings = ".")
  }
  
  # adjust 31st December to 1st January of following year
  dec31 <- census.weights$Month == 12 & census.weights$Day == 31
  if (any(dec31)) {
    census.weights[dec31, c("Year", "Month", "Day")] <-
      cbind(Year = census.weights[dec31, "Year"] + 1, Month = 1, Day = 1)
  }
  
  if (all(census.weights$Month == 1 & census.weights$Day == 1)) {
    return(parity.reformat.weights(census.weights))
  }
  
  agesC <- unique(census.weights$Age) # usually 12:56
  nAgesC <- length(agesC)
  minAge <- min(agesC)
  numParities <- ncol(census.weights) - 5 # usually 5
  parCols <- 6:ncol(census.weights)

  if (!is.data.frame(asfr.vv.bo)) {
    asfr.vv.bo <- read.table(asfr.vv.bo, skip = 2, header = TRUE, na.strings = ".")
  }
  stopifnot(ncol(asfr.vv.bo) == 4 + numParities) # need as many birth orders as parities
  asfr.vv.bo$ARDY <- sub("-", "", sub("+", "", as.character(asfr.vv.bo$ARDY), fixed = TRUE), fixed = TRUE)
  asfr.vv.bo$ARDY <- as.numeric(asfr.vv.bo$ARDY)
  if (is(asfr.vv.bo$Year, "factor")) asfr.vv.bo$Year <- levels(asfr.vv.bo$Year)[asfr.vv.bo$Year]
  asfr.vv.bo$Year <- as.numeric(asfr.vv.bo$Year)
  
  # need to trim ASFR data to only the years with birth order data and the parity data
  # to those years for which we have sufficient ASFR data to perform the interpolation
  asfr.vv.bo <- asfr.vv.bo[!is.na(asfr.vv.bo$ASFR1), ]
  asfrYears <- unique(asfr.vv.bo$Year)
  
  census.years <- unique(census.weights$Year)
  missing.years <- census.years[!((census.years %in% asfrYears) & ((census.years + 1) %in% asfrYears))] # year itself can be used instead of -1 if necessary
  if (length(missing.years) > 0) {
    warning("Insufficient ASFR-VV by birth order data for interpolation of parity data in year(s) ", paste(missing.years, sep = ', '),
        ": this parity data will be discarded", call. = FALSE)
    census.weights <- census.weights[!(census.weights$Year %in% missing.years), ]
  }
  
  agesF <- unique(asfr.vv.bo$ARDY) # usually 12:55
  nAgesF <- length(agesF)
  stopifnot(nAgesF == nAgesC - 1) # need one more age in census weights than birth data
  boCols <- 5:ncol(asfr.vv.bo)

  census.weights <- split(census.weights, census.weights$Year)
  
  result <-
    as.data.frame(array(dim = c(0, 2 + numParities),
                  dimnames = list(c(),
                                  c("Year", "Age", paste("w", 1:numParities - 1, sep = "")))))
  names(result)[ncol(result)] <- paste(names(result)[ncol(result)], "p", sep = "")

  # always use the same arrays (to try and avoid reassigning memory)
  dataY <- array(0,
                dim = c(nAgesC, numParities, 6),
                dimnames = list(ARDY = agesC,
                                Order = 1:numParities,
                                Data = c("asfr_y-1", "asfr_y", "asfr_y+1", "w", "wx+1", "age")))
  # initial parity distribution is always 1,0,...,0
  dataY[1, , 4:5] <- 1
  # age starts at minAge
  dataY[, , 6] <- row(dataY[, , 6]) + minAge - 1
  
  w <- array(0, dim = c(nAgesF, numParities), dimnames = list(Age = agesF, Parity = names(result)[3:ncol(result)])) 

  for(censusY in census.weights) {
    y <- censusY[1, "Year"]
    m <- censusY[1, "Month"]
    d <- censusY[1, "Day"]
    f <- censusY[1, "Format"]
    # check we have no gaps in the age range
    if (!(nrow(censusY) > 1 && all(diff(censusY[, "Age"]) == 1))) {
      stop("Age range has gaps in year ", y)
    }
    cDate <- as.Date(paste(y, m, d, sep = "-")) # census date
    sDate <- as.Date(paste(y, 1, 1, sep = "-")) # 1st Jan
    eDate <- as.Date(paste(y, 12, 31, sep = "-")) # 31st Dec
    cProp <- as.numeric(difftime(cDate, sDate, units = "days")) /  # proportion from 1st Jan to census
               (as.numeric(difftime(eDate, sDate, units = "days")) + 1)
    dataY[2:nAgesF, , 1] <- cProp * as.matrix(asfr.vv.bo[asfr.vv.bo$Year == if(min(asfr.vv.bo$Year) == y) y else y - 1, boCols][1:(nAgesF - 1), ])
    dataY[1:nAgesF, , 2] <- cProp * as.matrix(asfr.vv.bo[asfr.vv.bo$Year == y, boCols])
    dataY[1:(nAgesF - 1), , 3] <- cProp * as.matrix(asfr.vv.bo[asfr.vv.bo$Year == y + 1, boCols][2:nAgesF, ])
    if (f == "ARDY") {
      dataY[1:nAgesC, , 4] <- as.matrix(censusY[, parCols]) # census parity weights at age (ARDY)
      # census parity weights at age + 1 not needed in this case
    } else {
      dataY[1, , 4] <- c(1, rep(0, numParities - 1))
      dataY[2:nAgesC, , 4] <- as.matrix(censusY[1:(nAgesC - 1), parCols]) # census parity weights at ARDY (1 + ACY on 1st Jan)
      dataY[1, , 5] <- c(1, rep(0, numParities - 1))
      dataY[2:nAgesC, , 5] <- as.matrix(censusY[2:nAgesC, parCols]) # census parity weights at age + 1
    }
    wfY <-
      apply(dataY,
            c(1, 2), # apply to each cell individually
            function(dataYAW, cp, fmt) {
              # calculate correction based on asfr
              age <- c(dataYAW[6] - 0.5, dataYAW[6] + 0.5, dataYAW[6] + 1.5)
              f_ <- spline(age, dataYAW[1:3], xout = dataYAW[6] + cp, method = "fmm")$y
              if (f_ < 0) f_ <- 0
              # convert ACY weights to ARDY weights if necessary
              if (fmt == "ACY") {
                dataYAW[4] <- ((1 - cp) * dataYAW[4]) + (cp * dataYAW[5])
              }
              return(c(dataYAW[4], f_))
            }, cProp, f)
    # drop first age (usally ARDY 12 (= ACY 11)) from the weightings
    w[, 1] <- wfY[1, 2:nAgesC, 1] + wfY[2, 2:nAgesC, 1]
    w[, 2:4] <- wfY[1, 2:nAgesC, 2:4] - wfY[2, 2:nAgesC, 1:3] + wfY[2, 2:nAgesC, 2:4]
    w[, 5] <- wfY[1, 2:nAgesC, 5] - wfY[2, 2:nAgesC, 4]
    # correct values to range 0 <= w <= 1 and renormalise sums to 1
    w[w < 0] <- 0
    w[w > 1] <- 1
    w <- sweep(w, 1, rowSums(w, na.rm = TRUE), `/`)
    result <- rbind(result, cbind(Year = rep(y, nAgesF), Age = agesF, w))
  }
  
  if (!is.null(outfile)) {
    write.csv(result, outfile, quote = FALSE, na = ".", row.names = FALSE)
  }
 
  invisible(result)
}

