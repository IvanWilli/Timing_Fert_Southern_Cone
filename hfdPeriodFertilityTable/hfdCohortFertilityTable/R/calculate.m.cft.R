################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 506 $
## $Date: 2010-07-22 16:09:05 +0200 (Do, 22. Jul 2010) $
## $Author: nash $
## $Id: calculate.m.cft.R 506 2010-07-22 14:09:05Z nash $
##
################################################################################

calculate.m.cft <-
  function(b, l , a = 0.5) {
## Calculate the age- and parity-specific fertility rates, as featured
## in the cohort fertility table
##
## @inputs
## - b is an array of births by cohort, age and order
## - l is an array of population by cohort, age and order
##   - indexing of parity is (parity + 1), i.e. index 1 is parity 0
## - a is the average share of the age interval lived before giving
##   birth to a child
##   - this may be a single value (default 0.5), a vector of
##     cohort-specifc values or an array of cohort- and age- specific
##     values (in principle, anything whose dimensions are compatible
##     for multiplication with those of b
## @returns
## - an array of rates with the same dimensions as b

  m <- array(NA, dim(b), dimnames = dimnames(b))
  maxOrder <- dim(b)[3]
  m[, , 1] <- b[, , 1] / (l[, , 1] - (a * b[, , 1]))
  for (i in 2:(maxOrder - 1)) {
    m[, , i] <-
      b[, , i] / (l[, , i] - (a * b[, , i]) + ((1 - a) * b[, , i - 1]))
  }
  m[, , maxOrder] <-
    b[, , maxOrder] / (l[, , maxOrder] + ((1 - a) * b[, , maxOrder - 1]))
  
  dimnames(m)[[3]] <- gsub("b", "m", dimnames(b)[[3]], fixed = TRUE)
  
  return(m)
}
