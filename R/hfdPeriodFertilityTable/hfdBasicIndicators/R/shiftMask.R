################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 833 $
## $Date: 2010-11-08 13:08:23 +0100 (Mo, 08. Nov 2010) $
## $Author: nash $
## $Id: shiftMask.R 833 2010-11-08 12:08:23Z nash $
##
################################################################################

.shiftMask <- function(asfr, mask, observeFrom) {
  ## shift mask up one age for masking cumulative function
  # listify ASFR
  ages <- unique(asfr[, 2])
  ages <- as.numeric(sub("[+-]", "", as.character(ages)))
  lowerAges <- which(ages < observeFrom)
  asfr <- split(asfr$ASFR, asfr[, 1])
  mapply(
    function(asfr, mask){
      res <- c(mask[1], mask[2:length(lowerAges)] & mask[1:(length(lowerAges) - 1)], is.na(asfr[length(lowerAges) + 1]) && mask[length(lowerAges)], mask[(length(lowerAges) + 2):length(mask)])
      names(res) <- ages
      return(res)
    }, asfr, mask, SIMPLIFY = FALSE)
}
