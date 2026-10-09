################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 1070 $
## $Date: 2015-02-27 22:30:52 +0100 (Fr, 27. Feb 2015) $
## $Author: svnNash $
## $Id: calculate.cfr.R 1070 2015-02-27 21:30:52Z svnNash $
##
################################################################################

calculate.cfr <-
function(asfr, shape, observeFrom = 15, ...) {
## Calculate cumulative fertility rates for the given age specific fertility
## rate dataset and shape
##
## @inputs
## - asfr is a data frame, 3D array or path to file containing the aggregated (for the shape) age specific
##   fertility rate data
## - shape is one of
##      - "RR" for rectangles
##      - "VH" for horizontal parallelograms
##      - "VV" for vertical parallelograms
## - observeFrom is the maximum age from which cohorts must have been observed
## - ... are arguments potentially passed to read.table (see doc for .readInputFile)
## @returns
## - a data frame with the cfr, or NULL if given a bad shape

  if (!(shape %in% c("RR", "VH", "VV"))) return(NULL)
  
  # make sure that input is a data frame
  if (!(is.array(asfr) | is.data.frame(asfr))) asfr <- read.table.hfd(asfr, ...)
  if (is.array(asfr)) asfr <- reshapeLexisShapeData(asfr, shape, "asfr")

  primary <-lexisShapePrimaryFactor(shape)
  secondary <- lexisShapeSecondaryFactor(shape)
  totalCol <- totalColPositionForShape(shape)
  
  # for VH and VV then only Cohorts observed from age 15- (default) are included
  if (shape == "VH") {
    asfr <- onlyObservationsFromAgeOrLess(observeFrom, asfr, "ASFR")
  }
  
  # factor columns get recycled
  factors <- asfr[, 1:(totalCol - 1)]

  # cumsum does not play nicely with NAs, so create a mask for each dataset and
  # then convert some NAs at the lower end of the age range
  # to 0 for the calculation. Afterwards we can mask out
  # the values that should be NA but aren't
  mask <- .generateMask(asfr, observeFrom)
  asfr[unlist(mask), totalCol:ncol(asfr)] <- 0
  mask <- .shiftMask(asfr, mask, observeFrom)
  
  # in order to deal with multiple birth orders then reshape dataset to one line
  # per (year/cohort), age, ASFRn
  asfr <- reshape(asfr, direction = "long", varying = names(asfr[totalCol:ncol(asfr)]),
                  timevar = "Order", v.names = "ASFR",
                  times = names(asfr[totalCol:ncol(asfr)]))

  # generate the cfrs: this leaves an array of [primary], [order] with entries
  # a list of cfr for each age
  cumsums <- tapply(asfr$ASFR,
                    list(asfr[[primary]], asfr$Order),
                    function(x) {
                      # cumsums is summed to x and not x-1 - we can
                      # correct this by simply moving all rows down by
                      # one and sticking some zeros at the top
                      Sx <- cumsum(x)
                      Sx[2:length(Sx)] <- Sx[1:(length(Sx) - 1)]
                      Sx[1] <- 0
                      return(Sx)
                    })
  # massage the result into a useful format: a table of factors, cfr...
  # also mask out the NAs identified earlier
  cfr <- NULL
  for (p in rownames(cumsums)) {
    pData <- as.data.frame(cumsums[p, ])
    names(pData) <- dimnames(cumsums)[[2]]
    cfr <- rbind(cfr, pData)
  }
  cfr[unlist(mask), ] <- NA
  cfr <- cbind(factors, cfr)

  # column names need correcting
  names(cfr) <- sapply(names(cfr),
                       function(value, pattern, replacement) {
                         return(sub(pattern, replacement, value,
                                    fixed = TRUE))
                       },
                       "ASFR", toupper(shortname.cfr(shape)))

  rownames(cfr) <- NULL
                     
  return(cfr)
}

