################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 885 $
## $Date: 2011-01-11 10:44:30 +0100 (Di, 11. Jan 2011) $
## $Author: nash $
## $Id: calculateCensusAgeParityWeights.R 885 2011-01-11 09:44:30Z nash $
##
################################################################################

.calculateCensusAgeParityWeights <-
function(wiyT, wiyT1) {
## Calculate the census age-parity distribution estimates for census years
## based on the age-parity distribution on 1st January of the census year using
## the method described in §5.2 of the Methods Protocol
##
## @inputs
## - wiyT is the distribution on 1st January of the
##   census year(s), as a 3D array on year, age (ACY), parity
## - wiyT1 is the actual or estimated distribution on 1st January of the following
##   year, as a 3D array on year, age (ACY), parity
## @returns
## - an array of mid-year age-parity distribution estimates for the census
##   year(s) indexed on year, age (ACY), order

  wiyT <- wiyT[dimnames(wiyT)[[1]] %in% (as.numeric(dimnames(wiyT1)[[1]]) - 1), , , drop = FALSE]

  # final result according to formula 8.6
  wix <- (wiyT[, 1:(dim(wiyT)[2] - 1), , drop = FALSE] + wiyT1[, 2:dim(wiyT1)[2], , drop = FALSE]) * 0.5

  # correct and beautify the dimension names
  dimnames(wix) <-
    list(Year = dimnames(wiyT)[[1]],
         Age = dimnames(wiyT)[[2]][2:dim(wiyT)[2]],
         Parity = paste("w", 1:dim(wix)[3] - 1, c(rep("x", dim(wix)[3] - 1), "px"), sep = ""))

  return (wix)
}

