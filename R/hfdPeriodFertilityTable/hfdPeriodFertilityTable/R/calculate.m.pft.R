################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 905 $
## $Date: 2011-01-13 14:30:18 +0100 (Do, 13. Jan 2011) $
## $Author: nash $
## $Id: calculate.m.pft.R 905 2011-01-13 13:30:18Z nash $
##
################################################################################

calculate.m.pft <-
function(birthsRR, E, filterPlausible = FALSE, adjustE = TRUE, ...) {
## Calculate conditional age-specific fertility rate from given births and
## exposure by parity datasets, each expressed as a 3D array indexed on year,
## age, birth order, a data.frame or the path to a file
##
## @inputs
## - birthsRR is the births by birth order by Lexis squares as a data frame, a 3D
##   array indexed on year, age, order or the path to a file
## - E is the female population exposure by parity in Lexis squares as a 3D array
##   indexed on year, age, parity, a data frame or the path to a file
## - filterPlausible is a boolean indicating whether implausible values (mi > 1)
##   should be filtered out (set to NA)
##   - TRUE = mi > 1 will be set to NA
##   - FALSE = mi > 1 will be left as-is
## - adjustE is a boolean indicating whether low exposures (<= 5) should be set to 0
## - ... is arguments to read.table if one of the inputs is the path to a file
## @returns
## - a 3D array of conditional age-specific fertility rates
##   indexed on year, birth order, age

  # read inputs from files if necessary
  if (!(is.data.frame(birthsRR) || is.array(birthsRR))) birthsRR <- .readInputData(birthsRR, ...)
  if (!(is.data.frame(E) || is.array(E))) E <- .readInputData(E, ...)
  
  # first get the inputs into arrays
  if (is.data.frame(birthsRR)) {
    birthsRR <- .convertInputDataFrameToArray(birthsRR)
  }
  if (is.data.frame(E)) {
    E <- .convertInputDataFrameToArray(E)
  }

  # we then work out what years and ages we can calculate the rates for
  eYears <- dimnames(E)[[1]]
  bYears <- dimnames(birthsRR)[[1]]
  years <- as.character(eYears[eYears %in% bYears])
  eAges <- sub("[+-]", "", dimnames(E)[[2]])
  bAges <- sub("[+-]", "", dimnames(birthsRR)[[2]])

  # now trim the data to only those years and ages, ensuring arrays stay 3D
  B <- birthsRR[years, bAges %in% eAges, , drop = FALSE]
  E <- E[years, eAges %in% bAges, , drop = FALSE]

  # Adjust low E values, if desired:
  # "To eliminate huge fluctuations in mi(x) at lowest- and highest-childbearing
  # ages, attributable to very low observed numbers of births, these rates are
  # computed in the HFD only for age and parity combinations where
  # Ei-1(x)>5, mi(x)<1 and qi(x)<1, otherwise, the values of Ei-1(x) are replaced
  # by zero in the fertility tables." (MP §8.2)
  if (adjustE) E[E <= 5 & !is.na(E)] <- 0

  # conditional age-specific fertility rate
  m <- B / E

  # filter for plausibility, if desired
  if (filterPlausible) {
    m[is.finite(m) & m > 1] <- NA
  }

  # fixup names in the order dimension
  dimnames(m)[[3]] <- paste(sub("B", "m", dimnames(B)[[3]], fixed = TRUE), "x", sep = "")

  return(m)
}

