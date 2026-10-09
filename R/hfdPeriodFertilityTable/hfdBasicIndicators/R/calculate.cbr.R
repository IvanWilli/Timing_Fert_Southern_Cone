################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 1070 $
## $Date: 2015-02-27 22:30:52 +0100 (Fr, 27. Feb 2015) $
## $Author: svnNash $
## $Id: calculate.cbr.R 1070 2015-02-27 21:30:52Z svnNash $
##
################################################################################

calculate.cbr <- function(births, expos, shape, ...) {
##
## Calcualte crude birth rates
##
## @inputs
## - births is the birth data by Lexis TR, year and age (Lexis RR) or year and cohort (Lexis VV)
##   as a data.frame, 3D array or path to file
## - expos is the exposure data by Lexis TR, year and age (Lexis RR) or year and cohort (Lexis VV)
##   as a data.frame, 3D array or path to file. Note that this should be
##   TOTAL (male+female) exposure for ALL ages and not only female for the reproductive ages.
## - shape is the shape in which the data is held (TR, RR or VV)
## - ... are arguments passed to read.table if births or expos the path to a file
## @returns
## - a data.frame with the crude birth rates by year

  stopifnot(shape %in% c("RR", "VV", "TR"))

  totBirths <- calculate.totbirths(births, shape, ...)
  
  if (!(is.array(expos) | is.data.frame(expos))) expos <- read.table.hfd(expos, ...)
  if (is.array(expos)) expos <- reshapeLexisShapeData(expos, shape, "expos")
  
  totExpos <- aggregate(expos[, totalColPositionForShape(shape)], list(Year = expos$Year), sum, na.rm = TRUE)

  stopifnot(nrow(totBirths) == nrow(totExpos))
  
  for (i in 2:ncol(totBirths)) {
    totBirths[, i] <- 1000 * totBirths[, i] / totExpos[, 2]
  }
  
  names(totBirths)[2:ncol(totBirths)] <- sub("B", "CBR", names(totBirths)[2:ncol(totBirths)], fixed = TRUE)
  
  return(totBirths)
}
