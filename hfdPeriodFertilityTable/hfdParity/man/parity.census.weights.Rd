%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: parity.census.weights.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{parity.census.weights}
\alias{parity.census.weights}
\title{
  Calculate the relative parity distribution of as population from census data
}
\description{
  This function calculates the relative sizes (weights) of each parity by age for a population
  for each year of census data supplied. The population with an unknown parity may be distributed
  according to any chosen method. Populations with an unknown age will be discarded.
}
\usage{
parity.census.weights(parity, ages = 12:56, reqRange = c(15, 49), maxParity = 4, unkMethod = c(default = "proportional"), outfile = NULL, country = NULL, ldb = TRUE, ...)
}
\arguments{
  \item{parity}{
  A data frame representing the content of a HFD parity input file, or a
  path to such a file.
}
  \item{ages}{
  The range of ages for which to calculate the relative distribution by parity. If the original
  data does not cover the full range, a distribution 1, 0, ..., 0 will be assumed at the lower
  age range and the last actual distribution at the upper age range. Note that if the original
  data contains an age interval > 1 (e.g. 5) within this age range but outside the reqAges then
  a warning is raised and results may be meaningless.
}
  \item{reqRange}{
  The range of single-year ages which is required in the original data, i.e. between these ages (ACY, inclusive),
  all ages must be present with single year data. An fatal error is produced if this condition is not met.
}
  \item{maxParity}{
  The maximum parity level to include in weightings (default 4, i.e. parities 0..4+)
}
  \item{unkMethod}{
  The method to use for redistribution of unknown parities, potentially as a vector keyed by year.
}
  \item{outfile}{
  The path to a file to which to write the relative distributions (\code{NULL} = no file output).
}
  \item{country}{
  The name of the country as it should appear in \code{outfile}.
}
  \item{ldb}{
  Boolean indicating whether to filter \code{parity} to only those rows with LDB 1.
}
  \item{\dots}{
  Arguments required for functions performing redistribution of unknowns.
  See \code{link{parity.unk.redist}} for details.
}
}
\details{
  If \code{parity} is supplied as a data frame, it is expected that it corresponds to the results
  of reading a file using \kbd{read.csv(<filename>, header = TRUE, na.strings = ".")}.
  
  Possible formats of \code{unkMethod} are described in argument \code{method} for
  \code{\link{parity.unk.redist}}.
  
  If written, outfile will contain two header lines indicating the type of data and the
  date the file was written, followed by the results of the calculation of the weights
  in CSV format (including column headers). This may be read in using e.g.
  \kbd{read.csv(<filename>, skip = 2, na.strings = ".")}.
}
\value{
  A data frame containing the relative parity distributions of females for each census and age. Columns
  are \verb{Year, Month, Day, Age, Format, w0, w1, \dots, w<maxParity>+}, where format is the format
  of the age (ACY or ARDY).
}
\references{
  Country documentation files from \url{http://www.humanfertility.org}. The expected format of \code{parity}
  and the resulting \code{outputFile} may also be found in the data formats documentation available from
  the same address.
}
\author{
Edward Nash \email{edward.nash@gmx.de}

Maintainer: Edward Nash \email{edward.nash@gmx.de}
}
\seealso{
  \code{\link{parity.unk.redist}} for details of the redistribution of unknown parities and
  \code{\link{parity.1Jan.weights}} and \code{\link{parity.reformat.weights}} for adjusting census
  redistributions to distributions on 1st January and for reformatting census weights to a 3D array
  respectively.
}
\examples{
data(czeCensus, sweRegisterPath)
p <- parity.census.weights(czeCensus, unkMethod = c(`1991` = "allToZero")) # returns invisibly!
p
p <- parity.census.weights(sweRegisterPath, maxParity = 3) # read from file, aggregate 3+
p
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
