################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 1061 $
## $Date: 2014-05-06 12:38:05 +0200 (Di, 06. Mai 2014) $
## $Author: jasilioniene $
## $Id: calculate.pft.R 1061 2014-05-06 10:38:05Z jasilioniene $
##
################################################################################

calculate.pft <-
function(birthsRR, exposRR, w, a = 0.5, returnType = "data.frame", ...) {
## Calculate a period fertility table from the given data and using the given
## method to calculate the exposure by parity estimate
##
## @inputs
## - birthsRR is the births by birth order by Lexis squares as a data frame, 3D array indexed
##   on year, age, order or path to a file
## - exposRR is the female population exposure by Lexis squares as a data frame, 3D array indexed
##   on year, age, order or path to a file
## - w is the relative distribution of female population exposure as a 3D array indexed
##   on year, age, order, a data frame or path to a file
## - a is the average share of the age interval [x,x+1] lived before giving
##   birth to a child (MP§8.3: "We assume that all a(x) values are equal to 0.5 for any
##   age x and birth order i."), potentially as a vector or 2- or 3D array
## - ... are arguments passed to read.table if one of the inputs is a path to a file
## @returns
## - a data frame containing the period fertility table

  # first calculate parity-specific population exposures
  E <- calculate.E.pft(w, exposRR)

  # conditional age-specific fertility rate without filtering implausible values
  m <- calculate.m.pft(birthsRR, E, FALSE)
  
  years <- dimnames(m)[[1]]
  ages <- sub("[+-]", "", dimnames(m)[[2]])
  
  # it is possible that we couldn't calculate m for all years and ages that we have w and E for
  # due to (non-)availability of births or exposure data, so potentially trim
  # w and E to the same temporal range as m
  # need drop = F to stop w and E being dropped to a 2D array if only one year
  w <- w[dimnames(m)[[1]], sub("[+-]", "", dimnames(w)[[2]]) %in% ages, , drop = FALSE]
  E <- E[dimnames(m)[[1]], sub("[+-]", "", dimnames(E)[[2]]) %in% ages, , drop = FALSE]
  
  # probability of i-th birth
  # R has a function q (quit!) so we'll call the array qix instead
  qix <-calculate.q.pft(m, a)

  # in later calculations, invalid values are assumed to be 0, so we record
  # where such values are before replacing them with 0. We can then mask them
  # back in as NAs after the calculations have been completed
  corrections <- calculate.E.m.q.corrections.pft(E, m, qix)
  E[corrections] <- 0
  m[corrections] <- 0
  qix[corrections] <- 0

  # population of parity i at age x (l),
  # Population exposure of parity i within age interval [x, x+1) (L) and
  # Number of births of order i in age interval [x, x+1) (b)
  # note that indexing of l and L is i+1 (i.e. parity 0 is index 1, etc.)
  b.l.L <- calculate.b.l.L.pft(m, qix, a)
  b <- b.l.L$b
  l <- b.l.L$l
  L <- b.l.L$L
  
  # sum of births per age implemented as separate function as also
  # needed for cft
  Sb <- calculate.Sb(b)
  
  # now we need to tidy up the values which we earlier replaced with 0, but
  # which should be masked in the output
  m[corrections] <- NA
  qix[corrections] <- NA
  
  # now everything is calculated it just needs to be brought into one array
  # and rearranged appropriately
  pft <- abind::abind(w, m, qix, l, b, L, Sb, along = 3)
  
  # no distinction is made between NA, NaN and Inf
  pft[!is.finite(pft)] <- NA

  names(dimnames(pft)) <- c("Year", "Age", "Indicator")

  if (returnType == "data.frame") {
    pft <- array2dataframe.pft(pft)

    # need to bring Year column first, x is then second and the
    # rest in the correct order (w, m, qix, l, b, L, Sb for 1:max)
    offsets <- 0:6 * dim(b)[3]
    pft <- pft[, c(1:2, sapply(2 + 1:dim(b)[3], function(x) {x + offsets}))]
  } else if (returnType == "list") {
    indRange <- 1:dim(b)[3]
    pft <- list(w = pft[, , indRange, drop = FALSE],
                m = pft[, , indRange + max(indRange), drop = FALSE],
                q = pft[, , indRange + (2 * max(indRange)), drop = FALSE],
                l = pft[, , indRange + (3 * max(indRange)), drop = FALSE],
                b = pft[, , indRange + (4 * max(indRange)), drop = FALSE],
                L = pft[, , indRange + (5 * max(indRange)), drop = FALSE],
                Sb = pft[, , indRange + (6 * max(indRange)), drop = FALSE])
  }
 
  return(pft)
}

