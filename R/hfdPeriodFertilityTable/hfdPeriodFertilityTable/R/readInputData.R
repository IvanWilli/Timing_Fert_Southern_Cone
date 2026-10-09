################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 822 $
## $Date: 2010-11-04 10:48:03 +0100 (Do, 04. Nov 2010) $
## $Author: nash $
## $Id: readInputData.R 822 2010-11-04 09:48:03Z nash $
##
################################################################################

.readInputData <- function(file, ...) {
  ## read some input from a file using supplied arguments to read.table
  ## which may be a list containing entry [name] with the relevant args,
  ## where [name] is the name of the variable in the calling environment
  ## passed as argument file
  ##
  ## @inputs
  ## - file is the path to a file (or a connection)
  ## - ... is arguments to read.table, or a list with named entries
  ##   each of which is a list of arguments to read.table
  ##   - defaults skip=2, header=TRUE, na.strings="." are added if not overridden
  ##
  ## @returns
  ## - the data read from file as a data.frame
  
  dots <- list(...)
  name <- as.character(substitute(file))
  if (name %in% names(dots)) dots <- dots[[name]]
  if (!("header" %in% names(dots))) dots["header"] <- TRUE
  if (!("skip" %in% names(dots))) dots["skip"] <- 2
  if (!("na.strings" %in% names(dots))) dots["na.strings"] <- "."
  dots["file"] <- file
  do.call(read.table, dots)
}
