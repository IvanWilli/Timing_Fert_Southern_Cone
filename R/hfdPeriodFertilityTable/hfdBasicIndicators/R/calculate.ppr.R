################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 1070 $
## $Date: 2015-02-27 22:30:52 +0100 (Fr, 27. Feb 2015) $
## $Author: svnNash $
## $Id: calculate.ppr.R 1070 2015-02-27 21:30:52Z svnNash $
##
################################################################################

calculate.ppr <-
function(ctfr, shape = "VH", ...) {
## Calculate parity progression ratios (MAB and MAB40) for the given cohort
## total fertility rate dataset and shape
##
## @inputs
## - ctfr is a data frame or path to file containing the cohort total fertility rate dataset
##   - columns "Cohort", "CCF" are assumed
##   - additionally "CCF1", "CCF2", "CCF3" ... "CCFxp" are assumed where
##     x is the maximum birth order
##   - additional columns for CCF40 may be present
## - shape is "VH"
## @returns
## - a data frame with the PPR, or NULL if given a bad shape or bad/missing ctfr
##   data (e.g. NULL, or without birth orders, or an insufficient time series)

  stopifnot(shape == "VH")
  
  if (is.null(ctfr) || ncol(ctfr) < 5) return(NULL)

  # make sure that input is a data frame
  if (!is.data.frame(ctfr)) ctfr <- read.table.hfd(ctfr, ...)

  # we can only calculate PPR for cohorts with a CCF so trim those
  # who only have CCF40 values
  cohorts <- unique(ctfr[!is.na(ctfr$CCF1), "Cohort"])
  ctfr <- ctfr[ctfr$Cohort %in% cohorts, ]

  # may also need to ensure that factor levels are trimmed
  if (is.factor(ctfr$Cohort)) {
    levels(ctfr$Cohort) <- ifelse(levels(ctfr$Cohort) %in% cohorts,
                                  levels(ctfr$Cohort), NA)
  }

  # we could just have filtered out all the data rows - in this case just quit
  if (nrow(ctfr) == 0) return(NULL)

  # create the ppr table column-by-column
  ppr <- data.frame(ctfr[, "Cohort"])
  names(ppr)[1] <- "Cohort"
  ppr$PPR0_1 <- ctfr[, "CCF1"]

  # work out the maximum parity from the name of the column CCF(x)p in the input
  maxPar <-
    as.numeric(gsub("CCF([[:digit:]]+)p$",
               "\\1",
               grep("CCF[[:digit:]]+p$", names(ctfr), value = "TRUE"))) - 1
  
  for (i in 2:maxPar) {
    ppr[[paste("PPR", i - 1, "_", i, sep = "")]] <-
      ctfr[[paste("CCF", i, sep = "")]] / ctfr[[paste("CCF", i - 1, sep = "")]]
  }
  
  rownames(ppr) <- NULL
  
  return(ppr)
}
