%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: someExpos.RR.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{someExpos.RR}
\alias{someExpos.RR}
\docType{data}
\title{
  Some sample data on female population exposure by Lexis squares
}
\description{
  This is a dataset containing some composite data on exposure by Lexis squares
  (Year / Age) intended for use in examples and for experimenting with the package
  \pkg{hfdPeriodFertilityTable}. Some estimated female population exposures for the
  years 1990-1999 and ages 12 - 55 are provided.
}
\usage{data(someExpos.RR)}
\format{
  A data frame with 440 rows and the following 3 columns:
  \describe{
    \item{\code{Year}}{a numeric vector of the observation year; 1990-1999}
    \item{\code{Age}}{a numeric vector with of the age; 12 \dots 55}
    \item{\code{Exposure}}{a numeric vector of estimated female population exposures}
  }
}
\details{
  The sample data here are artificial data intended for illustrative purposes only.
}
\source{
  Composite of data from the Human Fertility Database: \url{http://www.humanfertility.org} 
}
\examples{
data(someExpos.RR)
}
\keyword{datasets}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
