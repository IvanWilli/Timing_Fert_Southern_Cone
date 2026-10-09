%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: someWeightings.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{someWeightings}
\alias{someWeightings}
\docType{data}
\title{
  Some sample data of female population parity weightings
}
\description{
  This is a dataset containing some composite data on estimated weightings of
  female population exposure by year, age and parity intended for use in examples and for
  experimenting with the package \pkg{hfdPeriodFertilityTable}. Some estimated
  weightings of the relative distribution of female exposure by parity for each of the years
  1990-1999, ages 12 - 55 and parity 0 - 4+ are provided.
}
\usage{data(someWeightings)}
\format{
  A 3D array with the dimensions
  \describe{
    \item{\code{Year}}{observation year; 1990 \dots 1999}
    \item{\code{Age}}{age; 12 \dots 55}
    \item{\code{Parity}}{parity; 0 \dots 4+}
  }
}
\details{
  The sample data here are artificial data intended for illustrative purposes only.
}
\note{
  The sum of the relative weightings at each year and age is 1.
}
\source{
  Composite of data from the Human Fertility Database: \url{http://www.humanfertility.org} 
}
\examples{
data(someWeightings)
apply(someWeightings, c(1,2), sum) # see that the sums at each year and age really are 1
}
\keyword{datasets}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
