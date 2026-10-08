################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 905 $
## $Date: 2011-01-13 14:30:18 +0100 (Do, 13. Jan 2011) $
## $Author: nash $
## $Id: calculate.E.pft.R 905 2011-01-13 13:30:18Z nash $
##
################################################################################

calculate.E.pft <-
function(w, exposRR, ...) {
## Calculate female population exposure by parity from the given data
##
## @inputs
## - w is the relative distribution of female population by parity as a 3D array
##   indexed on year, age, order, a data frame or a path to a file
## - exposRR is the female population exposure by Lexis squares as a data frame, a 2D array
##   indexed on year and age, a 3D array indexed on year, age, indicator (3rd dimension is length 1)
##   or the path to a file
## - ... are arguments passed to read.table if one of the arguments is a path to a file
##   - may be a list with entries w and exposRR, each containing the arguments
## @returns
## - a 3D array of female population exposure by parity
##   indexed on year, age, parity

  # read inputs from files if necessary
  if (!(is.data.frame(exposRR) || is.array(exposRR))) exposRR <- .readInputData(exposRR, ...)
  if (!(is.data.frame(w) || is.array(w))) w <- .readInputData(w, ...)

  # first get the inputs into 3D arrays
  if (is.data.frame(exposRR)) {
    exposRR <- .convertInputDataFrameToArray(exposRR)
  }
  if (length(dim(exposRR)) == 2) {
    dnames <- dimnames(exposRR)
    dim(exposRR) <- c(dim(exposRR), 1)
    dimnames(exposRR) <- list(Year = dnames[[1]], Age = dnames[[2]], Indicator = "Exposure")
  }
  if (is.data.frame(w)) {
    w <- .convertInputDataFrameToArray(w)
  }
  # assume w is 3D

  # we then work out what years and ages we can calculate the exposure for
  wYears <- dimnames(w)[[1]]
  eYears <- dimnames(exposRR)[[1]]
  years <- as.character(wYears[wYears %in% eYears])
  wAges <- sub("[+-]", "", dimnames(w)[[2]])
  eAges <- sub("[+-]", "", dimnames(exposRR)[[2]])

  # now trim the exposure and weighting data to only those years
  # need drop = FALSE to stop w being turned to a 2D array if we only have 1 year
  exposRR <- exposRR[years, eAges %in% wAges, , drop = FALSE]
  w <- w[years, wAges %in% eAges, , drop = FALSE]

  # now we can calculate the estimated female population exposure by parity
  E <- array(NA, dim = dim(w), dimnames = dimnames(w))
  for (i in 1:dim(w)[3]) {
    E[, , i] <- w[, , i] * exposRR[, , 1] # exposRR only has Total
  }

  dimnames(E)[[3]] <- sub("w", "E", dimnames(E)[[3]], fixed = TRUE)
  return(E)
}

