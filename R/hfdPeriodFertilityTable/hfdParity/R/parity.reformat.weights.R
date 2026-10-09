################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 842 $
## $Date: 2010-11-09 16:49:10 +0100 (Di, 09. Nov 2010) $
## $Author: nash $
## $Id: parity.reformat.weights.R 842 2010-11-09 15:49:10Z nash $
##
################################################################################

parity.reformat.weights <-
function(census.weights, ages = 12:56, outfile = NULL) {
## Reformats register weights which are from 1st January to the same format as
## the output from the parity.1Jan.weights function
##
## @inputs
## - census.weights is the path to a file containing the parity weights by age
##   from the register, or a data frame representing this
##   - for the file, CSV format with column heads is assumed and two title rows
##     are skipped
##   - columns Year, Month, Day, Age, Format, w0, w1, ..., wx+ are assumed
##   - month and day must always be 1 and 1
## - ages is the range of ages to maintain (default 12:56)
## - outfile is the path to a file to write the output to, if desired.
## @returns
## - a data frame with the columns Year, Age, w0, w1, ..., wxp

  if (!is.data.frame(census.weights)) {
    census.weights <- read.csv(census.weights, skip = 2, header = TRUE, na.strings = ".")
  }
  
  stopifnot(all(census.weights$Month == 1) && all(census.weights$Day == 1))

  # check that there are no gaps in the age range
  census.weights.years <- split(census.weights, census.weights$Year)
  for(census.weights.year in census.weights.years) {
    if (!(nrow(census.weights.year) > 1 && all(diff(census.weights.year$Age) == 1))) {
      stop("Age range has gaps in year ", census.weights.year)
    }
  }
  
  if (nrow(census.weights) > 0) {
    census.weights[census.weights$Format == "ARDY", "Age"] <-
      census.weights[census.weights$Format == "ARDY", "Age"] - 1
    census.weights <-
      census.weights[census.weights$Age >= min(ages) & census.weights$Age <= max(ages), ]
  }
  
  census.weights <- census.weights[, c(1, 4, 6:ncol(census.weights))]
  names(census.weights)[ncol(census.weights)] <-
    sub("+", "p", names(census.weights)[ncol(census.weights)], fixed = TRUE)

  if (!is.null(outfile)) {
    write.csv(census.weights, outfile, quote = FALSE, na = ".", row.names = FALSE)
  }
 
  invisible(census.weights)
}

