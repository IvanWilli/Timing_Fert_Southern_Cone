%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: calculate.mab.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{calculate.mab}
\alias{calculate.mab}
\alias{calculate.sdmab}
\title{
  Calculation of mean and standard deviation age of mother at the birth of their children
}
\description{
  This function calculates the period or cohort mean age at birth (MAB) and standard deviation of
  age at birth sdMAB) of mothers at the
  time of birth of their children based on the given age-specific fertility rates (ASFR).
  The mean and standard deviation of age at birth of children up to mother's age 40 (MAB40) and the mean
  and standard deviation of age at birth at the end of the fertility history (MAB) are calculated, potentially order-specific.
}
\usage{
calculate.mab(asfr, shape, observeFrom = 15, observeTo = 50, a = 0.5, ...)
calculate.sdmab(asfr, shape, observeFrom = 15, observeTo = 50, a = 0.5, ...)
}
\arguments{
  \item{asfr}{
  Age-specific fertility rate data as a \code{\link{data.frame}}, \code{\link{array}}
  or path to a file. See details. 
}
  \item{shape}{
  The Lexis shape in which the data is expressed; one of RR or VH
}
  \item{observeFrom}{
  For VH, the maximum age from which cohorts must have been observed. Ignored for RR.
}
  \item{observeTo}{
  For VH, the minumum age to which cohorts must have been observed to calculate MAB. Ignored for RR.
}
  \item{a}{
  The average share of the age interval [x, x+1) lived before giving birth to a child, as a single
  value or a vector which is compatible for operations with the columns in \code{asfr}.
}
  \item{\dots}{
  Named arguments which will potentially be passed to \code{\link{read.table}}. See details.
}
}
\details{
  If supplied as a \code{\link{data.frame}}, the columns contained in \code{asfr} will depend on the
  code{shape} and whether or not order-specific data is present. For RR and VH, columns Year or Cohort
  respectively, Age and ASFR potentially followed by ASFR1..ASFRxp are expected. For RR (period), it
  is assumed that all ages have been observed. For VH (cohort), MAB,sdMAB, MAB40 andsdMAB40 are calculated only for
  cohorts observed from  at most age \code{observeFrom} up to at least age \code{observeTo - 1} for MAB andsdMAB
  and age 39 for MAB40 andsdMAB40.
  
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
  A data frame containing the calculated indicators. For RR and \code{calculate.mab}, the columns are Year, Age, MAB,
  potentially MAB1..MABxp, MAB40, potentially MAB40_1..MAB40_xp. For VH, the columns are Cohort,
  Age, CMAB, potentially CMAB1..CMABxp, CMAB40, potentially CMAB40_1..CMAB40_xp. If an invalid
  shape is supplied or no cohorts were observed for a sufficiently long period, \code{NULL} is
  returned. For \code{calculate.sdmab}, the column names follow the same pattern but withsdMAB instead of MAB.
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
  calculate.mab(asfr, "VH")
  calculate.mab(asfr, "VH", 12, 55) # use only cohorts observed for full HFD range for CMAB
  \dontrun{
  calculate.mab("USAasfrRR.txt", "RR") # HFD format input file
  calculate.mab("myasfr.txt", "RR", sep = ",", na.strings = "", skip = 0) # comma-separated input file
  }
}\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
