################################################################################
##
## Subversion file information - please do not edit this block
## $Rev: 842 $
## $Date: 2010-11-09 16:49:10 +0100 (Di, 09. Nov 2010) $
## $Author: nash $
## $Id: parity.prepare.matrix.R 842 2010-11-09 15:49:10Z nash $
##
################################################################################

parity.prepare.matrix <-
  function(parity.weights) {
## Convert data frame of parity weights into a 3D array suitable for input to
## calculateAgeParityDistribution functions
##
## @inputs
## - parity.weights is a data frame of parity weights with columns
##   Year, Age, w0, w1, ..., wxp
##
## @returns
## - a 3D array with dimensions Year, Age, Parity containing the
##   parity weightings. Age will be extended by 1 at the lower end
##   (i.e. age xmin-1 will be added), with the lowest parity distribution
##   always being 1, 0, ..., 0

  # add a line for age 11 to the data for each year with parity distribution
  # 1, 0, ... , 0, assuming there is some data left
  if (nrow(parity.weights) > 0) {
    parity.weights <-
      rbind(parity.weights,
        cbind(Year = unique(parity.weights$Year),
          Age = min(parity.weights$Age) - 1,
          as.data.frame(array(c(1, rep(0, ncol(parity.weights) - 3)),
                        dim = c(1, ncol(parity.weights) - 2),
                        dimnames = list(NULL, names(parity.weights)[3:ncol(parity.weights)])))))
    # reformat to 3D array
    parity.weights <-
      reshape(parity.weights,
        varying = names(parity.weights)[3:7],
        v.names = "w", timevar = "Parity",
        times = names(parity.weights)[3:7],
        direction = "long")                      
    parity.weights <-
      tapply(parity.weights$w,
        list(parity.weights$Year,
          parity.weights$Age,
          parity.weights$Parity),
        function(x){x})
  } else {
    # create empty 3D array
    parity.weights <- array(dim = c(0, 0, 0), dimnames = list(c(), c(), c()))
  }
  names(dimnames(parity.weights)) <- c("Year", "Age", "Parity")
  return(parity.weights)
}
