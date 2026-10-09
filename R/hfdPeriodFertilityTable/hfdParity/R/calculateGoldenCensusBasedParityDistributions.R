################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 842 $
## $Date: 2010-11-09 16:49:10 +0100 (Di, 09. Nov 2010) $
## $Author: nash $
## $Id: calculateGoldenCensusBasedParityDistributions.R 842 2010-11-09 15:49:10Z nash $
##
################################################################################

.calculateGoldenCensusBasedParityDistributions <-
function(censusWeights, b, goldenYear, years) {
## Calculate the parity distributions for years based on a golden census
##
## @inputs
## - censusWeights is an array of mid-year age-parity distribution estimates
##   for the golden census year indexed on order, age (ACY)
## - b is the birth data arranged as a 3D matrix of
##   cohort, age, birth order
## - goldenYear is the census year to use as the 'golden' census
## - years is the range of years for which to calculate the distributions
## @returns
## - the parity distributions organised as a 3D array on year, age, parity

  if (length(dim(censusWeights)) == 3) {
    censusWeights <- censusWeights[as.character(goldenYear), , ]
  }

  # first and last cohorts which we could generate age-parity distributions
  # based on the golden census
  ages <- as.numeric(dimnames(b)[[2]])
  firstCohort = goldenYear - max(ages) # usually 55
  lastCohort = goldenYear - min(ages) # usually 12

  # bootstrap the cohort parity matrix for years from golden census
  l <- array(NA,
             dim = c(length(firstCohort:(max(years) - min(ages))), dim(b)[2:3]),
             dimnames = list(Cohort = firstCohort:(max(years) - min(ages)),
                             Age = ages,
                             Parity = paste("l", 1:dim(b)[3] - 1, "x", sep = "")))
  for (c in firstCohort:lastCohort) {
    for (x in ages) {
      if (c + x == goldenYear) {
        l[as.character(c), as.character(x), ] <-
          10000 * censusWeights[as.character(x), ]
      }
    }
  }
  # bootstrap the remaining years, if there are any
  y <- dimnames(l)[[1]][as.numeric(dimnames(l)[[1]]) > lastCohort]
  if (length(y) > 0) l[y, as.character(min(ages)), ] <-
    c(replicate(length(y), 10000), replicate((dim(l)[3] - 1) * length(y), 0))
  # do the remainder of the parity calculation - we can ignore the
  # corrections matrix
  l <- calculate.l.cft(b, l)$parities

  # calculate the mid-year parity distributions for the range from
  # the golden census
  w <- .calculateCumulativeAgeParityDistribution(l, years)
  
  return(w)
}

