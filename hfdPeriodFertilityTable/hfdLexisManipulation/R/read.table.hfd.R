################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 886 $
## $Date: 2011-01-11 10:48:54 +0100 (Di, 11. Jan 2011) $
## $Author: nash $
## $Id: read.table.hfd.R 886 2011-01-11 09:48:54Z nash $
##
################################################################################

read.table.hfd <- function(file, dropSuffixes = FALSE, trimIncomplete = FALSE, ...) {
  ## read a table from the HFD output database
  ##
  ## @inputs
  ## - file is the path to the file to read from
  ## - dropSuffixes is whether to drop +- suffixes from factor columns
  ## - trimIncomplete is whether to trim rows with NA values in the factors 
  dta <- .readInputData(file, ...)
  if (dropSuffixes) {
    for (colName in c("x", "Age", "Cohort")) {
      if ((!(colName %in% names(dta))) || is.numeric(dta[[colName]])) next
      if (is.factor(dta[[colName]])) {
        levels(dta[[colName]]) <- sub("[+-]$", "", levels(dta[[colName]]))
        dta[[colName]] <- as.numeric(levels(dta[[colName]]))[dta[[colName]]]
      } else {
        dta[[colName]] <- sub("[+-]$", "", dta[[colName]])
        dta[[colName]] <- as.numeric(dta[[colName]])
      }
    }
  }
  if (trimIncomplete) {
    colNames <- c("Year", "Age", "Cohort", "x")
    colNames <- colNames[colNames %in% names(dta)]
    if (length(colNames) > 0) {
      dta <- dta[apply(dta[, colNames, drop = FALSE], 1, function(x){!any(is.na(x))}), ]
    } 
  }
  return(dta)
}
