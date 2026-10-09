################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 1059 $
## $Date: 2012-09-05 15:52:24 +0200 (Mi, 05. Sep 2012) $
## $Author: kostova $
## $Id: parity.census.weights.R 1059 2012-09-05 13:52:24Z kostova $
##
################################################################################

parity.census.weights <-
function(parity, ages = 12:56, reqRange = c(15, 49), maxParity = 4, unkMethod = c(default = "proportional"), outfile = NULL, country = NULL, ldb = TRUE, ...) {
## Calculates the parity weights for parities 0..4+ on the day
## of the census for census data
##
## @inputs
## - parity is a path to the XXXparity.txt file, or a data frame representing
##   its contents (read in using read.csv( , header = TRUE, na.strings = ".")
## - ages is the ages to include (default 12:56)
## - reqRange is the ages which are required, i.e. no open-age interval is allowed
##   within this age range (ACY)
## - maxParity is the maximum parity level to include (default 4, i.e. parities 0..4+)
## - unkMethod is the method to use for redistribution of unknown parities,
##   potentially as a vector keyed by year, e.g.
##   "proportional" (default) or
##   c(default = "proportional", `1991` = "allToZero", `2001` = "belowXtoZero")
##   - if a default key is missing, this will be added with value "proportional"
## - outfile is the path to a file to write the result to, if desired.
##   - NULL (default) means no file output
## - country is the name of the country, for use in the output file if one should be created
## - ... is any other arguments required by the individual redistribution
##   functions
## @returns
## - the female parity weights for 0..maxParity+ and given ages for each census

  if (!is.data.frame(parity)) {
    parity <- read.csv(parity, header = TRUE, na.strings = ".")
  }
  
  if (ldb) parity <- parity[parity$LDB == 1, ]

  if (!nrow(parity)) {
    stop('No parity data remaining after filtering for LDB 1')
  }
  
  if (length(unkMethod) == 1 && is.null(names(unkMethod))) names(unkMethod) <- "default" else if (!("default" %in% names(unkMethod))) unkMethod["default"] <- "proportional"
  
  parity <- parity.unk.redist(parity, unkMethod, ...)
  
  # convert potential factors to numeric or character
  if (is(parity$Age, "factor")) parity$Age <- levels(parity$Age)[parity$Age]
  parity$Age <- as.numeric(parity$Age)
  if (is(parity$Cohort, "factor")) parity$Cohort <- levels(parity$Cohort)[parity$Cohort]
  parity$Cohort <- as.numeric(parity$Cohort)
  if (is(parity$Parity, "factor")) parity$Parity <- levels(parity$Parity)[parity$Parity]
  parity$Parity <- as.numeric(parity$Parity)
  # interval data best as character as may contain +/- symbols
  if (is(parity$AgeInt, "factor")) parity$AgeInt <- levels(parity$AgeInt)[parity$AgeInt]
  parity$AgeInt <- as.character(parity$AgeInt)
  if (is(parity$CohInt, "factor")) parity$CohInt <- levels(parity$CohInt)[parity$CohInt]
  parity$CohInt <- as.character(parity$CohInt)
  
  # seems to be the easiest way to get an empty data frame
  result <-
    as.data.frame(array(dim = c(0, 6 + maxParity),
                  dimnames = list(c(),
                                  c("Year", "Month", "Day", "Age", "Format",
                                    paste("w", 0:maxParity, sep = "")))))
  names(result)[ncol(result)] <- paste(names(result)[ncol(result)], "+", sep = "")

  if (nrow(parity) > 0) {

    parityByYear <- split(parity, parity$Year)

    for (parityY in parityByYear) {
      thisYear <- parityY$Year[1]
      
      fmt <- 
        if (any(!is.na(parityY$Cohort))) {
          # if there are any values in the Cohort then we assume that we have Cohort data
          # but there is potentially also Age data present, so drop anything that has
          # NA in the Cohort field and then calculate the ARDY for the rest.
          parityY <- parityY[!is.na(parityY$Cohort), ]
          parityY$Age <- parityY$Year - parityY$Cohort
          "ARDY"
        } else {
          "ACY"
        }
    
      # if we're dealing with ARDY data then the age ranges are all shifted up by 1
      reqRangeY <- reqRange + if (fmt == "ARDY") 1 else 0
      
      # drop superfluous ages and columns - we still need interval columns for checking
      parityY <- parityY[parityY$Age %in% ages, c("Year", "Month", "Day", "Age", "AgeInt", "CohInt", "Parity", "Population")]  
      
      # aggregate maxParity+
      for (age in unique(parityY$Age)) {
        parityY[parityY$Age == age & parityY$Parity == maxParity, "Population"] <-
          sum(parityY[parityY$Age == age & parityY$Parity >= maxParity, "Population"], na.rm = TRUE)
      }
      parityY <- parityY[parityY$Parity <= maxParity, ]

      # set missing CohInt and AgeInt values to "*" as otherwise the reshaping can go pear-shaped with NAs
      if (any(is.na(parityY$CohInt))) parityY$CohInt[is.na(parityY$CohInt)] <- "*"
      if (any(is.na(parityY$AgeInt)))parityY$AgeInt[is.na(parityY$AgeInt)] <- "*"
      
      # add format column and reshape to wide (different parities in columns, not separate rows)
      parityY$Format <- fmt
      parityY <- reshape(parityY, direction = "wide", timevar = "Parity", idvar = c("Year", "Month", "Day", "Age", "Format", "AgeInt", "CohInt"), varying = list(names(result)[6:ncol(result)]))
      
      # check for insufficient age range: we also need data for the maximum age plus one as if this is a
      # multiple-year age category it will be used for all further years: note AgeInt and CohInt are currently
      # character data
      if (!all(reqRangeY %in% parityY[(parityY$AgeInt == "1") | (parityY$CohInt == "1"), 'Age'])) {
        stop("Required age range not present in parity data for year ", thisYear)
      }
      
      # drop interval columns: we're done with checking them now
      parityY$AgeInt <- NULL
      parityY$CohInt <- NULL
      
      # trim superfluous data: at the lower end we retain only the oldest multiple-year interval and
      # at the upper end only the youngest, but we give a warning about any ages that are being trimmed
      # since we have no idea whether the last category is multi-age or not, we assume false (this is in
      # any case not important)
      multiAge <- parityY$Age[c(diff(parityY$Age) > 1, FALSE)]
      lowerDiscardedAges <- multiAge[multiAge < min(reqRange)] # all lower multiple age groups will be discarded
      upperMultiAge <- multiAge[multiAge > max(reqRange)]
      upperDiscardedAges <-
          if (length(upperMultiAge)) {
            parityY$Age[parityY$Age > min(upperMultiAge)]
          } else {
            c()
          }
      discardedAges <- c(lowerDiscardedAges, upperDiscardedAges)

      if (length(discardedAges)) {
        parityY <- parityY[!(parityY$Age %in% discardedAges), ]
        if (length(lowerDiscardedAges) && length(upperDiscardedAges)) {
          warning("Parity data in year ", thisYear, " at ", fmt, " ", paste(discardedAges, collapse = ", "),
              " will be ignored: initial parity distribution will be applied for age(s) ",
              paste(lowerDiscardedAges, collapse = ", "), " and the distribution at age ", max(parityY$Age),
              " applied for age(s) ", paste(upperDiscardedAges, collapse = ", "), call. = FALSE)
        } else if (length(lowerDiscardedAges)) {
          warning("Parity data in year ", thisYear, " at ", fmt, " ", paste(lowerDiscardedAges, collapse = ", "),
              " will be ignored and initial parity distribution applied", call. = FALSE)
        } else if (length(upperDiscardedAges)) {
          warning("Parity data in year ", thisYear, " at ", fmt, " ", paste(upperDiscardedAges, collapse = ", "),
              " will be ignored and the distribution at age ", max(parityY$Age), " applied", call. = FALSE)
        }
      }
      
      parityY[, 6:ncol(parityY)] <- parityY[, 6:ncol(parityY)] / rowSums(parityY[, 6:ncol(parityY)], na.rm = TRUE)
      # ages at the bottom end needing to be added (distribution 1, 0, 0, ..., 0)
      noAgesL <- ages[ages < min(parityY$Age)]
      if (length(noAgesL) > 0) parityY <- {
        # cbind can give a warning about names, so use suppressWarnings to muffle it
        extraRows <- suppressWarnings(cbind(parityY[1, 1:3], Age = noAgesL, Format = fmt, w0 = 1, t(rep(0, ncol(parityY) - 6))))
        names(extraRows) <- names(parityY)
        rbind(extraRows, parityY)
      }
      # ages at the top end needing to be added (distribution as for highest available age)
      noAgesU <- ages[ages > max(parityY$Age)]
      if (length(noAgesU) > 0) parityY <- {
        # cbind can give a warning about names, so use suppressWarnings to muffle it
        extraRows <- suppressWarnings(cbind(parityY[parityY$Age == max(parityY$Age), 1:3], Age = noAgesU, parityY[parityY$Age == max(parityY$Age), 5:ncol(parityY)]))
        names(extraRows) <- names(parityY)
        rbind(parityY, extraRows)
      }

      # make sure that the order of ages is correct
      parityY <- parityY[do.call(order, parityY), ]

      result <- rbind(result, parityY)
    }
  }
  
  if (!is.null(outfile)) {
    cat("\"", if (!is.null(country)) c(country, ", "), "Female parity composition by age (ARDY or ACY), by census date\"\n", "Last modified: ", format(Sys.Date(), "%d/%m/%Y"), "\n", sep = "", file = outfile)
    # muffle warning about appending column headings
    suppressWarnings(write.csv(result, outfile, quote = FALSE, na = ".", row.names = FALSE, append = TRUE))
  }
  
  invisible(result)
}

