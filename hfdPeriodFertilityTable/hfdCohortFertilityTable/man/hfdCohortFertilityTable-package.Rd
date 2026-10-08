%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1075 $
%% $Date: 2015-04-21 11:47:13 +0200 (Di, 21. Apr 2015) $
%% $Author: Kostova $
%% $Id: hfdCohortFertilityTable-package.Rd 1075 2015-04-21 09:47:13Z Kostova $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{hfdCohortFertilityTable-package}
\alias{hfdCohortFertilityTable-package}
\alias{hfdCohortFertilityTable}
\docType{package}
\title{
  Production of Cohort Fertility Tables using the HFD methodology
}
\description{
  This package provides a number of functions to enable demographers to calculate
  Cohort Fertility Tables using the methodology described in the Methods Protocol
  of the Human Mortality Database. Individual indicators may also be calculated
  for those wanting more control over the process.
}
\details{
\tabular{ll}{
Package: \tab hfdCohortFertilityTable\cr
Type: \tab Package\cr
Version: \tab 2.0-1077\cr
Date: \tab 2015-04-26\cr
License: \tab GPL (>= 2)\cr
LazyLoad: \tab yes\cr
}
  The usual starting point for using this package is the function
  \code{\link{calculate.cft}}. Other functions are provided for calculating
  individual indicators in the cohort fertilty table.
}
\author{
Edward Nash \email{edward.nash@gmx.de}

Maintainer: Edward Nash \email{edward.nash@gmx.de}
}
\references{
  Jasilioniene et al.: Methods Protocol for the Human Fertility Database.
  Available from \url{http://www.humanfertility.org} 
}
\seealso{
  Packages \code{\link[hfdBasicIndicators:hfdBasicIndicators-package]{hfdBasicIndicators}} and
  \code{\link[hfdLexisManipulation:hfdLexisManipulation-package]{hfdLexisManipulation}} for production
  of age-specific fertility rates by horizontal parallelograms from Lexis triangle datasets as input
  to the functions in this package, and
  \code{\link[hfdPeriodFertilityTable:hfdPeriodFertilityTable-package]{hfdPeriodFertilityTable}}
  for production of period fertility tables.
}
\examples{
  data(someAsfr)
  calculate.cft(someAsfr)
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
