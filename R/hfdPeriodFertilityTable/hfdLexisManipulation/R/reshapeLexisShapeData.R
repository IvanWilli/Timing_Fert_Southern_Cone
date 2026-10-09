################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 1027 $
## $Date: 2011-11-27 20:58:55 +0100 (So, 27. Nov 2011) $
## $Author: Ed $
## $Id: reshapeLexisShapeData.R 1027 2011-11-27 19:58:55Z Ed $
##
################################################################################

reshapeLexisShapeData <-
function(shapeData, shape, dataType, minAge = NULL, maxAge = NULL) {
## Reformat a 3D lexis shape dataset for tabular output
## This works for various data, with or without birth orders
##
## @inputs
## - shapeData is the 3D shape data with indexes primary, secondary, birth order
## - shape is one of
##      - "RR" for rectangles (calendar year, age in completed years)
##      - "VV" for vertical parallelograms (year of birth, age in completed years)
##      - "VH" for horizontal parallelograms (year of birth, age reached during year)
## - dataType is the type of data (e.g. "births", "expos", etc.)
## - minAge is for VV data the minimum ARDY to include in the data frame, ignored otherwise
## - maxAge is for VV data the maximum ARDY to include in the data frame, ignored otherwise
##
## Note that any Inf or NaN values in shapeData will be replaced with NAs
##
## @returns
## - a sorted data table containing the reshaped data or null if the input data is null

  # check we have a valid shape defined
  stopifnot(shape %in% c(
              "RR", # rectangle, aggregate cohort by year and age
              "VV", # v.pgram, aggregate age by year and cohort
              "VH"  # h.pgram, aggregate year by cohort and age
            ))
  
  # if no input data then bail out
  if (is.null(shapeData)) {
    return(NULL)
  }
   
  # ensure that the array is 3-dimensional
  if(length(dim(shapeData)) == 2) {
    dnames <- dimnames(shapeData)
    dim(shapeData) <- c(dim(shapeData), 1)
    dimnames(shapeData) <- list(dnames[[1]], dnames[[2]], switch(dataType, births = "Total", expos = "Exposure", asfr = "ASFR", cfr = "CFR"))
  }

  # No distinction is made between NA, NaN and Inf in the outputs, so this
  # seems the best place to do replacements if necessary since during
  # calculations the different values are useful
  shapeData[!is.finite(shapeData)] <- NA

  primary <- lexisShapePrimaryFactor(shape)
  secondary <- lexisShapeSecondaryFactor(shape)

  # if the third dimension is > 1 then we have birth order data and not just totals
  withOrder <- dim(shapeData)[3] > 1

  # flatten data to a 2D array
  shapeData <- as.data.frame(aperm(shapeData, c(1, 3, 2)))

  # shapeData is now a 2D array of [primary, (birth order).secondary]
  # so expand the secondary
  shapeData <- reshape(shapeData, direction = "long", varying = dimnames(shapeData)[[2]],
                       sep = ".", idvar = primary, timevar = secondary,
                       ids = dimnames(shapeData)[[1]])

  # if birth orders are present then in many cases the Total column should appear before the
  # birth order columns and not after them (sorting as factors gives the wrong order in the tapply)
  if ((!(dataType %in% c("mi", "exposRRpa"))) && withOrder) {
    orderCols <- grep("[[:digit:]]", names(shapeData))
    if ((length(orderCols) > 0) && (max(orderCols) < (ncol(shapeData) - 1))) {
      shapeData <- shapeData[, c(1, ncol(shapeData) - 1, orderCols, ncol(shapeData))]
    }
  }

  # if vertical parallelograms are to be output then we
  # 1. add an ARDY column
  # 2. trim the data to the real output range of ARDYs
  if (shape == "VV") {
    # Year is a factor or a string and not integer, so need to convert it
    # since factors require special handling then if we've got strings we'll
    # convert them to factors anyway and then conversion handling is common
    yearF <- as.factor(shapeData$Year)
    shapeData <- cbind(ARDY = as.numeric(levels(yearF)[yearF]) - shapeData$Cohort, shapeData)
    if (is.null(minAge) | is.null(maxAge)) {
      # work out the minimum and/or maximum ARDY at which we have some data
      ARDYs <- unique(shapeData$ARDY[!is.na(shapeData[ncol(shapeData) - 1])])
      if (is.null(minAge)) minAge <- min(ARDYs)
      if (is.null(maxAge)) maxAge <- max(ARDYs)
    }
    shapeData <- shapeData[shapeData$ARDY >= minAge & shapeData$ARDY <= maxAge, ]
  }

  # reorder the columns so that the primary is first (default = last) and return with sorted rows
  shapeData <- shapeData[, c(ncol(shapeData), 1:(ncol(shapeData) - 1))]
  return(shapeData[do.call(order, shapeData), ])
}

