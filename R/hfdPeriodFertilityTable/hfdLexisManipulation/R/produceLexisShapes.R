################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 1027 $
## $Date: 2011-11-27 20:58:55 +0100 (So, 27. Nov 2011) $
## $Author: Ed $
## $Id: produceLexisShapes.R 1027 2011-11-27 19:58:55Z Ed $
##
################################################################################

produceLexisShapes <-
function(TRdata, shape, dataType, minAge = 12, maxAge = 55, ...) {
## Produce a lexis shape dataset from the given input triangle dataset
##
## @inputs
## - TRdata is the Lexis triangle dataset
## - shape is one of
##      - "RR" for rectangles (calendar year, age in completed years)
##      - "VV" for vertical parallelograms (year of birth, age in completed years)
##      - "VH" for horizontal parallelograms (year of birth, age reached during year)
## - dataType is the type of data ("births" or "expos")
## - minAge is for VV data the minimum ARDY to include in the data frame, ignored otherwise
## - maxAge is for VV data the maximum ARDY to include in the data frame, ignored otherwise
## - ... are arguments which may be passed through to read.table
## @returns
## - a sorted data table containing the aggregated Lexis shape data, or null if insufficient data

  # this is just a wrapper function for convenience
  return(reshapeLexisShapeData(
           aggregateLexisShape(
             preprocessLexisTriangles(TRdata, shape, dataType, ...),
             shape),
           shape, dataType, minAge, maxAge))
}

