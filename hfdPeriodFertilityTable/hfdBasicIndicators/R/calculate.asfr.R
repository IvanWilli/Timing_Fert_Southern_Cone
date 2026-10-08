################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 1070 $
## $Date: 2015-02-27 22:30:52 +0100 (Fr, 27. Feb 2015) $
## $Author: svnNash $
## $Id: calculate.asfr.R 1070 2015-02-27 21:30:52Z svnNash $
##
################################################################################

calculate.asfr <-
function(births, expos, shape, ...) {
## Calculate age specific fertility rates for given shape with given
## births and exposure data
##
## @inputs
## - births is a data frame, array or path to file containing the aggregated (for the shape) birth data
## - expos is a data frame, array or path to file containing the aggregated (for the shape) exposure data
## - shape is one of
##      - "RR" for rectangles
##      - "VV" for vertical parallelograms
##      - "VH" for horizontal parallelograms
## - ... are arguments potentially passed to read.table (see doc for .readInputFile)
## @returns
## - a data frame containing the calculated ASFR table, or NULL if a bad shape

  stopifnot(shape %in% c("TR", "RR", "VV", "VH"))
  
  # make sure that inputs are data frames
  if (!(is.array(births) | is.data.frame(births))) births <- read.table.hfd(births, ...)
  if (!(is.array(expos) | is.data.frame(expos))) expos <- read.table.hfd(expos, ...)
  if (is.array(births)) births <- reshapeLexisShapeData(births, shape, "births")
  if (is.array(expos)) expos <- reshapeLexisShapeData(expos, shape, "expos")
  
  stopifnot(nrow(births) == nrow(expos))
  
  # position of column with totals in it:
  totalCol <- totalColPositionForShape(shape)
  # factor columns
  asfr <- births[, 1:(totalCol - 1)]
  # remaining columns as births/expos
  # total is always called ASFR
  asfr$ASFR <- births[, totalCol] / expos[, totalCol]
  if (ncol(births) > totalCol) {
    # birth orders B1:Bxp become ASFR1:ASFRxp, if present
    for(b in names(births)[(totalCol + 1):ncol(births)]) {
      asfr[[sub("B", "ASFR", b, fixed = TRUE)]] <- births[[b]] / expos[, totalCol]
    }
  }

  rownames(asfr) <- NULL
  
  return(asfr)
}

