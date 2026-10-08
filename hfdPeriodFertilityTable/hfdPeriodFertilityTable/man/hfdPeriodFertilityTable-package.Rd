%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: hfdPeriodFertilityTable-package.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{hfdPeriodFertilityTable-package}
\alias{hfdPeriodFertilityTable-package}
\alias{hfdPeriodFertilityTable}
\docType{package}
\title{
  Production of Period Fertility Tables using the HFD methodology
}
\description{
  This package provides a number of functions to enable demographers to calculate
  Period Fertility Tables using the methodology described in the Methods Protocol
  of the Human Mortality Database. Individual indicators may also be calculated
  for those wanting more control over the process.
}
\details{
\tabular{ll}{
Package: \tab hfdPeriodFertilityTable\cr
Type: \tab Package\cr
Version: \tab 2.0-1077\cr
Date: \tab 2015-04-26\cr
License: \tab GPL (>= 2.0)\cr
LazyLoad: \tab yes\cr
}
}
\author{
Edward Nash \email{edward.nash@gmx.de}

Maintainer: Edward Nash \email{edward.nash@gmx.de}
}
\references{
  Jasilioniene et al.: Methods Protocol for the Human Fertility Database.
  Available from \url{http://www.humanfertility.org} 
}
\keyword{ package }
\seealso{
  Packages \code{\link[hfdBasicIndicators:hfdBasicIndicators-package]{hfdBasicIndicators}} and
  \code{\link[hfdCohortFertilityTable:hfdCohortFertilityTable-package]{hfdCohortFertilityTable}}
  for production of further fertility indicators and tables, and
  \code{\link[hfdParity:hfdParity-package]{hfdParity}} for producing
  parity weightings as input to the calculation of period fertility tables.
}
\examples{
data(someBirths.RR, someExpos.RR, someWeightings)
calculate.pft(someBirths.RR, someExpos.RR, someWeightings)
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
