################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 1070 $
## $Date: 2015-02-27 22:30:52 +0100 (Fr, 27. Feb 2015) $
## $Author: svnNash $
## $Id: calculate.adjtfr.R 1070 2015-02-27 21:30:52Z svnNash $
##
################################################################################

calculate.adjtfr <-
  function(tfr, mab, shape = "RR", ...) {
##
## Calculate adjusted TFR
##
## @inputs
## - tfr is the period total fertility rate as a data.frame in the usual
##   HFD format, or path to a file containing this
## - mab is the period mean age at birth as a data.frame in the usual
##   HFD format, or path to a file containing this
## - shape is always RR (Lexis squares, period data)
## - ... are further arguments which may be passed as arguments to
##   read.table in order to open files correctly
## @returns
## - a data.frame containing the adjusted TFR, NULL or an error
##   if data is unsuitable

  stopifnot(identical(shape, "RR"))
  
  if (is.null(tfr) || is.null(mab)) return(NULL)
  
  # make sure that inputs are data frames
  if (!is.data.frame(tfr)) tfr <- read.table.hfd(tfr, ...)
  if (!is.data.frame(mab)) mab <- read.table.hfd(mab, ...)
  
  # drop any xxx40 columns as we don't do ATFR40
  tfr <- tfr[, !grepl("40", names(tfr), fixed = TRUE)]
  mab <- mab[, !grepl("40", names(mab), fixed = TRUE)]

  # if have some order-specific data then drop any years without birth order data
  if ((("TFR1" %in% names(tfr)) && ("MAB1" %in% names(mab)))) {
    tfr <- tfr[!is.na(tfr$TFR1), ]
    mab <- mab[!is.na(mab$MAB1), ]
  }
  
  # we only calculate adjTFR using order-specific data and need at least 3 years of data: NULL result without
  if (nrow(tfr) < 4 || ncol(tfr) < 3) return(NULL)
  
  # we should now have the same number of rows and columns in both datasets
  stopifnot(nrow(tfr) == nrow(mab) && ncol(tfr) == ncol(mab))
  
  for (y in unique(tfr$Year)) {
    if (all((y + c(-1, 1)) %in% mab$Year)) {
      ri <- 0.5 * (mab[mab$Year == y + 1, 3:ncol(mab)] - mab[mab$Year == y - 1, 3:ncol(mab)])
      tfr[tfr$Year == y, 3:ncol(tfr)] <-
        tfr[tfr$Year == y, 3:ncol(tfr)] / (1 - ri)
      tfr[tfr$Year == y, 2] <- sum(tfr[tfr$Year == y, 3:ncol(tfr)])
    } else {
      tfr[tfr$Year == y, 2:ncol(tfr)] <- NA
    }
  }
  tfr <- tfr[!is.na(tfr[, 2]), ]
  
  names(tfr) <- sub("TFR", "adjTFR", names(tfr), fixed = TRUE)
  
  return (tfr)
}
