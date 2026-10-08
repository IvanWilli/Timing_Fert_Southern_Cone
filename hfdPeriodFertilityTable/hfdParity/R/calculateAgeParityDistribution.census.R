################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 885 $
## $Date: 2011-01-11 10:44:30 +0100 (Di, 11. Jan 2011) $
## $Author: nash $
## $Id: calculateAgeParityDistribution.census.R 885 2011-01-11 09:44:30Z nash $
##
################################################################################

calculateAgeParityDistribution.census <-
function(bTR, eTR, wiyT, ...) {
## Calculate the estimated mid-year age- and parity- specific distribution (w)
## of women for one or more census years
##
## @inputs
## - bTR is births data by order in Lexis triangles as a data frame
## - eTR is female population exposure data in Lexis triangles as a data frame
## - wiyT is the parity distribution on 1st January of the census year(s),
##   as a 3D array on year, age (ACY), parity
## - ... is for compatibility and is ignored
## @returns
## - a 3D array of estimated mid-year age- and parity specific distribution (w)
##   for the census year(s)

  if (is.data.frame(wiyT)) wiyT <- parity.prepare.matrix(wiyT)

  # start by calculating the parity weightings from the census data
  censusWeights <-
    .calculateCensusAgeParityWeights(wiyT,
                                    .calculateCensusPlusOneParityDistributions(bTR, eTR, wiyT))
  # then the cohort births
  b <- .calculateCohortBirthsMatrix(bTR, eTR, FALSE, FALSE)
  # result has the same size as the census weights array in 1st and 3rd dimensions, births matrix in second dimension
  result <- array(NA, dim = c(dim(censusWeights)[1], dim(b)[2], dim(censusWeights)[3]), dimnames = list(Year = dimnames(censusWeights)[[1]], Age = dimnames(b)[[2]], Parity = dimnames(censusWeights)[[3]]))
  # perform the same calculation as for golden censuses, for each census year
  for (y in dimnames(censusWeights)[[1]]) {
    result[y, , ] <-
      .calculateGoldenCensusBasedParityDistributions(censusWeights[y,,],
                                                    b,
                                                    as.numeric(y),
                                                    as.numeric(y))[1, , ]
  }
  return(result)
}

