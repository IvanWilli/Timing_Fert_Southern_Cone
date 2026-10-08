%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: someBirths.RR.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{someBirths.RR}
\alias{someBirths.RR}
\docType{data}
\title{
  Some sample data on births by Lexis squares
}
\description{
  This is a dataset containing some composite data on births by Lexis squares
  (Year / Age) intended for use in examples and for experimenting with the package
  \pkg{hfdPeriodFertilityTable}. Some birth counts for the years 1990-1999 and ages 12- - 55+ are
  provided by total births and birth orders 1 - 5+.
}
\usage{data(someBirths.RR)}
\format{
  A data frame with 440 rows and the following 8 columns:
  \describe{
    \item{\code{Year}}{a numeric vector of the observation year; 1990-1999}
    \item{\code{Age}}{a factor with of the age; 12-, 13, \dots, 54, 55+}
    \item{\code{Total}}{a numeric vector of the total births observed}
    \item{\code{B1}}{a numeric vector of the order 1 births observed}
    \item{\code{B2}}{a numeric vector of the order 2 births observed}
    \item{\code{B3}}{a numeric vector of the order 3 births observed}
    \item{\code{B4}}{a numeric vector of the order 4 births observed}
    \item{\code{B5p}}{a numeric vector of the order 5+ births observed}
  }
}
\details{
  The sample data here are artificial data intended for illustrative purposes only.
}
\source{
  Composite of data from the Human Fertility Database: \url{http://www.humanfertility.org} 
}
\examples{
data(someBirths.RR)
}
\keyword{datasets}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
