################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 511 $
## $Date: 2010-07-23 10:50:02 +0200 (Fr, 23. Jul 2010) $
## $Author: Nash $
## $Id: calculate.Sb.R 511 2010-07-23 08:50:02Z Nash $
##
################################################################################

calculate.Sb <-
function(b) {
## Calculate the sum of births up to each age (Sbx)
##
## @inputs
## - b is a 3D array of births indexed by (Period|Cohort), Age, Order
## @returns
## - a 3D array of cumulative births by age, whose dimentions match those of b

  # sum of births per age table is same size as births per age table,
  # and we can copy the NAs across and fill the remainder with zeroes
  Sb <- ifelse(is.na(b), NA, 0)
  dimnames(Sb)[[3]] <- paste("S", dimnames(b)[[3]], sep = "")
  names(dimnames(Sb)[[3]]) <- NULL

  # sum births in the first age is always 0 (or NA)
  Sb[, 1, ] <- ifelse(is.na(Sb[, 1, ]), NA, 0)

  # sum births in the second age is simply births from the first age, or zero
  # where the second age is the first age observed
  Sb[, 2, ] <- ifelse(is.na(b[, 1, ]) & !is.na(b[, 2, ]), 0, b[, 1, ])
  
  # for further cumulative birth counts we must be careful not to add to NA for
  # the first observed age, but to leave a zero there
  for(x in 3:dim(b)[2]) {
    Sb[, x, ] <- ifelse(is.na(Sb[, x - 1, ]), 0, Sb[, x - 1, ]) +
                 ifelse(is.na(b[, x - 1, ]) & !is.na(b[, x, ]), 0, b[, x - 1, ])
  }

  return(Sb)
}

