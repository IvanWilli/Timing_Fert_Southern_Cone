################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 1070 $
## $Date: 2015-02-27 22:30:52 +0100 (Fr, 27. Feb 2015) $
## $Author: svnNash $
## $Id: calculate.totbirths.R 1070 2015-02-27 21:30:52Z svnNash $
##
################################################################################

calculate.totbirths <- function(births, shape, ...) {
## Calculate total births (at each birth order) per year
##
## @inputs
## - births is the birth data by year and age (Lexis RR) or year and cohort (Lexis VV)
##   as a data.frame, 3D array or path to file
## - shape is the shape in which the data is held (RR, VV or RR)
## - ... are arguments passed to read.table if births is the path to a file
## @returns
## - a data.frame with the birth data aggregated by year
  stopifnot(shape %in% c("RR", "VV", "TR"))
  
  if (!(is.array(births) | is.data.frame(births))) births <- read.table.hfd(births, ...)
  if (is.array(births)) births <- reshapeLexisShapeData(births, shape, "births")
  
  res <- aggregate(births[, totalColPositionForShape(shape):ncol(births)], list(Year = births$Year), sum, na.rm = TRUE)
  
  return(res)
}
