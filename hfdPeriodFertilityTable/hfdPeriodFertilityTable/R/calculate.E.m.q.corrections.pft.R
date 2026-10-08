################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 797 $
## $Date: 2010-11-01 13:32:00 +0100 (Mo, 01. Nov 2010) $
## $Author: nash $
## $Id: calculate.E.m.q.corrections.pft.R 797 2010-11-01 12:32:00Z nash $
##
################################################################################

calculate.E.m.q.corrections.pft <-
function(E, m, qix) {
## Calculates cells requiring correction (replacement with 0 for processing
## and NA/"." for outputs in m and q indicators of Period Fertility Table
##
## @inputs
## - E the parity-specific population exposure as a named 3D array
##  of Year, Age, Parity
## - m the conditional age-specific fertility rates as a named 3D array
##  of Year, Age, Order
## - q the conditional probability of an i-th birth as a named 3D array
##  of Year, Age, Order with the same dimensions as m
## @returns
## - a 3D array of logical values indicating cells requiring correction.
##   Dimensions are those of E, m and q, and are named.

# "To eliminate huge fluctuations in mi(x) at lowest- and highest-childbearing
# ages, attributable to very low observed numbers of births, these rates are
# computed in the HFD only for age and parity combinations where
# Ei-1(x)>5, mi(x)<1 and qi(x)<1, otherwise, the values of Ei-1(x) are replaced
# by zero and the values of qi(x) and mi(x) are presented by dots (implausible
# values in the fertility tables." (MP §8.2)
  return((is.finite(E) & E <= 5) |
         is.nan(m) | is.infinite(m) | (is.finite(m) & m > 1) |
         is.nan(qix) | is.infinite(qix) | (is.finite(qix) & qix > 1))
}
