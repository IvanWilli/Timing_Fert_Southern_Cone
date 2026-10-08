%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: calculate.patfr.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{calculate.patfr}
\alias{calculate.patfr}
\title{
  Calculate period fertility index of total fertility
}
\description{
  Calculate the period fertility index of total fertility (patfr) from a given period
  fertility table. Both total and order-specific PATFR for each year in the PFT will be produced.
}
\usage{
calculate.patfr(pft, radix = 10000, \dots)
}
\arguments{
  \item{pft}{
  A period fertility table or the table births from a PFT. See details.
}
  \item{radix}{
  The size of the table population.
}
  \item{\dots}{
  named arguments which will be passed through to \code{\link{read.table}} for inputs which are to be read
  from file.
}
}
\details{
\code{pft} may be supplied as: \describe{
  \item{\code{\link{data.frame}}}{Which is assumed to contain the data in a format analogous
    the usual HFD output format, i.e. with lead columns Year and x. At least the columns
     Year, x and b1x, \dots, bnxp are required: others will be ignored.
  }
  \item{\code{\link{character}} (or \code{\link{connection}})}{the path to a file containing
    the data in the format as for a \code{data.frame}. This file will be read in using
    \code{\link{read.table}} with the parameters \code{skip = 2, header = TRUE, na.strings = "."}.
    These parameters may be modified or additional parameters supplied by passing named arguments
    as \dots.}
  \item{\code{\link{array}}}{A 3D array containing the data arranged by Year, Age, Indicator, where
    Indicator are the columns as described for data.frame. The dimensions must be named.
}
}
}
\value{
  A data frame containing the calculated PATFR with the columns Year, PATFR, PATFR1, \dots, PATFRnp
  for the years and orders featured in \code{pft}.
}
\references{
  Jasilioniene et al.: Methods Protocol for the Human Fertility Database.
  Available from \url{http://www.humanfertility.org} 
}
\author{
Edward Nash \email{edward.nash@gmx.de}

Maintainer: Edward Nash \email{edward.nash@gmx.de}
}
\seealso{
\code{\link{calculate.pft}} for generating the required input, and
\code{\link[hfdBasicIndicators:calculate.tfr]{calculate.tfr}} for unadjusted Total Fertility Rates
}
\examples{
data(someBirths.RR, someExpos.RR, someWeightings)
pft <- calculate.pft(someBirths.RR, someExpos.RR, someWeightings)
calculate.patfr(pft)
\dontrun{
# read PFT from a file with no headers and with NA represented with "NA"
calculate.patfr("mypft.txt", skip = 0, headers = FALSE, na.strings = "NA")
}
calculate.patfr(array(100, dim = c(3, 10, 5), dimnames = list(Year = 1996:1998, Age = 15:24, Indicator = c(paste("b", 1:4, "x", sep = ""), "b5px")))) 
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
