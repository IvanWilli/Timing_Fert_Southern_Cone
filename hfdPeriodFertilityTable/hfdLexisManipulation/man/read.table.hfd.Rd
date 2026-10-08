%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: read.table.hfd.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{read.table.hfd}
\alias{read.table.hfd}
\title{
  Read an HFD output database table 
}
\description{
  This function provides a simple mechanism to read an HFD output database
  table (counts, exposures, rates, indicators, fertility tables). Options
  are provided to clean up the standard input, or to modify the arguments
  used in \code{\link{read.table}}.
}
\usage{
read.table.hfd(file, dropSuffixes = FALSE, trimIncomplete = FALSE, ...)
}
\arguments{
  \item{file}{
  Path to a HFD output database file
}
  \item{dropSuffixes}{
  Whether to drop +- suffixes to ages and cohorts, if present
}
  \item{trimIncomplete}{
  Whether to trim rows containing incomplete factors (\code{NA} values).
}
  \item{\dots}{
  Additional arguments passed to \code{\link{read.table}}.
}
}
\details{
  The default arguments passed to \code{\link{read.table}} are
  \code{header = TRUE, skip = 2, na.strings = "."}. These may be
  overridden or additional arguments supplied.
}
\value{
  A \code{\link{data.frame}} representing the data in \code{file}
}
\references{
  \url{http://www.humanfertility.org}
}
\author{
  Edward Nash \email{edward.nash@gmx.de}
}
\examples{
\dontrun{
# will drop rows for 12- and 55+
read.table.hfd("USAbirthsTRbo.txt", trimIncomplete = TRUE)
# will drop the - from 12- and the + from 55+
read.table.hfd("USAasfrRR.txt", dropSuffixes = TRUE)
# will return the data as is (some columns may be factors)
read.table.hfd("USAbirthsRR.txt")
}
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
