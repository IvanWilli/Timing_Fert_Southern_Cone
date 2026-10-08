################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 534 $
## $Date: 2010-09-01 11:54:55 +0200 (Mi, 01. Sep 2010) $
## $Author: nash $
## $Id: calculate.l.cft.R 534 2010-09-01 09:54:55Z nash $
##
################################################################################

calculate.l.cft <-
function(b, l = NULL, radix = 10000, applyCorrections = TRUE) {
## Calculate a matrix of cohort parities from the given birth data
## according to the algorithm presented in the Methods Protocol formulae 7.2-7.6
## (this is needed for CFT and potentially PFT so do it as a separate function)
##
## To enable usage of this method for calculating age-parity estimates for a
## golden census, a pre-bootstrapped matrix of cohort parities may be supplied.
## In this case, rather than using radix, 0, 0, 0, ... as the first parity
## distribution, the values supplied will be used.
##
## @inputs
## - b is the birth data arranged as a 3D matrix of
##   (cohort|period), age, birth order
## - l is a pre-bootstrapped 3D matrix of first-year parities indexed on
##   cohort, birth order, age. For all left-censored values, NA should be
##   present, and for the first parities the desired values
## - radix is the size of the table population (default 10000)
## - applyCorrections is whether to apply corrections to l and/or b to prevent
##   implausible values (e.g. probabilities > 1 or parities < 0)
## @returns
## - a list containing two 3D arrays with the same dimensions as l if supplied, otherwise b
##   - parities is the (cohort|period) parities
##   - corrections is a boolean array indicating elements in parities which
##     were corrected - this can be used to correct the
##     birth data or indicators calculated from it. Of applyCorrections is FALSE
##     then this is simply an array of FALSE.

  if (is.null(l)) {
    # parities table is same size as births per age table
    l <- array(NA, dim(b), dimnames = dimnames(b))
    # set the names in the parity level dimension
    # l and not b, parity = order - 1
    # slightly convoluted, but seems the easiest way
    dimnames(l)[[3]] <-
      sapply(strsplit(gsub("(b)([[:digit:]]+)(.*)",
                           "l \\2 \\3",
                           dimnames(l)[[3]]),
                      " "),
             function(x){
               x[2] <- as.numeric(x[2]) - 1
               return(paste(x, collapse = ""))
             })
    names(dimnames(l))[3] <- "Parity"

    # initial parity subcohorts 0 -> radix, 1-4+ -> 0,
    # if data available, otherwise NA
    # bootstrapping the tables allows better handling of the NAs
    l[, , 1] <- ifelse(is.na(b[, , 1]), NA, radix)
    l[, , 2:dim(l)[3]] <- ifelse(is.na(b[, , 2:dim(b)[3]]), NA, 0)
  }

  # If parity <= 0 then parity <- 0 and further values may need correcting
  correction <- array(FALSE, dim = dim(l), dimnames = dimnames(l))

  if (applyCorrections) {
    # since l1x, l2x, ... are always 0 for xmin then b should also
    # always be corrected to 0 for these, if it is not NA
    b[dimnames(l)[[1]], 1, 2:dim(b)[3]] <- ifelse(is.na(b[dimnames(l)[[1]], 1, 2:dim(b)[3]]), NA, 0)
    # similarly we need to indicate where we performed this correction
    correction[, 1, 2:dim(correction)[3]] <-
      !is.na(b[dimnames(l)[[1]], 1, 2:dim(b)[3]])
  }
  
  # whilst calculating the parities, care needs to be taken not to add to NAs
  # note that the indexing of the parities is always parity x -> index x + 1
  # (e.g. parity 0 is index 1), whereas for the births by age the order indexing
  # is "as expected" (birth order x -> index x)
  # note also that we reference the first dimension of b by name
  # in case the (supplied) parity matrix does not cover the full range of years
  # of the birth data
  for(x in 2:dim(b)[2]) {
    for (i in 1:dim(b)[3]) {
      if (i == 1) {
        l[, x, i] <- ifelse((!is.na(b[dimnames(l)[[1]], x, i])) |
                            (!is.na(b[dimnames(l)[[1]], x - 1, i])),
                            ifelse(is.na(l[, x - 1, i]),
                                   l[, x, i],
                                   l[, x - 1, i] - b[dimnames(l)[[1]], x - 1, i]),
                            NA)
      } else if (i < dim(b)[3]) {
        l[, x, i] <- ifelse(!is.na(l[, x, 1]),
                            ifelse(is.na(l[, x - 1, i]),
                                   l[, x, i],
                                   l[, x - 1, i] +
                                   b[dimnames(l)[[1]], x - 1, i - 1] -
                                   b[dimnames(l)[[1]], x - 1, i]),
                            NA)
      } else { # i == dim(b)[3], maximum birth order
        l[, x, i] <- ifelse(!is.na(l[, x, 1]),
                            ifelse(is.na(l[, x - 1, i]),
                                   l[, x, i],
                                   l[, x - 1, i] + b[dimnames(l)[[1]], x - 1, i - 1]),
                            NA)
      }

      if (applyCorrections) {
        # where l < 0 then l <- 0
        correction[, x, i] <- (!is.na(l[, x, i])) & l[, x, i] < 0
        l[correction[, x, i], x, i] <- 0
        # where b > l then b <- l
        correction[, x, i] <- correction[, x, i] |
                              ((!is.na(l[, x, i])) &
                               ((!is.na(b[dimnames(l)[[1]], x, i])) &
                               l[, x, i] < b[dimnames(l)[[1]], x, i]))
  
        # this only corrects our local copy of b
        b[dimnames(l)[[1]][correction[, x, i]], x, i] <- l[correction[, x, i], x, i]
      }  
    }
  }

  return(list(parities = l, corrections = correction))
}

