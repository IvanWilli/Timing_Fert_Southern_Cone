%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: calculate.asfr.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{calculate.asfr}
\alias{calculate.asfr}
\title{
  Calculation of age-specific fertility rates
}
\description{
  This function calculates age-specific fertility rates from the supplied births
  and exposure data, both of which should already have been aggregated where
  necessary to the same Lexis shape.
}
\usage{
calculate.asfr(births, expos, shape, \dots)
}
\arguments{
  \item{births}{
  Observed birth counts as a \code{\link{data.frame}}, 2- or 3D \code{\link{array}} or path to a file.
}
  \item{expos}{
 Estimated female population exposure as a \code{\link{data.frame}}, 2- or 3D \code{\link{array}} or path to a file.
}
  \item{shape}{
  The Lexis shape in which \code{births} and \code{expos} are expressed; one of TR, RR, VH, VV
}
  \item{\dots}{
  Named arguments which will potentially be passed to \code{\link{read.table}}. See details.
}
}
\details{
Both \code{births} and \code{expos} should be aggregated to the desired Lexis shape before
being passed to this function, e.g. using \code{\link{produceLexisShapes}}, and should
both have the same range of years/cohorts and ages. For rectangles (RR) and horizontal
parallelograms (VH), the columns Year or Cohort respectively, Age, Total and potentially B1..Bxp
for (order-specific) birth data, and Year or Cohort, Age and Exposure for exposure data are
expected. For vertical parallelograms (VV), the columns Year, ARDY and Cohort followed by data
columns as for RR and VH. For triangles (TR), the columns, Year, Age, Cohort and then data columns.

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
    datasets without order-specific data a 2D array by Year/Age, Cohort/Age or Year/Cohort for RR,
    VH and VV data respectively is also acceptable.
    Note that data for Lexis triangles (\code{shape == "TR"}) cannot be represented as an array
    - use a data.frame.}
}

\code{\dots} may be supplied either as named arguments to \code{\link{read.table}} or as a
\code{\link{list}} with arguments named according to the data item they refer to (i.e.
\code{births} and \code{expos} and entries being a list containing the named arguments for that
data item (see Examples to clarify this!).

}
\value{
  A data frame containing the age-specific fertility rates in the same format as the inputs: two
  or three factor columns followed by ASFR for total ASFR and potentially ASFR1..ASFRxp for ASFR
  by birth order 1..x
}
\note{
  It is assumed that \code{births} and \code{expos} contain data for the same range of
  years/ages/cohorts and that the data rows are ordered identically. 
}
\references{
  Jasilioniene et al.: Methods Protocol for the Human Fertility Database.
  Available from \url{http://www.humanfertility.org} 
}
\author{
  Edward Nash \email{edward.nash@gmx.de}
}
\seealso{
  \code{\link{produceLexisShapes}} for production of data frames containing aggregated Lexis shape
  data
}
\examples{
  data(someBirths.TR, someExpos.TR)
  births <- produceLexisShapes(someBirths.TR, "RR", "births")
  expos <- produceLexisShapes(someExpos.TR, "RR", "births")
  calculate.asfr(births, expos, "RR")
  \dontrun{
    calculate.asfr("USAbirthsRRbo.txt", "USAexposRR.txt", "RR")
    # myexpos.txt is comma-separated and without additional headers, births is standard HFD format
    calculate.asfr("RUSbirthsVH.txt", "myexpos.txt", "VH", list(expos = list(sep = ",", skip = 0, na.strings = ""))) 
  }
}\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
