################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 506 $
## $Date: 2010-07-22 16:09:05 +0200 (Do, 22. Jul 2010) $
## $Author: nash $
## $Id: calculate.q.cft.R 506 2010-07-22 14:09:05Z nash $
##
################################################################################

calculate.q.cft <-
  function(b, l) {
## Calculate probabilities of birth by birth order as featured in cohort
## fertility table
##
## @inputs
## - b is a 3D array of births by cohort, age and order
## - l is a 3D array of populations by cohort, age and parity
##   - note that indexing is (parity + 1), i.e. parity 0 is index 1

  # calculated as b / l, table is the same size as births per age table
  # R has a function q() (quit!), so call the array qix instead
  qix <- b / l
  dimnames(qix)[[3]] <- gsub("b", "q", dimnames(b)[[3]], fixed = TRUE)
  return(qix)
}
