%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: calculate.cfr.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{calculate.cfr}
\alias{calculate.cfr}
\alias{shortname.cfr}
\title{
  Calculation of cumulated fertility rates from age-specific fertility rates
}
\description{
  \code{calculate.cfr} is used for producing a data frame of cumulated fertility rates
  (CFR) from a data frame of age-specific fertility rates in a given Lexis shape.
  \code{shortname.cfr} indicates the abbreviation used for the cumulated fertility rates
  for a given shape.
}
\usage{
calculate.cfr(asfr, shape, observeFrom, \dots)
shortname.cfr(shape)
}
\arguments{
  \item{asfr}{
  Age-specific fertility rate data as a \code{\link{data.frame}}, \code{\link{array}}
  or path to a file. See details. 
}
  \item{shape}{
  The Lexis shape in which the data is expressed; one of RR, VH or VV
}
  \item{observeFrom}{
  For cohort data, the maximum age from which cohorts must be observed in order
  for the CFR to be calculated: cohorts not observed from this age will be dropped.
}
  \item{\dots}{
  Named arguments which will potentially be passed to \code{\link{read.table}}. See details.
}
}
\details{
  If supplied as a \code{\link{data.frame}}, the columns contained in \code{asfr} will depend on the
  \code{shape} and whether or not order-specific data is present. For RR and VH, columns Year or
  Cohort respectively, Age and ASFR potentially followed by ASFR1..ASFRxp are expected.
  For VV, Year, ARDY, Cohort and then data.
  
\code{asfr} may be supplied as: \describe{
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
    VH and VV data respectively is also acceptable.}
}
}
\value{
  For \code{calculate.cfr}, a data frame containing the cumulated fertility rate.
  The first two columns are as for the input \code{asfr}, followed by data columns
  CPFR and potentially CPFR1..CPFRxp for RR and CCFR and potentially CCFR1..CCFRxp for VH and VV.

  For \code{shortname.cfr}, a string: "CPFR" for RR or "CCFR" for VH and VV.
  For both functions, \code{NULL} if \code{shape} is not one of RR or VH.
}
\references{
  Jasilioniene et al.: Methods Protocol for the Human Fertility Database.
  Available from \url{http://www.humanfertility.org} 
}
\author{
  Edward Nash \email{edward.nash@gmx.de}
}
\seealso{
  \code{\link{calculate.asfr}} for production of data frames containing age-specific fertility rates
}
\examples{
  data(someBirths.TR, someExpos.TR)
  births <- produceLexisShapes(someBirths.TR, "VH", "births")
  expos <- produceLexisShapes(someExpos.TR, "VH", "births")
  asfr <- calculate.asfr(births, expos, "VH")
  calculate.cfr(asfr, "VH", 15)
  \dontrun{
    # read asfr from a standard HFD file
    calculate.cfr("USAasfrVHbo.txt", "VH")
    # read asfr from a comma-separated file with 4 additional header lines
    calculate.cfr("myasfr.txt", "RR", sep = ",", na.strings = "", skip = 4)
  }

  shortname.cfr("RR") # CPFR (cumulative period fertility rate)
  shortname.cfr("VH") # CCFR (cumulative cohort fertility rate)
  shortname.cfr("TR") # NULL
}\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
