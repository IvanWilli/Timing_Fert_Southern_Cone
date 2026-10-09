################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 1059 $
## $Date: 2012-09-05 15:52:24 +0200 (Mi, 05. Sep 2012) $
## $Author: kostova $
## $Id: calculateCumulativeAgeParityDistribution.R 1059 2012-09-05 13:52:24Z kostova $
##
################################################################################

.calculateCumulativeAgeParityDistribution <-
function(l, years = NULL, observeFrom = 15, observeTo = 45) {
## Calculate the estimated mid-year age- and parity- specific distribution (w)
## of women based on cumulating a cohort parity matrix
##
## @inputs
## - l is the cohort parity matrix as a 3D array indexed on cohort, age, parity
## - years is the range of years for which the distribution should be calculated
##   - if NULL then it will be produced for the years from which the first
##     cohort continuously observed from age observeFrom reaches observeTo until
##     the last year of the observations
## - observeFrom is the maximum age from which cohorts must be observed
## - observeTo is the minumum age to which cohorts must be observed
## @returns
## - a 3D array of estimated mid-year age- and parity specific distribution (w)
##   indexed by year, age, parity - this may be empty if an insufficient time
##   series of observations was supplied to create a matrix for years. In this
##   case, the 1st array dimension (years) will be 0
  firstCohort <- as.integer(dimnames(l)[[1]][1])
  lastCohort <- as.integer(dimnames(l)[[1]][dim(l)[1]])

  # for convenience we gather some data on the ages (usually be 12..55)
  ages <- as.integer(dimnames(l)[[2]])
  xmin <- ages[1]
  xmax <- ages[length(ages)]

  fromWeightings <- !is.null(years)

  if (!fromWeightings) {
    # for the year dimension we need to identify the minimum age at which we
    # have data in l0 for the first cohort in l observed from the observeFrom age
    # (which will usually be 15)
    obsF <- as.character(observeFrom)
    if (dim(l)[1] > 0) firstCohort <- as.integer(dimnames(l)[[1]][min(row(l[, obsF, ])[!is.na(l[, obsF, ])])])

    # we can then calculate the relevant observation years, if any
    years <- if ((length(firstCohort) > 0) && (firstCohort + observeTo <= lastCohort + xmin)) {
               (firstCohort + observeTo):(lastCohort + xmin)
             } else c()
  }

  # now we can create a correctly dimensioned and named array
  w <- array(NA, dim = c(length(years), dim(l)[2:3]),
                 dimnames = list(Year = years,
                                 Age = ages,
                                 Parity = sub("l", "w", dimnames(l)[[3]], fixed = TRUE)))

  # calculate preliminary w according to formulae 8.2 for xmin, 8.3 for
  # xmin < x < xmax and 8.4 for xmax
  # note that indexes for orders are always i+1, i.e. order 0 is index 1
  for(t in years) {
    w[as.character(t), as.character(xmin), ] <- c(1, rep(0, dim(w)[3] - 1))
    for (x in ages[2:(length(ages) - 1)]) { # age for xmin < x < xmax
      w[as.character(t), as.character(x), ] <-
        if((as.character(t - x) %in% dimnames(l)[[1]]) && (as.character(t - x - 1) %in% dimnames(l)[[1]])) {
          (l[as.character(t - x), as.character(x), ]
           + l[as.character(t - x - 1), as.character(x + 1), ]) / (2 * 10000)
          # l0(xmin, t-xmin) is always 10000
        } else NA
    }
    w[as.character(t), as.character(xmax), ] <-
      if(t - xmax >= firstCohort) {
        l[as.character(t - xmax), as.character(xmax), ] / 10000
          # l0(xmin, t-xmin) is always 10000
      } else NA

    # for each year and age, w must be normalised such that sum(wi) = 1
    w[as.character(t), , ] <- t(apply(w[as.character(t), , ], 1,
                                      function(rowData) {
                                        return(rowData / sum(rowData))
                                      }))
  }
  
  # remove any years for which we do not have a continuous series of weightings in the required range
  w <- w[apply(w[, as.character(observeFrom:(observeTo - 1)), 1, drop = FALSE], 1, function(x){!any(is.na(x))}), , , drop = FALSE]

  return(w)
}

