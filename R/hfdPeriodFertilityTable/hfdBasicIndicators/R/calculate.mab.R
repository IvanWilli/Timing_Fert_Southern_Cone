################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 853 $
## $Date: 2010-11-23 09:33:43 +0100 (Di, 23. Nov 2010) $
## $Author: nash $
## $Id: calculate.mab.R 853 2010-11-23 08:33:43Z nash $
##
################################################################################

calculate.mab <-
  function(asfr, shape, observeFrom = 15, observeTo = 50, a = 0.5, ...) {
  ## Calculate mean ages at birth (MAB and MAB40) for the given age specific
  ## fertility rate dataset and shape
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
  ## - a data frame with the mab, or NULL if given a bad shape or data with no
  ##   sufficiently long observation periods
  
  # since procedure for TFR and MAB are almost identical then we just need
  # to define the function for MAB and all the legwork is done by a common function
  mabFn <-
    function(asfr) {
    # first calculate the numerator for the MAB of (x + a(x)) . ASFR,
    asfr$mabNum <- (asfr$Age + a) * asfr$ASFR
    
    as.data.frame(tapply(asfr$mabNum, list(asfr[, 1], asfr$Order), sum)) /
      as.data.frame(tapply(asfr$ASFR, list(asfr[, 1], asfr$Order), sum))
  }
  
  .calculate.mab.tfr(mabFn, asfr, shape, observeFrom, observeTo, "MAB", ...)
}
