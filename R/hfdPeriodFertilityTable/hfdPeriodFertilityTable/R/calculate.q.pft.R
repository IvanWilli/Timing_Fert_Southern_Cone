################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 858 $
## $Date: 2010-12-01 08:22:21 +0100 (Mi, 01. Dez 2010) $
## $Author: nash $
## $Id: calculate.q.pft.R 858 2010-12-01 07:22:21Z nash $
##
################################################################################

calculate.q.pft <-
function(m, a = 0.5, filterPlausible = FALSE, ...) {
## Calculate the conditional probability of an i-th birth
##
## @inputs
## - m is the conditional age-specific fertility rates as a named
##   3D array of Year, Age, Order, a data.frame or the path to a file
## - a is the average share of the age interval [x,x+1] lived before giving
##   birth to a child (MP§8.3: "We assume that all a(x) values are equal to 0.5 for any
##   age x and birth order i."). This may be supplied as anything that is compatible
##   for operations with m (single value, vector (by year), 2D array (by year and age),
##   3D array (by year, age and order))
## - filterPlausible is a boolean indicating whether implausible values (qi > 1)
##   should be filtered out (set to NA)
##   - TRUE = qi > 1 will be set to NA
##   - FALSE = qi > 1 will be left as-is
## - ... are additional arguments that may be passed to read.table
## @returns
## - a named 3D array of the same dimensions as m containing the conditional
##   probabilities

  # read data from file if necessary
  if (!(is.data.frame(m) || is.array(m))) m <- .readInputData(m, ...)
  
  # get the inputs into arrays
  if (is.data.frame(m)) {
    m <- .convertInputDataFrameToArray(m)
  }
  
  res <- m / (1 + ((1 - a) * m))
  dimnames(res)[[3]] <- sub("m", "q", dimnames(res)[[3]], fixed = TRUE)
  
  # filter for plausibility, if desired
  if (filterPlausible) {
    res[is.finite(res) & res > 1] <- NA
  }
  
  return(res)
}
