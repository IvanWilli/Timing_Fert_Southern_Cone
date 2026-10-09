%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: calculate.m.pft.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{calculate.m.pft}
\alias{calculate.m.pft}
\title{
  Calculate conditional age- and parity- specific fertility rates for period fertility tables
}
\description{
  Calculate age- and parity- specific (conditional) fertility rates from
  births by age and order, female population exposures and mid-year
  distribution of female population by parity.
}
\usage{
calculate.m.pft(birthsRR, E, filterPlausible = FALSE, adjustE = TRUE, \dots)
}
\arguments{
  \item{birthsRR}{
  observed births by birth order by Lexis squares. See details.
}
  \item{E}{
  parity-specific female population exposures. See details.
}
  \item{filterPlausible}{
  a Boolean value indicating whether implausible values (greater than 1.0) should be replaced
  with \code{NA}s.
}
  \item{adjustE}{
  a Boolean value indicating whether low values of E (<= 5) should be replaced with zero.
}
  \item{\dots}{
  arguments which will be passed through to \code{\link{read.table}} for inputs which are to be read
  from file. See details.
}
}
\details{
\code{birthsRR} and \code{E} may be supplied as: \describe{
  \item{\code{\link{data.frame}}}{Which is assumed to contain the data in a format analogous
    the usual HFD output format, i.e. with lead columns Year and Age. For \code{birthsRR}, the
    columns Year, Age, Total, B1, B2, \dots, Bnpx are expected, for \code{E}, the
    columns Year, Age and E1, E2, \dots, Enpx where n is the highest (open) parity/order.
    See \code{\link{someBirths.RR}} for examples.
  }
  \item{\code{\link{character}} (or \code{\link{connection}})}{the path to a file containing
    the data in the format as for a \code{data.frame}. This file will be read in using
    \code{\link{read.table}} with the parameters \code{skip = 2, header = TRUE, na.strings = "."}.
    These parameters may be modified or additional parameters supplied by passing named arguments
    as \dots.}
  \item{\code{\link{array}}}{A 3D array containing the data arranged by Year, Age, Indicator, where
    Indicator are the columns as described for data.frame. The dimensions must be named. For
    \code{exposRR}, a 2D array (Year/Age) is also acceptable. See \code{\link{someWeightings}}
    for an example.}
}

\code{\dots} may be supplied either as named arguments to \code{\link{read.table}} or as a
\code{\link{list}} with arguments named according to the data item they refer to (i.e.
\code{exposRR} and \code{w} and entries being a list containing the named arguments for that
data item (see Examples to clarify this!).

  
}
\section{Warning}{
  It is assumed that \code{birthsRR} and \code{E} cover the same range of ages and orders/parities
  (e.g. B1..5p and E1..4p). Behaviour if they  do not is undefined. 
}
\value{
  A 3D array of conditional fertility rates with named dimensions Year, Age and Order. The year range
  is the intersection of the years contained in \code{birthsRR} and \code{E}. If
  \code{filterPlausible} is \code{TRUE}, any values greater than 1.0 will be replaced with \code{NA}.
  Other non-finite values (e.g. \code{Inf}) may in any case be present.
}
\references{
  Jasilioniene et al.: Methods Protocol for the Human Fertility Database.
  Available from \url{http://www.humanfertility.org} 
}
\author{
Edward Nash \email{edward.nash@gmx.de}
}
\seealso{
\code{\link{calculate.E.pft}} for a function to calculate \code{E} and
\code{\link[hfdCohortFertilityTable:calculate.m.cft]{calculate.m.cft}} for the cohort fertility table version of this function.
}
\examples{
data(someBirths.RR, someExpos.RR, someWeightings)
E <- calculate.E.pft(someWeightings, someExpos.RR)
calculate.m.pft(someBirths.RR, E, FALSE)
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
