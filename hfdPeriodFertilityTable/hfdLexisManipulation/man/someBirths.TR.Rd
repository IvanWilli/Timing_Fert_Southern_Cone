%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: someBirths.TR.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{someBirths.TR}
\alias{someBirths.TR}
\docType{data}
\title{
  Sample birth counts arranged by Lexis triangles
}
\description{
  This dataset contains synthetic birth counts by Lexis triangles to enable experimentation
  with the HFD processing functions. 
}
\usage{data(someBirths.TR)}
\format{
  A data frame with data for Years 1970-2006, Age 12-55 and birth orders 1-5 with the following columns:
  \describe{
    \item{\code{Year}}{a numeric vector: Year of occurence of births}
    \item{\code{Age}}{a numeric vector: Age of mother in completed years}
    \item{\code{Cohort}}{a numeric vector: Cohort (year of birth) of mother}
    \item{\code{Total}}{a numeric vector: Total number of observed births}
    \item{\code{B1}}{a numeric vector: number of order 1 births}
    \item{\code{B2}}{a numeric vector: number of order 2 births}
    \item{\code{B3}}{a numeric vector: number of order 3 births}
    \item{\code{B4}}{a numeric vector: number of order 4 births}
    \item{\code{B5p}}{a numeric vector: number of births of order 5 and higher}
  }
}
\source{
  Composite of data from the Human Fertility Database: \url{http://www.humanfertility.org} 
}
\examples{
data(someBirths.TR)
}
\keyword{datasets}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
