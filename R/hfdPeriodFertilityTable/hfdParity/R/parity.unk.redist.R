################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 867 $
## $Date: 2010-12-07 11:06:26 +0100 (Di, 07. Dez 2010) $
## $Author: nash $
## $Id: parity.unk.redist.R 867 2010-12-07 10:06:26Z nash $
##
################################################################################

parity.unk.redist <-
function(parity, method = c(default = "proportional"), outfile = NULL, ...) {
## Redistributes females with unknown parity in populations by parity. Females
## with unknown age are unaffected.
##
## @inputs
## - parity is a path to the XXXparity.txt file, or a data frame representing
##   its contents (read in using read.csv( , header = TRUE, na.strings = ".")
## - method is the method to use, potentially as a vector keyed by year, e.g.
##   "proportional" (default) or
##   c(default = "proportional", `1991` = "allToZero", `2001` = "belowXtoZero")
## - outfile is the path to a file to write the result to, if desired.
##   - NULL (default) means no file output
## - ... is any other arguments required by the individual redistribution
##   functions
## @returns
## - the parity data with females with unknown parity distributed using the
##   chosen method for each year

  if (!is.data.frame(parity)) {
    parity <- read.csv(parity, header = TRUE, na.strings = ".")
    parity <- parity[parity$LDB == 1, ]
  }
  
  if (length(method) == 1 && is.null(names(method))) names(method) <- "default"
  
  parityByYear <- split(parity, parity$Year)
  
  result <- parity[0]
  
  for(year in names(parityByYear)) {
    methodY <- if (length(method) == 1) method else if (year %in% names(method)) method[year] else method["default"]
    if(is.na(methodY)) stop(paste("No method defined for year", year, "and no default either"))
    fnName <- paste("parity.unk.redist", methodY, sep = ".")
    if (!(exists(fnName))) {
      stop(paste(methodY, "is not a recognised method for redistribution of unknown parities"))
    }
    fn <- get(fnName, mode = "function")
    result <- rbind(result, do.call(fn, list(parity = parityByYear[year][[1]], ...)))
  }
                                  
  if (!is.null(outfile)) {
    write.csv(result, outfile, quote = FALSE, na = ".", row.names = FALSE)
  }
  
  invisible(result)
}

