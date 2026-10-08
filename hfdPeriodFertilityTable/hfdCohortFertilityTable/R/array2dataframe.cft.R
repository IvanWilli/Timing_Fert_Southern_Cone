################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 857 $
## $Date: 2010-12-01 08:20:24 +0100 (Mi, 01. Dez 2010) $
## $Author: nash $
## $Id: array2dataframe.cft.R 857 2010-12-01 07:20:24Z nash $
##
################################################################################

array2dataframe.cft <- function(myData) {
## Reformat a 3D array to a dataframe in the usual HFD format
  # brief sanity check: dimension 3, named, names are right
  stopifnot(length(dim(myData)) == 3)
  stopifnot(!(is.null(dimnames(myData)) || is.null(names(dimnames(myData)))))
  stopifnot(all(names(dimnames(myData))[1:2] == c("Cohort", "Age")))
  stopifnot(names(dimnames(myData))[3] %in% c("Order", "Parity", "Indicator"))
  if (dim(myData)[1] == 0) return(NULL) #dataset contains no cohorts
  myData <- aperm(myData, c(1, 3, 2)) # makes reshaping easier
  myData <- as.data.frame(myData)
  myData <- reshape(myData, direction = "long", varying = names(myData),
    ids = dimnames(myData)[[1]], timevar = "x", idvar = "Cohort")
  # Cohort will be the last column, so rearrange it to be the first
  myData <- myData[, c(ncol(myData), 1:(ncol(myData) - 1))]
  # Convert Cohort to numeric
  myData[, 1] <- as.numeric(myData[, 1])
  # Convert Age to numeric if there are no subscripts
  if (sum(grepl("[^[:digit:]]", myData[, 2])) == 0) {
    myData[, 2] <- as.numeric(myData[, 2])
  }
  # Return sorted by Cohort then x and with sequential row names 
  myData <- myData[ do.call(order, myData), ]
  row.names(myData) <- NULL
  return(myData)
}