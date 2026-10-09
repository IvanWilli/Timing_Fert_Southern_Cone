################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 1007 $
## $Date: 2011-10-25 22:40:18 +0200 (Di, 25. Okt 2011) $
## $Author: Ed $
## $Id: calculate.tfr.R 1007 2011-10-25 20:40:18Z Ed $
##
################################################################################

calculate.tfr <-
  function(asfr, shape, observeFrom = 15, observeTo = 50, ...) {
  ## Calculate total fertility rates (TFR and TFR40) for the given age specific
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
  ## - ... are named arguments potentially passed to read.table
  ## @returns
  ## - a data frame with the tfr, or NULL if given a bad shape or data with no
  ##   sufficiently long observation periods
  
  # since procedure for TFR and MAB are almost identical then we just need
  # to define the function for TFR and all the legwork is done by a common function
  tfrFn <- 
    function(asfr) {
    as.data.frame(tapply(asfr$ASFR, list(asfr[, 1], asfr$Order), sum))
  }
  
  .calculate.mab.tfr(tfrFn, asfr, shape, observeFrom, observeTo, if (shape == "RR") "TFR" else "CF", ...)
}

