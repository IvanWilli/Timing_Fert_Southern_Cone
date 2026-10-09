################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 1012 $
## $Date: 2011-10-26 16:10:43 +0200 (Mi, 26. Okt 2011) $
## $Author: Ed $
## $Id: calculate.b.l.L.pft.R 1012 2011-10-26 14:10:43Z Ed $
##
################################################################################

calculate.b.l.L.pft <-
function(m, qix, a = 0.5) {
## Calculate PFT b, l and L (has to be all in one function due to interdependencies)
##
## @inputs
## - m 3D array of conditional age-specific fertility rates with named dimensions
##   Year, Age, Order
## - qix 3D array of conditional probability of i-th birth with named dimensions
##   Year, Age, Order. Dimensions must match those of m.
## - a is the average share of the age interval [x,x+1] lived before giving
##   birth to a child (MP§8.3: "We assume that all a(x) values are equal to 0.5 for any
##   age x and birth order i."). This may be supplied as anything that is compatible
##   for operations with m (single value, vector (by year), 2D array (by year and age),
##   3D array (by year, age and order))
## @returns
## - a list with entries b, l and L each containing a 3D array of the same dimensions
##   as m and qix with the appropriate indicator

  # first expand a if necessary so that we can reference it element-wise
  # although this could be inefficient memory-wise, it makes the calculation
  # part much easier (and probably more efficient) since we don't have to test
  # for arrayness at that point
  # if the value we've been given has dimensions which are somehow incorrect
  # (i.e. not compatible with m) then stop
  if (!((length(dim(a)) == length(dim(m))) && all(dim(a) == dim(m)))) { # arrays of same size
    if (!((length(a) == 1) || # single value
          (length(a) == dim(m)[1]) || # vector of values, one per year
          ((length(dim(a)) == 2) && all(dim(a) == dim(m)[1:2])))) # array of values, one per year and age
      stop("a and m are incompatible: a should be one value, one value per year (vector), one value per year and age (2D array), or one value per year, age and order (3D array)")
    a <- array(a, dim = dim(m)) # values will be repeated as often as needed
  }

  
  # non-finite values of m and q are treated as 0: this saves
  # testing for them specially but first we record the NAs for
  # blanking out later
  mNA <- is.na(m[, , 1, drop = FALSE])
  # we want mNA to always be 2D, so hack the dimensions
  dim(mNA) <- dim(mNA)[1:2]
  dimnames(mNA) <- dimnames(m)[1:2]
  m[!is.finite(m)] <- 0
  qix[!is.finite(qix)] <- 0

  # population of parity i at age x
  # note that indexing of l is i+1 (i.e. parity 0 is index 1, etc.)
  l <- ifelse(is.na(m), NA, 0)
  # set the names in the parity level dimension
  # l and not m, parity = order - 1
  # slightly convoluted, but seems the easiest way
  dimnames(l)[[3]] <-
    sapply(strsplit(gsub("(m)([[:digit:]]+)(.*)",
          "l \\2 \\3",
          dimnames(l)[[3]]),
        " "),
      function(x){
        x[2] <- as.numeric(x[2]) - 1
        return(paste(x, collapse = ""))
      })
   names(dimnames(l))[3] <- "Parity"
  
  # Population exposure of parity i within age interval [x, x+1)
  # note that indexing of L is i+1 (i.e. parity 0 is index 1, etc.)
  L <- l
  dimnames(L)[[3]] <- sub("l", "L", dimnames(L)[[3]], fixed = TRUE)
  
  # Number of births of order i in age interval [x, x+1)
  b <- ifelse(is.na(m), NA, 0)
  dimnames(b)[[3]] <- sub("m", "b", dimnames(m)[[3]], fixed = TRUE)
  
  # implementation of MP formulae 8.8 - 8.17
  maxO <- dim(l)[3]
  l[, 1, 1] <- ifelse(is.na(l[, 1, 1]), NA, 10000)
  for (x in 1:dim(l)[2]) {
    if (x > 1) l[, x, 1] <- l[, x - 1, 1] * (1 - qix[, x - 1, 1])
    L[, x, 1] <- l[, x, 1] - (l[, x, 1] * qix[, x, 1] * (1 - a[, x, 1]))
    for (i in 2:(maxO - 1)) {
      if (x > 1) l[, x, i] <- l[, x - 1, i] - b[, x - 1, i] +
          (L[, x - 1, i - 1] * m[, x - 1, i - 1])
      L[, x, i] <- l[, x, i] + (l[, x, i - 1] * qix[, x, i - 1] * (1 - a[, x, i])) -
        (l[, x, i] * qix[, x, i] * (1 - a[, x, i]))
    }
    if (x > 1) l[, x, maxO] <- l[, x - 1, maxO] + (L[, x - 1, maxO - 1] * m[, x - 1, maxO - 1])
    L[, x, maxO] <- l[, x, maxO] + (l[, x, maxO - 1] * qix[, x, maxO - 1] * (1 - a[, x, maxO - 1]))
    b[, x, ] <- L[, x, ] * m[, x, ]
    if (x > 1) {
      mask <- apply(mNA[, (x - 1):dim(mNA)[2], drop = FALSE], 1, all)
      l[mask, x, ] <-  NA
      mask <- apply(mNA[, x:dim(mNA)[2], drop = FALSE], 1, all)
      b[mask, x, ] <- L[mask, x, ] <- NA 
    } 
  }

  return(list(b = b, l = l, L = L))
}
