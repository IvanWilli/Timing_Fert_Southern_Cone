################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 817 $
## $Date: 2010-11-04 09:07:49 +0100 (Do, 04. Nov 2010) $
## $Author: nash $
## $Id: calculate.patfr.R 817 2010-11-04 08:07:49Z nash $
##
################################################################################

calculate.patfr <-
function(pft, radix = 10000, ...) {
## Calculate period fertility index of total fertility from the given
## period fertility table
##
## @inputs
## - pft is the period fertility table as a data frame, 3D array or path to a file
##   - strictly, only the columns/indicators b1x ... bnpx are required
## - radix is the size of the table population
## - ... is arguments passed to read.table
## @returns
## - the period fertility index of total fertility as a data frame

  # ensure PFT is a data frame
  if (!(is.data.frame(pft) | is.array(pft))) pft <- .readInputData(pft, ...)
  if (is.array(pft)) pft <- array2dataframe.pft(pft)

  # get the birth columns
  bCols <- grep("^b[[:digit:]]+p?x$", names(pft), value = TRUE)

  # filter out the data we don't need and add a totals column
  pft <- pft[, c("Year", "x", bCols)]
  pft$b <- rowSums(pft[, bCols])

  # expand to one row per birth order
  pft <- reshape(pft, direction = "long", varying = names(pft[3:ncol(pft)]),
                 timevar = "Order", v.names = "Births",
                 times = names(pft[3:ncol(pft)]))

  # calculate sums
  patfr <- tapply(pft$Births,
                 list(pft$Year, pft$Order),
                 function (x) {
                   return(sum(x, na.rm = TRUE) / radix)
                 })
  # rename columns and add Year column
  dimnames(patfr)[[2]] <- sub("b([[:digit:]]*p?)x?", "PATFR\\1", dimnames(patfr)[[2]])
  names(dimnames(patfr)) <- c("Year", "Order")
  patfr <- cbind(Year = as.numeric(dimnames(patfr)[[1]]), patfr)

  # return as a data frame
  return(as.data.frame(patfr))
}

