%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: parity.1Jan.weights.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{parity.1Jan.weights}
\alias{parity.1Jan.weights}
\alias{parity.reformat.weights}
\title{
  Reformat a set of census weights and rebase them to 1st January
}
\description{
  \code{parity.1Jan.weights} takes a set of female population distribution by parity data
  from censuses on arbitrary dates and produces an estimate of the distribution on
  January 1st of each census year based on the given fertility rate data. If a census
  is on the 31st December, the weights are assumes to the the weights on 1st January
  of the subsequent year.
  
  \code{parity.reformat.weights} may be used for register data recorded on 1st January to
  produce an array compatible with that produced by \code{parity.1Jan.weights} without
  a calculation overhead.
}
\usage{
parity.1Jan.weights(census.weights, asfr.vv.bo, outfile = NULL)
parity.reformat.weights(census.weights, ages = 12:56, outfile = NULL)
}
\arguments{
  \item{census.weights}{
  A data frame containing information of the relative distribution of female population by
  parity (weights) for one or more years, or a file containing this
}
  \item{asfr.vv.bo}{
  The path to a file containing age-specific fertility rates by birth order by vertical
  parallelograms, or a data frame representing this
}
  \item{outfile}{
  The path to a file to write the output (\code{NULL} = no file output)
}
  \item{ages}{
  The range of ages to maintain in the output: ages outside this range are dropped 
}
}
\details{
  For \code{census.weights}, the columns \verb{Year, Month, Day, Age, Format, w0, w1, \dots, w<maxParity>+},
  where format is the format of the age (ACY or ARDY) are assumed. If supplied as a file path, CSV format
  with column heads is assumed and two title rows are skipped. For \code{parity.reformat.weights}, \verb{Month}
  and \verb{Day} must all be equal to 1.
  
  If all census data is from 31st December, the argument \code{asfr.vv.bo} is not used
  and so e.g. \code{NULL} may be used.
  
  If written, \code{outfile} is a CSV output of the resulting data frame written using
  \verb{write.csv(, quote = FALSE, na = ".", row.names = FALSE)}
  
  If some ages are missing in the input data, processing stops with an error.
}
\value{
  A data frame of female population parity distribution on January 1st with the columns
  Year, Age, w0, w1, \dots, wxp
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
  \code{\link{parity.census.weights}} for producing suitable \code{census.weights}.
}
\examples{
data(czeCensus, sweRegisterPath, someBirths.TR, someExpos.TR)
census.parity <- parity.census.weights(czeCensus)
birthsVV <- produceLexisShapes(someBirths.TR, "VV", "births")
exposVV <- produceLexisShapes(someExpos.TR, "VV", "expos")
asfrVV <- calculate.asfr(birthsVV, exposVV, "VV")
p <- parity.1Jan.weights(census.parity, asfrVV) # returns invisibly
p
register.parity <- parity.census.weights(sweRegisterPath)
unique(register.parity$Year)
register.parity <- parity.1Jan.weights(register.parity)
unique(register.parity$Year) # note years are now 1981-1985
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
