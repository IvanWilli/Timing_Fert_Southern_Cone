################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 564 $
## $Date: 2010-09-06 13:42:35 +0200 (Mo, 06. Sep 2010) $
## $Author: nash $
## $Id: parity.unk.redist.belowXtoZero.R 564 2010-09-06 11:42:35Z nash $
##
################################################################################

parity.unk.redist.belowXtoZero <-
function(parity, x, ...) {
## Redistributes females with unknown parity in populations by parity
## proportionally across all parity levels. Females with unknown age are
## unaffected.
##
## @inputs
## - parity is a data frame containing the parity data for a single year
## - x is the age below which unknowns will be distributed to parity 0,
##   above and equal to this age proportionally
## - ... is ignored (exists for compatibility)
## @returns
## - a data frame with the females with unknown parity with age < x redistributed
##   to parity 0 and age >= x redistributed proportionally across all parity
##   levels and RefCode set to -1 for rows which have been affected
  
  if (nrow(parity[parity$Parity == "UNK", ]) == 0) return(parity)
  .NotYetImplemented()
}

