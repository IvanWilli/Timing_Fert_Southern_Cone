################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 547 $
## $Date: 2010-09-02 10:36:31 +0200 (Do, 02. Sep 2010) $
## $Author: nash $
## $Id: totalColPositionForShape.R 547 2010-09-02 08:36:31Z nash $
##
################################################################################

totalColPositionForShape <-
function(shape) {
## Get the position of the total column for a particular Lexis shape
##
## @inputs
## - shape is one of
##      - "TR" for triangles
##      - "RR" for rectangles
##      - "VV" for vertical parallelograms
##      - "VH" for horizontal parallelograms
##
## @returns
## - the position of the total column (4 for TR and VV, 3 for RR and VH)
  if (shape %in% c("TR", "VV")) 4 else 3
}

