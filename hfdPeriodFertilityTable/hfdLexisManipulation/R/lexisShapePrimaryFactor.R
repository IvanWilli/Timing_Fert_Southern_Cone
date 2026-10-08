################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 547 $
## $Date: 2010-09-02 10:36:31 +0200 (Do, 02. Sep 2010) $
## $Author: nash $
## $Id: lexisShapePrimaryFactor.R 547 2010-09-02 08:36:31Z nash $
##
################################################################################

lexisShapePrimaryFactor <-
function(shape) {
## Get the primary factor for a Lexis shape
## This is the first column of the output table
##
## @inputs
## - shape is one of
##      - "RR" for rectangles (primary = year, secondary = age)
##      - "VV" for vertical parallelograms (primary = year, secondary = cohort)
##      - "VH" for horizontal parallelograms (primary = cohort, secondary = age)
##
## @returns
## - the name of the primary factor, or NULL if shape was invalid
  return(switch(shape, RR = "Year", VV = "Year", VH = "Cohort", NULL))
}

