%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: calculate.Sb.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{calculate.Sb}
\alias{calculate.Sb}
\title{
  Calculate the sum of births up to each age by order
}
\description{
  This function calculates cumulative births by order up to each
  age for each cohort or period.
}
\usage{
calculate.Sb(b)
}
\arguments{
  \item{b}{
  A 3D \code{array} of births by order with named dimensions (period|cohort), age and order
}
}
\details{
  Note that births are summed up to but not including each age!
}
\value{
  A 3D \code{array} of cumulative birth numbers by (cohort|period), age and order
  of the same dimensions as \code{b}
}
\references{
  Jasilioniene et al.: Methods Protocol for the Human Fertility Database.
  Available from \url{http://www.humanfertility.org} 
}
\author{
  Edward Nash \email{edward.nash@gmx.de}
}
\seealso{
  \code{\link{calculate.b.cft}} for producing \code{b},
  \code{\link{calculate.cft}} for producing complete cohort fertility tables
}
\examples{
  data(someAsfr)
  b <- calculate.b.cft(someAsfr)
  Sb <- calculate.Sb(b)
}\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
