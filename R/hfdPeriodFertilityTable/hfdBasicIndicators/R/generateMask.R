################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 833 $
## $Date: 2010-11-08 13:08:23 +0100 (Mo, 08. Nov 2010) $
## $Author: nash $
## $Id: generateMask.R 833 2010-11-08 12:08:23Z nash $
##
################################################################################

.generateMask <- function(asfr, observeFrom, observeTo = NULL) {
## generate a mask indicating which rows for each year should
## have NAs replaced with 0 to simplify handling of NAs in 
## calculations
  ages <- unique(asfr[, 2])
  ages <- as.numeric(sub("[+-]", "", as.character(ages)))
  lowerAges <- which(ages < observeFrom)
  aFrom <- which(ages == observeFrom)
  nLower <- length(lowerAges)
  if (!is.null(observeTo)) {
    upperAges <- which(ages >= observeTo)
    nUpper <- length(upperAges)
    aTo <- min(upperAges)
  } else nUpper <- 0
  return(
    tapply(asfr$ASFR,
           asfr[1],
           function(x) {
             res <- is.na(x) & (!is.na(aFrom)) & (if (is.null(observeTo)) (ages < observeFrom) else (ages < observeFrom | ages >= observeTo))
             names(res) <- ages
             # if ages in the lower age range are masked, then any
             # ages below these must also be masked
             if (nLower > 1)
               res[lowerAges[1:(nLower - 1)]] <-
                 res[lowerAges[1:(nLower - 1)]] |
                 ((!is.na(x[aFrom]) &
                  sapply(lowerAges[2:nLower],
                         function(x) {any(res[x:nLower])})))
             
             # if ages in the upper age range are masked then any
             # ages above these must also be masked
             if (nUpper > 1)
               res[upperAges[2:nUpper]] <-
                 res[upperAges[2:nUpper]] |
                 ((!is.na(x[aTo - 1])) &
                  sapply(upperAges[1:(nUpper - 1)],
                         function(x) {any(res[aTo:x])}))
             # if all values are NA then mask the whole range
             # (hack to avoid problems with CFR)
             if (all(is.na(x))) res[] <- TRUE
             return(res)
           }))
}
