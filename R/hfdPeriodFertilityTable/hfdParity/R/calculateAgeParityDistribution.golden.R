################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 1061 $
## $Date: 2014-05-06 12:38:05 +0200 (Di, 06. Mai 2014) $
## $Author: jasilioniene $
## $Id: calculateAgeParityDistribution.golden.R 1061 2014-05-06 10:38:05Z jasilioniene $
##
################################################################################

calculateAgeParityDistribution.golden <-
function(bTR, eTR, wiyT, goldenYear, observeFrom = 15, observeTo = 45, switchToCumulative = TRUE, ...) {
## Calculate the estimated mid-year age- and parity- specific distribution (w)
## of women based on a "golden" census
##
## @inputs
## - bTR is births data by order in Lexis triangles as a data frame
## - eTR is female population exposure data in Lexis triangles as a data frame
## - wiyT is the distribution on 1st January of the
##   census year(s), as a 3D array of year, age (ACY), parity
## - goldenYear is the census year to use as the 'golden' census
## - observeFrom is the maximum age from which cohorts must be observed for cumulation
## - observeTo is the minumum age to which cohorts must be observed for cumulation
## - switchToCumulative is whether to switch to a cumulative parity distribution
##   once cohorts have been observed for a sufficiently long period
## - ... is for compatibility and is ignored
## @returns
## - a 3D array of estimated mid-year age- and parity specific distribution (w)
##   based on cumulating data together with the 'golden' census

  if (is.data.frame(wiyT)) wiyT <- parity.prepare.matrix(wiyT)

  # start by getting the distribution using only cumulative parities - we
  # then know up to what year we need to generate the distribution using the
  # census data
  wcum <- if (switchToCumulative) calculateAgeParityDistribution.cumulative(bTR, eTR, observeFrom, observeTo) else NULL

  # years for which to generate the census-based estimations - if the cumulative
  # part could not be done due to a too-short observation period then this is
  # simply up to the end of the observation period
  firstYear <- goldenYear
  lastYear <- if ((!is.null(wcum)) && dim(wcum)[1] > 0) {
                as.numeric(dimnames(wcum)[[1]][1]) - 1
              } else {
                max(bTR$Year)
              }

  # if we have parity data for the year following the golden census then use
  # it to calculate the mid-year weights, otherwise use estimations
  wiyT1 <- if ((goldenYear + 1) %in% dimnames(wiyT)[[1]]) {
    wiyT[as.character(goldenYear + 1), , , drop = FALSE]
  } else {
    wiyTgolden <- wiyT[as.character(goldenYear), , , drop = FALSE]
    .calculateCensusPlusOneParityDistributions(bTR,
                                              eTR,
                                              wiyTgolden)
  }
  # if we took a slice out of a 3D array, it may now only be 2D, so force it back
  if (length(dim(wiyT1)) < 3) {
    dim(wiyT1) <- c(1, dim(wiyT1))
    dimnames(wiyT1) <- list(Year = goldenYear + 1,
                            Age = dimnames(wiyT)[[2]],
                            Parity = dimnames(wiyT)[[3]])
  }

  # trim the census data to only the year of the golden census and again ensure
  # a 3D result
  wiyT <- wiyT[as.character(goldenYear), , , drop = FALSE]
  
  # calculate the mid-year parity weights for the golden census year
  censusWeights <- .calculateCensusAgeParityWeights(wiyT, wiyT1)
  
  # there is only one year, so now simplify to a 2D array
  censusWeights <- censusWeights[1, , ]

  # calculate the parity distributions from the golden census
  w <- .calculateGoldenCensusBasedParityDistributions(
         censusWeights,
         .calculateCohortBirthsMatrix(bTR, eTR, FALSE, FALSE),
         goldenYear,
         firstYear:lastYear)
                                                      
  # now combine the golden census distributions with the cumulative ones
  # if necessary
  wfinal <- abind::abind(w, wcum, along = 1)
  names(dimnames(wfinal)) <- c("Year", "Age", "Parity")

  return (wfinal)
}

