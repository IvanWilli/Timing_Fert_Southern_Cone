################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 862 $
## $Date: 2010-12-02 11:15:07 +0100 (Do, 02. Dez 2010) $
## $Author: nash $
## $Id: calculateAgeParityDistribution.register.R 862 2010-12-02 10:15:07Z nash $
##
################################################################################

calculateAgeParityDistribution.register <-
function(bTR, eTR, wiyT, ...) {
## Calculate the estimated mid-year age- and parity- specific distribution (w)
## of women for a series of years for which register data is available
##
## @inputs
## - bTR is births data by order in Lexis triangles as a data frame
## - eTR is female population exposure data in Lexis triangles as a data frame
## - censusAgeParityDistribution is the parity distributions on 1st January of
##   the census year(s), as a 3D array of year, age (ACY), parity
## - ... is for compatibility and is ignored
## @returns
## - a 3D array of estimated mid-year age- and parity specific distribution (w)
##   for the register year(s). For each year of register data where register
##   data for the following year is available, these are used directly. For
##   years where this data is not available (e.g. the last year of the
##   available series), the estimation method as used for census data is used
##   (§5.2 of the MP)


  if (is.data.frame(wiyT)) wiyT <- parity.prepare.matrix(wiyT)

  # for all except the last year, wiyT + 1 is directly available
  wiyT1 <- array(NA, dim = dim(wiyT), dimnames = dimnames(wiyT))
  dimnames(wiyT1)[[1]] <- as.numeric(dimnames(wiyT1)[[1]]) + 1
  wiyT1[1:(dim(wiyT)[1] - 1), , ] <- wiyT[2:dim(wiyT)[1], , ]
  
  # for the last year, we use the same calculation as for (golden)-census
  # we need to send a 3D array to that function, so (re)create it for only the
  # last year. However, we can only do this if we have births and exposure data
  # for that year, otherwise we'll just drop it
  Tmax <- as.numeric(dimnames(wiyT)[[1]][dim(wiyT)[1]])
  if (Tmax %in% bTR$Year && Tmax %in% eTR$Year) {
    lastYear <- wiyT[dim(wiyT)[1], , ]
    dim(lastYear) <- c(1, dim(lastYear))
    dimnames(lastYear) <- list(dimnames(wiyT)[[1]][dim(wiyT)[1]],
                               dimnames(wiyT)[[2]],
                               dimnames(wiyT)[[3]])
    wiyT1[dim(wiyT1)[1], , ] <-
      .calculateCensusPlusOneParityDistributions(bTR, eTR, lastYear)
  } else {
    wiyT <- wiyT[1:(dim(wiyT)[1] - 1), , ]
    wiyT1 <- wiyT1[1:(dim(wiyT1)[1] - 1), , ]
  }

  # final register weights according to formula 8.6
  wix <- .calculateCensusAgeParityWeights(wiyT, wiyT1)

  # first and last cohorts for which we could generate age-parity distributions
  # based on the register data
  years <- as.numeric(dimnames(wix)[[1]])
  ages <- as.numeric(dimnames(wix)[[2]])
  firstCohort = min(years) - max(ages) # 55
  lastCohort = max(years) - min(ages) # 12

  # create the left- (and right) censored cohort parity matrix for years from
  # the register
  l <- array(NA,
             c(length(firstCohort:lastCohort), length(ages), dim(wix)[3]),
             dimnames = list(firstCohort:lastCohort,
                             ages,
                             sub("w", "l", dimnames(wix)[[3]], fixed = TRUE)))
  for (c in firstCohort:lastCohort) {
    for (x in ages) {
      if ((yr <- c + x) %in% years) {
        l[as.character(c), as.character(x), ] <-
          10000 * wix[as.character(yr), as.character(x), ]
      }
    }
  }

  return(.calculateCumulativeAgeParityDistribution(l, years))
}

