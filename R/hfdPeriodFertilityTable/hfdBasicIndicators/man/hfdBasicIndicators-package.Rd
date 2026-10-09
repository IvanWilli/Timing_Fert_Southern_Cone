%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: hfdBasicIndicators-package.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{hfdBasicIndicators-package}
\alias{hfdBasicIndicators-package}
\alias{hfdBasicIndicators}
\docType{package}
\title{
Calculation of basic indicators included in the Human Fertility Database
}
\description{
This package contains functions for calculation of basic indicators included in the Human
Fertility Database such as age-specific fertility rates (ASFR), total fertility rates (TFR),
mean age at birth (MAB) and parity progression ratios (PPR).
}
\details{
\tabular{ll}{
Package: \tab hfdBasicIndicators\cr
Type: \tab Package\cr
Version: \tab 2.0-1077\cr
Date: \tab 2015-04-26\cr
License: \tab GPL (>= 2.0)\cr
LazyLoad: \tab yes\cr
}
}
\author{
Edward Nash \email{edward.nash@gmx.de}
}
\references{
  Jasilioniene et al.: Methods Protocol for the Human Fertility Database.
  Available from \url{http://www.humanfertility.org} 
}
\keyword{ package }
\seealso{
Packages \code{\link[hfdCohortFertilityTable:hfdCohortFertilityTable-package]{hfdCohortFertilityTable}}
for calculation of cohort fertility tables and
\code{\link[hfdPeriodFertilityTable:hfdPeriodFertilityTable-package]{hfdPeriodFertilityTable}}
for calculation of period fertility tables and related indicators
}
\examples{
  data(someBirths.TR, someExpos.TR)
  births <- produceLexisShapes(someBirths.TR, "VH", "births")
  expos <- produceLexisShapes(someExpos.TR, "VH", "expos")
  asfr <- calculate.asfr(births, expos, "VH")
  cfr <- calculate.cfr(asfr, "VH")
  mab <- calculate.mab(asfr, "VH")
  tfr <- calculate.tfr(asfr, "VH")
  ppr <- calculate.ppr(asfr)
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
