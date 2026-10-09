################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 1005 $
## $Date: 2011-10-23 21:35:50 +0200 (So, 23. Okt 2011) $
## $Author: Ed $
## $Id: calculate.sdmab.R 1005 2011-10-23 19:35:50Z Ed $
##
################################################################################

calculate.sdmab <-
  function(asfr, shape, observeFrom = 15, observeTo = 50, a = 0.5, ...) {
##
## Calculate standard deviation in age at birth
##
## @inputs
## - asfr is a data frame, 3D array or path to file containing the aggregated (for the shape) age specific
##   fertility rate data
## - shape is one of
##      - "RR" for rectangles
##      - "VH" for horizontal parallelograms
## - observeFrom is the maximum age from which cohorts must have been observed
## - observeTo is the minumum age to which cohorts must have been observed
## - a is the average share of the period [x, x+1) lived before giving birth to a child
##   (see methods protocol § 6.3: we deal with only RR and VH here hence default 0.5)
## - ... is arguments potentially passed to read.table
## @returns
## - a data frame with the sdmab, or NULL if given a bad shape or data with no
##   sufficiently long observation periods

  # since procedure is almost identical to MAB and TFR then we just need
  # to define the function for (weighted) standard deviation and all the legwork
  # is done by a common function
  sdFn <-
    function(asfr) {
    x_bar <- asfr$Age + a
    asfr$s1 <- asfr$ASFR * x_bar   
    asfr$s2 <- asfr$ASFR * (x_bar ^ 2) 

    sum_s0 <- as.data.frame(tapply(asfr$ASFR, list(asfr[, 1], asfr$Order), sum, na.rm = TRUE))
    sum_s1 <- as.data.frame(tapply(asfr$s1, list(asfr[, 1], asfr$Order), sum, na.rm = TRUE))
    sum_s2 <- as.data.frame(tapply(asfr$s2, list(asfr[, 1], asfr$Order), sum, na.rm = TRUE))
    
    sqrt((sum_s0 * sum_s2) - (sum_s1 ^ 2)) / sum_s0
  }
  
  .calculate.mab.tfr(sdFn, asfr, shape, observeFrom, observeTo, paste("sd", if (shape == "VH") {"C"}, "MAB", sep = ""), ...)

}
