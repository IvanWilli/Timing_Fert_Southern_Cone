################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 1070 $
## $Date: 2015-02-27 22:30:52 +0100 (Fr, 27. Feb 2015) $
## $Author: svnNash $
## $Id: calculate.mab.tfr.R 1070 2015-02-27 21:30:52Z svnNash $
##
################################################################################

.calculate.mab.tfr <-
function(fn, asfr, shape, observeFrom = 15, observeTo = 50, colName, ...) {
## Either MAB or TFR (actual calculation performed by fn, with names
## of columns in outputs controlled by colName)
##
## @inputs
## - fn is a function to calculate an indicator (MAB or TFR) from the ASFR,
##   taking one argument being the long format ASFR data (one row per Year/Cohort-Age-Order)
## - asfr is a data frame, 3D array or path to file containing the aggregated (for the shape) age specific
##   fertility rate data
## - shape is one of
##      - "RR" for rectangles
##      - "VH" for horizontal parallelograms
## - observeFrom is the maximum age from which cohorts must have been observed
## - observeTo is the minumum age to which cohorts must have been observed
## - colName is the base of the names of the columns in the output
## - ... is arguments potentially passed to read.table
## @returns
## - a data frame with the results, or NULL if given a bad shape or data with no
##   sufficiently long observation periods

  stopifnot (shape %in% c("RR", "VH"))

  # make sure that input is a data frame
  if (!(is.array(asfr) | is.data.frame(asfr))) asfr <- read.table.hfd(asfr, ...)
  if (is.array(asfr)) asfr <- reshapeLexisShapeData(asfr, shape, "asfr")
  
  primary <-lexisShapePrimaryFactor(shape)
  
  # ensure that Age contains numeric data
  if (!is.numeric(asfr$Age)) {
    asfr$Age <- as.numeric(sub("[+-]", "", as.character(asfr$Age)))
  }

  if (shape == "VH") {
    # for VH then only Cohorts observed from age observeFrom are included
    asfr <- onlyObservationsFromAgeOrLess(observeFrom, asfr, "ASFR")
  }
  
  # we can only calculate MAB or TFR for cohorts observed *continuously* to age 49+ (default)
  # and MAB40 or TFR40 for cohorts observed to age 39+, so record which cohorts these are so that all
  # others can later be masked out
  # if we have period data then this effectively does nothing
  # note that we use the last column of data for this test in order to cover the case where there
  # is continuous non-order specific data but a break in the order-specific data: with no
  # order-specific data the last column is ASFR, otherwise ASFR5p
  requiredDataTotal <- (asfr$Age >= observeFrom) & (asfr$Age < observeTo)
  insufficientPrimaryTotal <- by(is.na(asfr[requiredDataTotal, ncol(asfr)]), asfr[requiredDataTotal, primary], any)
  primaryTotal <- unique(asfr[[primary]])[!insufficientPrimaryTotal]
  requiredData40 <- (asfr$Age >= observeFrom) & (asfr$Age < 40)
  insufficientPrimary40 <- by(is.na(asfr[requiredData40, ncol(asfr)]), asfr[requiredData40, primary], any)
  primary40 <- unique(asfr[[primary]])[!insufficientPrimary40]

  # any which can't be calculated for MAB40 or TFR40 can be discarded (those for which
  # MAB or TFR can be calculated is always a subset of these)
  asfr <- asfr[asfr[[primary]] %in% primary40, ]
  # may also need to ensure that factor levels are trimmed
  if (is.factor(asfr[[primary]])) {
    levels(asfr[[primary]]) <- ifelse(levels(asfr[[primary]]) %in% primaryTotal
                                      | levels(asfr[[primary]]) %in% primary40,
                                      levels(asfr[[primary]]), NA)
  }
  
  # potentially the observation period was so short that there are no
  # cohorts observed for a sufficiently long period: in this case just return
  # NULL
  if (nrow(asfr) == 0) return(NULL)

  # rather than using na.rm = TRUE for the sums then we will substitute
  # any NAs below observeFrom with 0 - any discontinuities in the series will
  # then result in NA TFR or MAB: for this we need to compute a logical mask
  # of the values requiring substitution in each year
  mask <- .generateMask(asfr, observeFrom, observeTo)
  
  # in order to deal with multiple birth orders then reshape dataset to one line
  # per (year/cohort), age, ASFRn
  asfr <- reshape(asfr, direction = "long", varying = names(asfr[3:ncol(asfr)]),
                  timevar = "Order", v.names = "ASFR",
                  times = names(asfr[3:ncol(asfr)]))
                
  # now we can apply the mask
  asfr[unlist(mask), 4] <- 0

  # first calculate MAB or TFR, then drop observations for 40+ and do TFR40
  res <- fn(asfr)
  asfr <- asfr[asfr$Age <= 39, ]
  res40 <- fn(asfr)

  # mask out those for which MAB or TFR was calculated although it shouldn't have been
  # since not enough observations were present
  res[!(rownames(res) %in% primaryTotal), ] <- NA
  
  # tidy up column names
  subhelper <- function(value, pattern, replacement) {
                         return(sub(pattern, replacement, value,
                                    fixed = TRUE))
               }
  names(res) <- sapply(names(res),
                       subhelper,
                       "ASFR", if(shape == "RR" || colName == "sdCMAB") colName else paste("C", colName, sep = ""))
  names(res40)[1] <- if(shape == "RR" || colName == "sdCMAB") paste(colName, "40", sep = "") else paste("C", colName, "40", sep = "")
  if (ncol(res40) > 1) {
    names(res40)[2:ncol(res40)] <- sapply(names(res40)[2:ncol(res40)],
                                     subhelper,
                                     "ASFR",
                                     if(shape == "RR" || colName == "sdCMAB") paste(colName, "40_", sep = "") else paste("C", colName, "40_", sep = ""))
  }
  
  # bring all parts together and tidy up names
  res <- cbind(primary40, res, res40)
  names(res)[1] <- primary

  # if table is all NAs (due to not enough continuous series)
  # then just return NULL
  if (all(is.na(res[, 2:ncol(res)]))) return (NULL)
  
  # drop rows containing only NAs
  res <- res[!apply(res[, 2:ncol(res)], 1, function(x){all(is.na(x))}), ]
  
  # ensure that the series is continuous
  if (is.factor(res[, 1])) res[, 1] <- as.numeric(levels(res[, 1])[res[, 1]])
  missing <- min(res[, 1]):max(res[, 1])
  missing <- missing[!(missing %in% res[, 1])]
  if (length(missing) > 0) {
    missing <- data.frame(missing, array(NA, dim = c(1, ncol(res) - 1)))
    names(missing) <- names(res)
    res <- rbind(res, missing)
  }
  
  # ensure order and default row names
  res <- res[order(res[, 1]), ]
  
  rownames(res) <- NULL
 
  return (res)
}

