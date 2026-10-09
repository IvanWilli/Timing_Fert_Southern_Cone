%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: calculate.ppr.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{calculate.ppr}
\alias{calculate.ppr}
\title{
  Calculation of cohort parity progression ratios from total fertility rates
}
\description{
  This function calculates the cohort parity progression ratios from a data frame containing
  cohort total fertility rates.
}
\usage{
calculate.ppr(ctfr, shape = "VH", ...)
}
\arguments{
  \item{ctfr}{
  A \code{\link{data.frame}} or path to file containing the cohort order-specific total
  fertility rates. See details.
}
  \item{shape}{
  The shape of the data: always "VH" and included for compatibility with other similar functions.
}
  \item{\dots}{
  Named arguments which will potentially be passed to \code{\link{read.table}}. See details.
}
}
\details{
  If supplied as a \code{\link{data.frame}}, \code{ctfr} should contain the columns
  Cohort, Age, CCF, CCF1, \dots, CCFxp. Further columns (e.g. for CCF40 and order-specific
  CCF40) may be present and will be ignored.

\code{tfr} may be supplied as: \describe{
  \item{\code{\link{data.frame}}}{Which is assumed to contain the data in a format analogous
    the usual HFD output format, i.e. as described in the previous paragraph.
  }
  \item{\code{\link{character}} (or \code{\link{connection}})}{the path to a file containing
    the data in the format as for a \code{data.frame}. This file will be read in using
    \code{\link{read.table}} with the parameters \code{skip = 2, header = TRUE, na.strings = "."}.
    These parameters may be modified or additional parameters supplied by passing named arguments
    as \dots.}
}}
\value{
  A data frame containing the cohort parity progression ratios with the columns Cohort, PPR0_1, 
  PPR1_2, etc., or \code{NULL} if shape is not "VH" or no TFR data was present.
}
\references{
  Jasilioniene et al.: Methods Protocol for the Human Fertility Database.
  Available from \url{http://www.humanfertility.org} 
}
\author{
  Edward Nash \email{edward.nash@gmx.de}
}
\seealso{
  \code{\link{calculate.tfr}} for production of data frames containing total fertility rates
}
\examples{
  data(someBirths.TR, someExpos.TR)
  births <- produceLexisShapes(someBirths.TR, "VH", "births")
  expos <- produceLexisShapes(someExpos.TR, "VH", "births")
  asfr <- calculate.asfr(births, expos, "VH")
  tfr <- calculate.tfr(asfr, "VH")
  calculate.ppr(tfr)
  \dontrun{
  calculate.ppr("USAtfrVHbo.txt", "VH") # HFD format input file
  calculate.ppr("mytfr.txt", "VH", sep = ",", na.strings = "", skip = 0) # comma-separated input file
  }
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
