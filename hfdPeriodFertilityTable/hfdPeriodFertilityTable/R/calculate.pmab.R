################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 847 $
## $Date: 2010-11-10 15:14:03 +0100 (Mi, 10. Nov 2010) $
## $Author: nash $
## $Id: calculate.pmab.R 847 2010-11-10 14:14:03Z nash $
##
################################################################################

calculate.pmab <-
function(pft, a = 0.5, ...) {
## Calculate a period mean age at birth table from the given period fertility
## table
##
## @inputs
## - pft is the period fertility table as a data frame, array or path to file
##   - strictly, only the indicators b1x ... bnpx are required
## - a is the mean share of the age interval lived before giving birth
## - ... are arguments passed to read.table if pft is a path to a file
## @returns
## - the period mean age at birth table as a data frame

  # ensure PFT is a data frame
  if (!(is.data.frame(pft) | is.array(pft))) pft <- .readInputData(pft, ...)
  if (is.array(pft)) pft <- array2dataframe.pft(pft)

  # work out the birth columns
  bCols <- grep("^b[[:digit:]]+p?x$", names(pft), value = TRUE)
  
  # add a total table births column
  pft$b <- rowSums(pft[, bCols])

  bCols <- c("b", bCols)
  pmabNames <- sub("b([[:digit:]]*p?)x?", "TMAB\\1", bCols)

  # filter out the data we don't need and ensure age is numeric
  pft <- pft[, c("Year", "x", bCols)]
  if (!is(pft$x, "numeric")) {
    pft$x <- as.numeric(sub("[+-]", "", as.character(pft$x)))
  }
  
  # add some columns for the numerator of the pmab calculation
  numer <- (pft$x + a) * pft[, 3:ncol(pft)]
  names(numer) <- pmabNames
  pft <- cbind(pft, numer)

  # expand to one row per birth order
  pft <- reshape(pft, direction = "long",
                 varying = list(bCols, pmabNames),
                 timevar = "Order", v.names = c("Births", "TMAB"),
                 times = bCols)

  # calculate sums and divide
  pmab <- tapply(pft$TMAB,
                 list(pft$Year, pft$Order),
                 function (x) {
                   return(sum(x, na.rm = TRUE))
                 }) /
           tapply(pft$Births,
                 list(pft$Year, pft$Order),
                 function (x) {
                   return(sum(x, na.rm = TRUE))
                 })

  # add year, rename columns
  dimnames(pmab)[[2]] <- pmabNames
  pmab <- cbind(Year = as.numeric(dimnames(pmab)[[1]]), pmab)

  # return as data frame
  return(as.data.frame(pmab))
}

