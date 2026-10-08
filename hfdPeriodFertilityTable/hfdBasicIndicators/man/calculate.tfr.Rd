%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: calculate.tfr.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{calculate.tfr}
\alias{calculate.tfr}
\alias{calculate.adjtfr}
\title{
  Calculation of total fertility rates and tempo-adjusted TFR
}
\description{
  \code{calculate.tfr} calculates period or cohort total fertility rates from a supplied
  set of age-specific fertility rates. Both total fertility rate and total
  fertility rate at age 40 are calculated.
  
  \code{calculate.adjtfr} calculates tempo-adjusted period total fertility
  rates from sets of total fertility rates and mean ages at birth.
}
\usage{
calculate.tfr(asfr, shape, observeFrom = 15, observeTo = 50, \dots)
calculate.adjtfr(tfr, mab, shape = "RR", ...)
}
\arguments{
  \item{asfr}{
  Age-specific fertility rate data as a \code{\link{data.frame}}, \code{\link{array}}
  or path to a file. See details. 
}
  \item{tfr}{
  Total fertility rate data by year as a \code{\link{data.frame}} or path to a file. See details. 
}
  \item{mab}{
  Mean age at birth data as a \code{\link{data.frame}} or path to a file. See details. 
}
  \item{shape}{
  The Lexis shape in which the data is expressed; one of RR or VH for \code{calculate.tfr} and always RR for \code{calculate.adjtfr}
}
  \item{observeFrom}{
  For VH, the maximum age from which cohorts must have been observed. Ignored for RR.
}
  \item{observeTo}{
  For VH, the minumum age to which cohorts must have been observed to calculate MAB. Ignored for RR.
}
  \item{\dots}{
  Named arguments which will potentially be passed to \code{\link{read.table}}. See details.
}
}
\details{
  If supplied as a \code{\link{data.frame}}, the columns contained in \code{asfr} will depend on the
  code{shape} and whether or not order-specific data is present. For RR and VH, columns Year or Cohort
  respectively, Age and ASFR potentially followed by ASFR1..ASFRxp are expected. For RR (period), it
  is assumed that all ages have been observed. For VH (cohort), TFR and TFR40 are calculated only for
  cohorts observed from  at most age \code{observeFrom} up to at least age \code{observeTo - 1} for TFR
  and age 39 for TFR40.
  
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

  \code{tfr} and \code{mab} may be supplied either as a \code{\link{data.frame}} containing
  the data as featured in HFD output (columns Year, TFR, TFR1, TFR2, ..., TFR40, TFR40_1, TFR40_2 and
  analogously for MAB) or as a path to a file representing this as detailed for \code{asfr} above.
  The columns TFR40 and MAB40 are ignored if present.
}
\value{
  For \code{calculate.tfr}, a data frame containing the calculated TFR and TFR40. For RR, the columns are Year, Age, TFR,
  potentially TFR1..TFRxp, TFR40, potentially TFR40_1..TFR40_xp. For VH, the columns are Cohort,
  Age, CCF, potentially CCF1..CCFxp, CCF40, potentially CCF40_1..CCF40_xp. If an invalid
  shape is supplied or no cohorts were observed for a sufficiently long period, \code{NULL} is
  returned.  
  
  For \code{calculate.adjtfr}, 
}
\references{
  Jasilioniene et al.: Methods Protocol for the Human Fertility Database.
  Available from \url{http://www.humanfertility.org} 

  Tempo-adjusted TFR:
  Bongaarts, J. and G. Feeney. 1998. \dQuote{On the quantum and tempo of fertility}. Population and Development Review 24 (2): 271-291.
}
\author{
  Edward Nash \email{edward.nash@gmx.de}
}
\seealso{
  \code{\link{calculate.asfr}} for production of data frames containing age-specific fertility rates
  and \code{\link{calculate.mab}} for production of data frames containing mean ages at birth.
  Also \code{\link{calculate.cbr}} for crude birth rates.
}
\examples{
  data(someBirths.TR, someExpos.TR)
  births <- produceLexisShapes(someBirths.TR, "VH", "births")
  expos <- produceLexisShapes(someExpos.TR, "VH", "births")
  asfr <- calculate.asfr(births, expos, "VH")
  calculate.tfr(asfr, "VH")
  calculate.tfr(asfr, "VH", 12, 55) # use only cohorts observed for full HFD range for CMAB
  births <- produceLexisShapes(someBirths.TR, "RR", "births")
  expos <- produceLexisShapes(someExpos.TR, "RR", "expos")
  asfr <- calculate.asfr(births, expos, "RR")
  tfr <- calculate.tfr(asfr, "RR")
  mab <- calculate.mab(asfr, "RR")
  calculate.adjtfr(tfr, mab)
  \dontrun{
  calculate.tfr("USAasfrRR.txt", "RR") # HFD format input file
  calculate.tfr("myasfr.txt", "RR", sep = ",", na.strings = "", skip = 0) # comma-separated input file
  }
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
