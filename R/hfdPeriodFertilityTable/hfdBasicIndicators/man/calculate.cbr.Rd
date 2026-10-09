%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: calculate.cbr.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{calculate.cbr}
\alias{calculate.cbr}
\title{
Calculate crude birth rate.
}
\description{
This function calculates the crude birth rate by year as the ratio of
the sum of births to the ratio of the sum of population exposure across all ages.
}
\usage{
calculate.cbr(births, expos, shape, ...)
}
\arguments{
  \item{births}{
  Observed birth counts as a \code{\link{data.frame}}, 2- or 3D \code{\link{array}} or path to a file.
}
  \item{expos}{
 Estimated TOTAL population exposure as a \code{\link{data.frame}}, 2- or 3D \code{\link{array}} or path to a file.
}
  \item{shape}{
  The Lexis shape in which \code{births} and \code{expos} are expressed; one of TR, RR or VV
}
  \item{\dots}{
  Named arguments which will potentially be passed to \code{\link{read.table}}. See details.
}
}
\details{
Both \code{births} and \code{expos} should be aggregated to the desired Lexis shape before
being passed to this function, e.g. using \code{\link{produceLexisShapes}}, and should
both have the same range of years/cohorts and ages. For rectangles (RR), the columns Year , Age, Total and potentially B1..Bxp
for (order-specific) birth data, and Year, Age and Exposure for exposure data are
expected. For vertical parallelograms (VV), the columns Year, ARDY and Cohort followed by data
columns as for RR . For triangles (TR), the columns, Year, Age, Cohort and then data columns.

\code{births} and \code{expos} may be supplied as: \describe{
  \item{\code{\link{data.frame}}}{Which is assumed to contain the data in a format analogous
    the usual HFD output format, i.e. as described in the previous paragraph.
  }
  \item{\code{\link{character}} (or \code{\link{connection}})}{the path to a file containing
    the data in the format as for a \code{data.frame}. This file will be read in using
    \code{\link{read.table}} with the parameters \code{skip = 2, header = TRUE, na.strings = "."}.
    These parameters may be modified or additional parameters supplied by passing named arguments
    as \dots.}
  \item{\code{\link{array}}}{A 3D array containing the data arranged by Year, Age, Indicator, where
    Indicator are the columns as described for data.frame. The dimensions must be named. For
    datasets without order-specific data a 2D array by Year/Age or Year/Cohort for RR and VV data
    respectively is also acceptable.
    
    Note that data for Lexis triangles (\code{shape == "TR"}) cannot be represented as an array
    - use a data.frame.}
}

\code{\dots} may be supplied either as named arguments to \code{\link{read.table}} or as a
\code{\link{list}} with arguments named according to the data item they refer to (i.e.
\code{births} and \code{expos} and entries being a list containing the named arguments for that
data item (see Examples for \code{\link{calculate.asfr}} to clarify this!).
}
\value{
  A data frame containing the crude birth rates by year with the columns
  Year, CBR and potentially CBR1..CBRx for crude birth rate by birth order 1..x
}
\references{
  Jasilioniene et al.: Methods Protocol for the Human Fertility Database.
  Available from \url{http://www.humanfertility.org}
  
  Preston et al. 2001: Demography - Measuring and Modelling Population Processes.
  Blackwell Publishers.
}
\author{
Edward Nash \email{edward.nash@gmx.de}
}
\note{
  \code{expos} should contain exposure estimates for ALL ages for TOTAL (male + female)
  population and not just females in ages 12-55 in order for the CBR to
  be correctly calculated.
}
\seealso{
  \code{\link{calculate.asfr}} for age-specific fertility rates and
  \code{\link{calculate.tfr}} for total fertility rates.
}
\examples{
  data(someBirths.TR, someExpos.TR)
  calculate.cbr(someBirths.TR, someExpos.TR, "TR")
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
