################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 885 $
## $Date: 2011-01-11 10:44:30 +0100 (Di, 11. Jan 2011) $
## $Author: nash $
## $Id: calculateCensusPlusOneParityDistributions.R 885 2011-01-11 09:44:30Z nash $
##
################################################################################

.calculateCensusPlusOneParityDistributions <-
function(bTR, eTR, wiyT) {
## Calculate the age-parity distribution estimates for 1st January on the year
## following a census year according to the method in MP §5.2
##
## @inputs
## - bTR is births data by order in Lexis triangles as a data frame
## - eTR is female population exposure data in Lexis triangles as a data frame
## - wiyT is the distribution on 1st January of the
##   census year(s), as a 3D array of Year, Age, Parity. If the ages are in the
##   range xmin - xmax, the resulting array will cover the range
##   (xmin + 1) - xmax
## @returns
## - an array of mid-year age-parity distribution estimates for the census
##   year(s) indexed on year, age (ACY), parity

  # first we compute vertical parallelograms from the triangle data
  bTR <- bTR[bTR$Year %in% eTR$Year, ]
  eTR <- eTR[eTR$Year %in% bTR$Year, ]
  bVV <- reshapeLexisShapeData(aggregateLexisShape(bTR, "VV"), "VV", "births", NULL, NULL)
  eVV <- reshapeLexisShapeData(aggregateLexisShape(eTR, "VV"), "VV", "expos", NULL, NULL)

  wiyT <- wiyT[dimnames(wiyT)[[1]] %in% bVV$Year, , , drop = FALSE]
  
  # we then get age-specific fertility rates for the vertical parallelograms
  asfrVV <- calculate.asfr(bVV, eVV, "VV")

  # reshape this to a 3D array of year, age (ARDY), order - fi(y,t) in MP §5.2
  asfrVV <- reshape(asfrVV, varying = names(asfrVV)[5:ncol(asfrVV)], v.names = "ASFR",
                    timevar = "Order", times = names(asfrVV)[5:ncol(asfrVV)],
                    drop = names(asfrVV)[3:4], direction = "long")
  fiyt <- tapply(asfrVV$ASFR,
               list(asfrVV$Year, asfrVV$ARDY, asfrVV$Order),
               function(x){return(x)})

  censusYears <-dimnames(wiyT)[[1]]

  # now calculate wi(y, T + 1)
  wiyT1 <- array(NA,
                 dim = dim(wiyT),
                 dimnames = list(Year = as.numeric(censusYears) + 1,
                                 Age = dimnames(wiyT)[[2]],
                                 Parity = dimnames(wiyT)[[3]]))
  # ymin always has the distribution 1, 0, ..., 0
  wiyT1[, 1, ] <- c(replicate(dim(wiyT1)[1], 1), replicate(dim(wiyT1)[1] * (dim(wiyT1)[3] - 1), 0))
  # if we only have one census year then rowSums doesn't work as it needs a 2D
  # array and wiyT1[, y + 1, ] returns a vector in that case, so check the
  # number of years and define the function to use accordingly
  sumfn <- if (dim(wiyT)[1] > 1) rowSums else sum
  # note that parity indexing is always i + 1, i.e. index 1 is parity 0
  maxP <- dim(wiyT1)[3]
  for (y in 1:(dim(wiyT1)[2] - 1)) {
    wiyT1[, y + 1, 1] <- wiyT[, y, 1] - fiyt[censusYears, y, 1]
    for (i in 2:(maxP - 1)) {
      wiyT1[, y + 1, i] <- wiyT[, y, i] +
                           fiyt[censusYears, y, i - 1] -
                           fiyt[censusYears, y, i]
    }
    wiyT1[, y + 1, maxP] <- wiyT[, y, maxP] + fiyt[censusYears, y, maxP - 1]
    # age-parity weights must be non-negative
    wiyT1[, y + 1, ] <- ifelse(wiyT1[, y + 1, ] >= 0, wiyT1[, y + 1, ], 0)
    # sum of age-parity weights for each year and age must be 1
    wiyT1[, y + 1, ] <- wiyT1[, y + 1, ] / sumfn(wiyT1[, y + 1, ])
  }

  return(wiyT1)
}

