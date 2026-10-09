################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 1005 $
## $Date: 2011-10-23 21:35:50 +0200 (So, 23. Okt 2011) $
## $Author: Ed $
## $Id: calculateAgeParityDistribution.cumulative.R 1005 2011-10-23 19:35:50Z Ed $
##
################################################################################

calculateAgeParityDistribution.cumulative <-
function(bTR, eTR, observeFrom = 15, observeTo = 45, ...) {
## Calculate the estimated mid-year age- and parity- specific distribution (w)
## of women based on cumulating fertility of cohorts
##
## @inputs
## - bTR is births data by order in Lexis triangles as a data frame
## - eTR is female population exposure data in Lexis triangles as a data frame
## - observeFrom is the maximum age from which cohorts must be observed
## - observeTo is the minumum age to which cohorts must be observed
## - ... is for compatibility and is ignored
## @returns
## - a 3D array of estimated mid-year age- and parity specific distribution (w)
##   for the years from which the first cohort observed from age 15- reaches 45
##   indexed by year, parity, age

  # cohort births by birth order, filtering as requested
  b <- .calculateCohortBirthsMatrix(bTR, eTR, observeFrom, observeTo)
  # cohort parities
  l <- calculate.l.cft(b)$parities

  return(.calculateCumulativeAgeParityDistribution(l, observeFrom = observeFrom, observeTo = observeTo))
}

