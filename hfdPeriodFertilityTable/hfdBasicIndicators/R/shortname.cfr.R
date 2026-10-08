################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 1005 $
## $Date: 2011-10-23 21:35:50 +0200 (So, 23. Okt 2011) $
## $Author: Ed $
## $Id: shortname.cfr.R 1005 2011-10-23 19:35:50Z Ed $
##
################################################################################

shortname.cfr <-
function(shape) {
## Get the short name of the CFR table for the given shape
##
## @inputs
## - shape is one of
##      - "RR" for rectangles
##      - "VH" for horizontal parallelograms
##      - "VV" for vertical parallelograms
##
## @returns
## - the short name of the cfr table (cpfr for RR and VV, ccfr for VH) or NULL
   return(if (shape %in% c("RR", "VV")) "cpfr" else if (shape == "VH") "ccfr" else NULL)
}

