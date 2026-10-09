################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 1007 $
## $Date: 2011-10-25 22:40:18 +0200 (Di, 25. Okt 2011) $
## $Author: Ed $
## $Id: calculateCohortBirthsMatrix.R 1007 2011-10-25 20:40:18Z Ed $
##
################################################################################

.calculateCohortBirthsMatrix <-
function(bTR, eTR, bottomFilter = 15, topFilter = 45) {
## Calculate a matrix of births per 10000 based on the given births and exposure
## Lexis triangle datasets
##
## @inputs
## - bTR is births data by order in Lexis triangles as a data frame
## - eTR is female population exposure data in Lexis triangles as a data frame
## - bottomFilter is whether to bottom-filter for cohorts with insufficient
##   observation period for a cohort fertility table, i.e. for only those
##   cohorts observed from age 15 or younger.
## - topFilter is whether to top-filter for cohorts with insufficient
##   observation period, i.e. for only those observed up to age 45 or older.
## @returns
## - a 3D array of cohort births per 10000 indexed on Cohort, Year, Order

  # discard upper triangles in the first year of data.
  # upper triangles are those where Year - Age == Cohort + 1
  discard <- bTR$Year == min(bTR$Year) & bTR$Year - bTR$Age == bTR$Cohort + 1
  bTR <- bTR[!discard, ]
  eTR <- eTR[!discard, ]
  
  # compute horizontal parallelograms from the remaining triangle data
  # the triangle leftovers at the end of the data series don't bother us
  # when calculating the births matrix
  bVH <- reshapeLexisShapeData(aggregateLexisShape(bTR, "VH"), "VH", "births")
  eVH <- reshapeLexisShapeData(aggregateLexisShape(eTR, "VH"), "VH", "expos")

  # we then get age-specific fertility rates for the horizontal parallelograms
  asfrVH <- calculate.asfr(bVH, eVH, "VH")

  # now we can calculate the births by birth order matrix, performing no filtering
  b <- calculate.b.cft(asfrVH, FALSE, FALSE)
  
  agesNum <- as.numeric(sub("[+-]", "", dimnames(b)[[2]], fixed = TRUE))
  
  # ensure that series are continuous, right-trim any that have a gap
  hasObs <- rep(FALSE, dim(b)[1])
  hasNA <- rep(FALSE, dim(b)[1])
  for (i in 1:dim(b)[2]) {
    hasObs <- hasObs | !is.na(b[, i, 1])
    hasNA <- hasNA | (hasObs & is.na(b[, i, 1]))
    b[, i, ] <- ifelse(rep(hasNA, dim(b)[3]) , NA, b[, i, ])
  }
  
  if (bottomFilter != FALSE) {
    # only include cohorts with at least one observation below or equal to some age (15 if TRUE)
    if (is.logical(bottomFilter) && (bottomFilter == TRUE)) bottomFilter <- 15
    b <- b[apply(b[, agesNum <= bottomFilter, 1], 1, function(x){!all(is.na(x))}), , , drop = FALSE]
  }

  return(b)
}

