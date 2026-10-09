################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 738 $
## $Date: 2010-10-22 10:12:04 +0200 (Fr, 22. Okt 2010) $
## $Author: nash $
## $Id: calculate.b.cft.R 738 2010-10-22 08:12:04Z nash $
##
################################################################################

calculate.b.cft <-
function(asfr, observeTo = 25, observeFrom = 15, radix = 10000) {
## Calculate a matrix of births based on the given age specific
## fertility rate dataset and radix
##
## @inputs
## - asfr is one of:
##   - a data frame containing the age specific fertility rate dataset
##     as horizontal parallelograms. The columns
##     Cohort, Age, ASFR, ASFR1, ..., ASFRxp are assumed, with the first
##     three of these tested for.
##   - a 3D array of ASFR with the dimensions named according to the Cohort,
##     Age and Order respectively. In this case, it is expected that there
##     is no total ASFR included in the array.
## - observeTo is the minumum age to which cohorts must be observed,
##   e.g. only compute matrix for cohorts observed until age 25 or
##   older.
##   - FALSE is used if no filtering should be performed
##   - TRUE may be used as a synonym for 25
## - observeFrom is the maximum starting age for observation. e.g. only those
##   cohorts observed from age 15 or younger.
##   - FALSE is used if no filtering should be performed
##   - TRUE may be used as a synonym for 15
## - radix is the size of the population (default 10000)
## @returns
## - a 3D array of births in the radix indexed on Cohort, Age, Order, or NULL if
##   the data supplied had an insufficiently long observation period

  # quick input sanity check
  if (is(asfr, "data.frame")) {
    if (ncol(asfr) < 4) return(NULL)
    if (any(names(asfr)[1:3] != c("Cohort", "Age", "ASFR"))) {
      stop("asfr must have 1st 3 cols Cohort, Age, ASFR")
    }
  } else if (is(asfr, "array")) {
    if (is.null(dimnames(asfr))) {
      stop("array dimensions must be named")
    }
  }

  # since we now remove +/- characters then record the input ages so we can
  # set them again later
  ages <-
    if (is(asfr, "data.frame")) {
      as.character(unique(asfr$Age))
    } else if (is(asfr, "array")) {
      dimnames(asfr)[[2]]
    }

  # ensure data is an array
  if (is(asfr, "data.frame")) {
    asfr <- .convertASFRdataFrameToArray(asfr)
  }

  # sort out any logical arguments
  if (is.logical(observeTo) && observeTo)
    observeTo <- 25
  if (is.logical(observeFrom) && observeFrom)
    observeFrom <- 15
  
  if (observeTo || observeFrom) {
    # only keep cohorts observed for required range
    agesNum <- as.numeric(sub("[+-]", "", ages))
    filter <- TRUE
    if (!(is.logical(observeTo) && (observeTo == FALSE))) filter <- filter & (agesNum < observeTo)
    if (!(is.logical(observeFrom) && (observeFrom == FALSE))) filter <- filter & (agesNum >= observeFrom)
    cohorts <- !is.na(asfr[, filter, 1])
    dim(cohorts) <- c(dim(asfr)[1], length(cohorts) / dim(asfr)[1])
    cohorts <- apply(cohorts, 1, all)
    asfr <- asfr[cohorts, , , drop = FALSE]
  
    # check that we've got some data left to work with
    if (is.null(asfr)) return(NULL)
    
    # filter out data from series with gaps outside the required
    # observation age range: we can still produce the CFT for
    # these cohorts
    # at the lower end, the condition is that if there is a NA later
    # than the given age, the data at that age should be filtered out
    if (!(is.logical(observeFrom) && (observeFrom == FALSE))) asfr[, agesNum < observeFrom, ][t(apply(asfr[, agesNum < observeFrom, 1, drop = FALSE], 1, function(x){rev(cumsum(is.na(rev(x)))) >= 1}))] <- NA
    # at the upper end, the condition is that if there is a NA earlier
    # than the given age then the data at that age should be filtered out
    if (!(is.logical(observeTo) && (observeTo == FALSE))) asfr[, agesNum >= observeTo, ][t(apply(asfr[, agesNum >= observeTo, 1, drop = FALSE], 1, function(x){cumsum(is.na(x)) >= 1}))] <- NA
  }
    
  # births per age and order per 10000 population
  b <- asfr * radix

  # set the names in the birth orders dimension
  dimnames(b)[[3]] <- paste("b", 1:dim(b)[3], "x", sep = "")
  dimnames(b)[[3]][dim(b)[3]] <-
    sub("x", "px", dimnames(b)[[3]][dim(b)[3]], fixed = TRUE)
  dimnames(b)[[2]] <- ages
  names(dimnames(b)) <- c("Cohort", "Age", "Order")
  
  return(b)
}

.convertASFRdataFrameToArray <-
function(asfr) {
## Convert a data frame containing ASFR data to a 3D array
##
## @inputs
## - asfr is a data frame containing the age specific fertility rate dataset
##     as horizontal parallelograms. The columns
##     Cohort, Age, ASFR, ASFR1, ..., ASFRxp are assumed
## @returns
## - a 3D array of asfr indexed on Cohort, Year, Order  # expand to one row per birth order and convert data to a 3D array of
  # asfr by cohort, age and order
  asfr <- reshape(asfr, varying = names(asfr)[4:ncol(asfr)], timevar = "Order",
                  v.names = "ASFR", direction = "long", drop = "ASFR")
  asfr <- tapply(asfr$ASFR,
              list(asfr$Cohort, asfr$Age, asfr$Order),
              function(x) {return(x)})
  return(asfr)
}
