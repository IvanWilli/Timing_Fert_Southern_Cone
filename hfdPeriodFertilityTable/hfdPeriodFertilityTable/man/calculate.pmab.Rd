%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: calculate.pmab.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{calculate.pmab}
\alias{calculate.pmab}
\title{
  Calculate period table mean age at birth
}
\description{
  This function calculates the period table mean age at birth (TMAB) from a period fertility table.
  Both total and order-specific TMAB are calculated.
}
\usage{
calculate.pmab(pft, a = 0.5, \dots)
}
\arguments{
  \item{pft}{
  A period fertility table or the table births from a PFT. See details.
}
  \item{a}{
  The average share of the age interval [x, x+1) lived before giving birth.
  May be supplied as a single number or as a vector of values, one
  per year/age in \code{pft}.
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
  A data frame containing the calculated TMAB with the columns Year, TMAB, TMAB1, \dots, TMABnp
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
\code{\link[hfdBasicIndicators:calculate.mab]{calculate.mab}} for other calculation of mean age at birth
}
\examples{
data(someBirths.RR, someExpos.RR, someWeightings)
pft <- calculate.pft(someBirths.RR, someExpos.RR, someWeightings)
calculate.pmab(pft)
\dontrun{
# read PFT from a file with no headers and with NA represented with "NA"
calculate.pmab("mypft.txt", skip = 0, headers = FALSE, na.strings = "NA")
}
calculate.pmab(array(100, dim = c(3, 10, 5), dimnames = list(Year = 1996:1998, Age = 15:24, Indicator = c(paste("b", 1:4, "x", sep = ""), "b5px")))) 
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
