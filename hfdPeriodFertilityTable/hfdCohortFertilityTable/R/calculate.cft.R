################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 1061 $
## $Date: 2014-05-06 12:38:05 +0200 (Di, 06. Mai 2014) $
## $Author: jasilioniene $
## $Id: calculate.cft.R 1061 2014-05-06 10:38:05Z jasilioniene $
##
################################################################################

calculate.cft <-
function(asfr, observeTo = 25, observeFrom = 15, radix = 10000, a = 0.5,
         returnType = "data.frame", applyCorrections = TRUE, ...) {
## Calculate cohort fertility table from the given age specific fertility rates
## in horizonatal parallelograms
##
## @inputs
## - asfr is one of:
##   - a data frame containing the age specific fertility rate dataset
##     as horizontal parallelograms. The columns
##     Cohort, Age, ASFR, ASFR1, ..., ASFRxp are assumed, with the first
##     three of these tested for.
##   - a character vector pointing to the path from which the ASFR values may
##     be read, or a connection object. read.table will be called on this, with the
##     default options being header = TRUE, skip = 2, na.strings = ".": these may
##     be overridden using further arguments (see ...)
##   - a 3D array of ASFR with the dimensions named according to the Cohort,
##     Age and Order respectively. In this case, it is expected that there
##     is no total ASFR included in the array.
## - observeTo is the minimum age to which cohorts must be observed in order
##   to be included in the CFT (default 25)
## - observeFrom is the highest age from which cohorts must be observed in order
##   to be included in the CFT (default 15)
## - radix is the size of the table population (default 10000)
## - a is the average share of the age interval lived before giving
##   birth to a child
##   - this may be a single value (default 0.5), a vector of
##     cohort-specifc values or an array of cohort- and age- specific
##     values. If supplying a vector or array, note that only cohorts
##     not filtered out using the observeTo and observeFrom values must
##     be present, and that the age range must match that of the input data
## - returnType is the format in which to return the CFT
##   - "data.frame" (default) returns a data.frame with the columns ordered by
##     order/parity and then indicator
##   - "array" returns a 3D array with the dimensions Cohort, Age and Indicator,
##     where Indicator is ordered by indicator and then parity
##   - "list" returns a list of arrays, each element of which contains an array
##     with the indicators arranged by Cohort, Age and (for all except chi)
##     Order. List entries are b, l, m, q, Sb and chi.
## - applyCorrections is whether to correct parity and birth data to
##   prevent implausible values
## - ... are named arguments to read.table, which may be used to override the
##   defaults used (see details for argument asfr)
## @returns
## - an object containing the CFT (for details see details of argument
##   returnType), or NULL if given a bad shape or no birth orders
##   or data with an insufficiently long observation period

  if (!(returnType %in% c("data.frame", "array", "list"))) {
    stop("returnType must be one of data.frame, array or list")
  }

  if (is(asfr, "character") || is(asfr, "connection")) {
    rtArgs <- list(...)
    if (is.null(rtArgs$header)) rtArgs$header <- TRUE
    if (is.null(rtArgs$skip)) rtArgs$skip <- 2
    if (is.null(rtArgs$na.strings)) rtArgs$na.strings <- "."
    rtArgs$file <- asfr
    asfr <- do.call(read.table, rtArgs)
  }

  # births per age and order in the radix, and filter cohorts
  # appropriately
  b <- calculate.b.cft(asfr, observeTo, observeFrom, radix)

  # if no cohorts were observed for a sufficiently long time then just return
  # NULL
  if (is.null(b)) return(NULL)

  # calculating parities and necessary corrections
  # implemented as a separate function as this can also be needed for period
  # fertility table
  # the result is a list with parities and elements requiring correction
  paritiesAndCorrections <- calculate.l.cft(b, radix = radix, applyCorrections = applyCorrections)
  l <- paritiesAndCorrections$parities

  # If parity < 0 or conditional probability > 1 then set parity l, births b,
  # conditional probability q and age/parity rate m to 0.
  # (parity l is already corrected)
  corrections <- paritiesAndCorrections$corrections
  
  # correct birth data where necessary
  b[corrections] <- l[corrections]

  # calculate age- and parity- specific fertility rates
  m <- calculate.m.cft(b, l, a)

  # correct specific fertility rates to NA where parities was corrected or is 0
  m[corrections | ((!is.na(l)) & l <= 0)] <- NA

  # conditional probability of giving i-th birth at age x for woman in parity i-1
  # R has a function q (quit!) so we'll call the array qix instead
  qix <- calculate.q.cft(b, l)
  
  # correct conditional probability to NA where parities was corrected or are 0
  qix[corrections | ((!is.na(l)) & l <= 0)] <- NA

  # sum of births per age implemented as separate function as also
  # needed for pft
  Sb <- calculate.Sb(b)
  
  # average number of children born by age x in highest parity category
  chix <- calculate.chi.cft(l, b)
  # promote chix to a 3D array to ease use of abind
  chidnames <- list(Cohort = dimnames(chix)[[1]], Age = dimnames(chix)[[2]], Order = "chix")
  dim(chix) <- c(dim(chix)[1], dim(chix)[2], 1)
  dimnames(chix) <- chidnames

  # now everything is calculated it just needs to be brought into one array
  # and can then be rearranged appropriately
  cft <- abind::abind(b, l, m, qix, Sb, chix, along = 3)
  
  # No distinction is made between NA, NaN and Inf
  cft[!is.finite(cft)] <- NA
  
  names(dimnames(cft)) <- c("Cohort", "Age", "Indicator")
  
  if (returnType == "data.frame") {
    cft <- array2dataframe.cft(cft)
    
    # need to bring get the indicator columns in the correct order
    # (b, l, m, q, Sb for 1:max and then chi)
    offsets <- 0:4 * dim(b)[3]
    cft <- cft[, c(1:2, sapply(2 + 1:dim(b)[3], function(x) {x + offsets}), ncol(cft))]
  } else if (returnType == "list") {
    indRange <- 1:dim(b)[3]
    cft <- list(b = cft[, , indRange, drop = FALSE],
                l = cft[, , indRange + max(indRange), drop = FALSE],
                m = cft[, , indRange + (2 * max(indRange)), drop = FALSE],
                q = cft[, , indRange + (3 * max(indRange)), drop = FALSE],
                Sb = cft[, , indRange + (4 * max(indRange)), drop = FALSE],
                chi = cft[, , 1 + (5 * max(indRange)), drop = FALSE])
    # drop the dimensions of chi and then make sure they aren't dropped too far
    # (which would happen if we only have one cohort)
    cft$chi <- cft$chi[, , 1]
    dim(cft$chi) <- dim(chix)
    dimnames(cft$chi) <- dimnames(chix)
  }

  return(cft)
}
