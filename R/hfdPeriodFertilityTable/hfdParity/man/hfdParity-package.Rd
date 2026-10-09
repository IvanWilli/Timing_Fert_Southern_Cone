\name{hfdParity-package}
\alias{hfdParity-package}
\alias{hfdParity}
\docType{package}
\title{
  Generation of population by age and parity weightings from census or register data
}
\description{
  This package provides functions for producing age/parity weightings on 1st January
  from census or register data, which may be taken at any time in the year, using methods as described
  in the Human Fertility Database Methods Protocol.
}
\details{
\tabular{ll}{
Package: \tab hfdParity\cr
Type: \tab Package\cr
Version: \tab 2.0-1077\cr
Date: \tab 2015-04-26\cr
License: \tab GPL (>= 2.0)\cr
LazyLoad: \tab yes\cr
}
}
\author{
Edward Nash \email{edward.nash@gmx.de} and Krystof Zeman \email{Krystof.Zeman@oeaw.ac.at}

Maintainer: Edward Nash \email{edward.nash@gmx.de}
}
\references{
  Jasilioniene et al.: Methods Protocol for the Human Fertility Database.
  Available from \url{http://www.humanfertility.org}
  
  Methods for redistribution of unknown parity may be described in individual country documentation,
  available under the same address. 
}
\keyword{ package }
\seealso{
  \code{\link[hfdPeriodFertilityTable:hfdPeriodFertilityTable-package]{hfdPeriodFertilityTable}} for usage
  of parity distributions
}
\examples{
  data(someBirths.TR, someExpos.TR, sweRegisterPath)

  calculateAgeParityDistribution.cumulative(someBirths.TR, someExpos.TR)

  swe.weights <- parity.1Jan.weights(parity.census.weights(sweRegisterPath))
  w.swe <- parity.prepare.matrix(swe.weights)

  calculateAgeParityDistribution.register(someBirths.TR, someExpos.TR, w.swe)
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
