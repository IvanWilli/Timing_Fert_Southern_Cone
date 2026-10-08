%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: someExpos.TR.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{someExpos.TR}
\alias{someExpos.TR}
\docType{data}
\title{
  Sample female population exposure to risk estimations arranged by Lexis triangles
}
\description{
  This dataset contains synthetic female population exposure to risk estimations by
  Lexis triangles to enable experimentation with the HFD processing functions. 
}
\usage{data(someExpos.TR)}
\format{
  A data frame with data for Years 1970-2006, Age 12-55 and the following columns:
  \describe{
    \item{\code{Year}}{a numeric vector: Year of occurence of births}
    \item{\code{Age}}{a numeric vector: Age of mother in completed years}
    \item{\code{Cohort}}{a numeric vector: Cohort (year of birth) of mother}
    \item{\code{Exposure}}{a numeric vector: Estimated female population exposure in the Lexis triangle}
  }
}
\source{
  Composite of data from the Human Fertility Database: \url{http://www.humanfertility.org} 
}
\examples{
data(someExpos.TR)
}
\keyword{datasets}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
