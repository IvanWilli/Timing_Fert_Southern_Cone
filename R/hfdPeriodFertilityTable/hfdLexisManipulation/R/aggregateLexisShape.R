################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 1027 $
## $Date: 2011-11-27 20:58:55 +0100 (So, 27. Nov 2011) $
## $Author: Ed $
## $Id: aggregateLexisShape.R 1027 2011-11-27 19:58:55Z Ed $
##
################################################################################

aggregateLexisShape <-
function(TRdata, shape, ...) {
## Produce an aggregated Lexis shape from triangle data
## This works for exposure or birth count data, with or without birth orders
##
## @inputs
## - TRdata is the source data as Lexis triangles
## - shape is one of
##      - "RR" for rectangles (calendar year, age in completed years)
##      - "VV" for vertical parallelograms (year of birth, age in completed years)
##      - "VH" for horizontal parallelograms (year of birth, age reached during year)
## - ... are named arguments potentially passed to read.table
##
## @returns
## - a 3D array indexed by primary, secondary, birth order containing the aggregated data
##   or null if insufficient data

  # check we have a valid shape defined
  stopifnot(shape %in% c(
              "RR", # rectangle, aggregate year and age
              "VV", # v.pgram, aggregate by year and cohort
              "VH"  # h.pgram, aggregate by cohort and age
            ))
  
  # try and read data from file if necessary
  if (!is.data.frame(TRdata)) TRdata <- .readInputData(TRdata, ...)

  # if no data then bail out
  if (nrow(TRdata) == 0) {
    return(NULL)
  }
  
  # define output factors depending on output type
  primary <- lexisShapePrimaryFactor(shape)
  secondary <- lexisShapeSecondaryFactor(shape)
  
  # ensure that unused factor levels will be dropped
  TRdata[[primary]] <- factor(TRdata[[primary]])
  TRdata[[secondary]] <- factor(TRdata[[secondary]])

  # columns to aggregate data for (1st 3 cols are factors Year, Age, Cohort)
  outputData = names(TRdata[4:length(names(TRdata))])

  # expand input to one row per birth order
  # note that this still works even if only a total is given as "Total" or "Exposure" is handled just like a normal birth order
  TRdata <- reshape(TRdata, varying = list(outputData), timevar = "Order", times = outputData, v.names = "Count", direction = "long")
  
  # aggregate data according to chosen factors
  res <- tapply(TRdata$Count, list(TRdata[[primary]], TRdata[[secondary]], TRdata$Order), sum)
  names(dimnames(res)) <- c(primary, secondary, "Order")
  return(res)
}

