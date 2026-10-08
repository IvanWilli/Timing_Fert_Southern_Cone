################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 811 $
## $Date: 2010-11-03 07:29:37 +0100 (Mi, 03. Nov 2010) $
## $Author: nash $
## $Id: convertInputDataFrameToArray.R 811 2010-11-03 06:29:37Z nash $
##
################################################################################

.convertInputDataFrameToArray <-
  function(someData) {
  ## Convert some input data.frame to a 3D array
  ##
  ## @inputs
  ## - someData is a data frame containing the input dataset in Lexis squares
  ##   Columns  Year, Age, [data] [, data1, ..., dataxp] are assumed
  ## @returns
  ## - a 3D array of data indexed on Year, Age, Order
  
  dataName <- names(someData[3])

  # we assume totals present if first data column name doesn't contain a digit
  hasTotals <- !grepl("[[:digit:]]", dataName)
  
  firstCol <- if (hasTotals) 4 else 3
  
  # trim factor levels in Year if necessary
  levels(someData$Year)[!(levels(someData$Year) %in% unique(someData$Year))] <- NA
  
  # expand to one row per birth order
  someData <- reshape(someData, varying = if (ncol(someData) > 3) firstCol:ncol(someData) else 3,
    timevar = "Order", v.names = dataName, direction = "long",
    drop = if (ncol(someData) > 3 && hasTotals) dataName,
    times = if (ncol(someData) > 3) names(someData)[firstCol:ncol(someData)] else dataName)
  # convert to an array
  someData <- tapply(someData[[dataName]],
    list(someData$Year, someData$Age, someData$Order),
    function(x) {return(x)})
  
  # work out whether parity or order: if first data is 1 then order, otherwise parity
  data1 <- dimnames(someData)[[3]][1]
  digits <- regexpr("[[:digit:]]+", data1)
  if (substr(data1, digits, digits + attr(digits, "match.length") - 1) == 1) {
    dim3 <- "Order"
  } else {
    dim3 <- "Parity"
  }
  names(dimnames(someData)) <- c("Year", "Age", dim3)
  
  return(someData)
}

