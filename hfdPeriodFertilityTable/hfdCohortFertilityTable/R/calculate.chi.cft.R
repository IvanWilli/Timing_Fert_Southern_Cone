################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 511 $
## $Date: 2010-07-23 10:50:02 +0200 (Fr, 23. Jul 2010) $
## $Author: Nash $
## $Id: calculate.chi.cft.R 511 2010-07-23 08:50:02Z Nash $
##
################################################################################

calculate.chi.cft <-
  function(l, b) {
## Calculate the average number of children born to women in the highest parity
## category
##
## @inputs
## - l is the matrix of population by cohort, age and parity
##   - indexing of parity is (parity + 1), i.e. index 1 is parity 0
## - b is the matrix of births by age and order
## @returns
## - a 2D array of chi values by cohort and age

  lastParity <- dim(l)[3] - 1
  lastOrder <- lastParity + 1
  # do calculation as 3D array to keep calculate.Sb happy
  chi <- ((lastParity * l[, , lastOrder, drop = FALSE]) +
      calculate.Sb(b[, , lastOrder, drop = FALSE])) /
         l[, , lastOrder, drop = FALSE]
  # can't just use drop() as if only one cohort then would drop to a vector...
  dims <- dim(chi)[c(1, 2)]
  dimns <- dimnames(chi)
  chi <- drop(chi)
  dim(chi) <- dims
  dimnames(chi) <- dimns[c(1, 2)]
  return(chi)
}