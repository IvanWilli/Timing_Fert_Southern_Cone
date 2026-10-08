%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: parity.unk.redist.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{parity.unk.redist}
\alias{parity.unk.redist}
\alias{parity.unk.redist.allToZero}
\alias{parity.unk.redist.belowXtoZero}
\alias{parity.unk.redist.proportional}
\title{
  Distribute females of unknown parity to specific parities using different methods
}
\description{
  These functions may be used to redistribute females of unknown parity at each
  age between the parity levels using a chosen method. Further methods may
  be added to cover country- or census-specific cases not covered by the standard
  methods provided
}
\usage{
parity.unk.redist(parity, method = c(default = "proportional"), outfile = NULL, \dots)
parity.unk.redist.allToZero(parity, \dots)
parity.unk.redist.belowXtoZero(parity, x, \dots)
parity.unk.redist.proportional(parity, \dots)
}
\arguments{
  \item{parity}{
  A data frame representing the content of a HFD parity input file, or (for \code{parity.unk.redist} only) a
  path to such a file.
}
  \item{method}{
  The method to use, potentially as a vector keyed by year.
}
  \item{outfile}{
  The path to a file to which to write the redistributed parity data (\code{NULL} = no file output).
}
  \item{x}{
  The age below which females of unknown parity should be assigned to parity 0 for the redistribution method
  \dQuote{belowXtoZero}.
}
  \item{\dots}{
  Further arguments which may be required by individual redistribution functions.
}
}
\details{
  If \code{parity} is supplied as a data frame, it is expected that it corresponds to the results
  of reading a file using \kbd{read.csv(<filename>, header = TRUE, na.strings = ".")} and that any
  filtering of unwanted data (e.g. that set to LDB 0) has been performed. If \code{parity} is supplied
  as the path to a file, this file will be opened using these options and then filtered to only rows
  with LDB 1.
  
  For \code{parity.unk.redist}, any number of years may be supplied in the \code{parity} data. For individual
  method functions, \code{parity} should represent only a single year of data.

  Method may be supplied as a single character string or as a vector with keys corresponding to the year for
  which each method should be supplied. The special key \samp{default} is applied to any years in \code{parity}
  for which no key exists. A valid method argument may therefore look like
  \samp{c(`1980` = "proportional", `1991` = "proportional", default = "allToZero")}.

  The file written to \code{outfile}, if supplied, uses the HFD parity input file format.
  
  The predefined redistribution methods are: \describe{
  \item{allToZero}{all females with unknown parity will be assigned to parity 0.}
  \item{belowXtoZero}{all females with unknown parity and age below \code{x} will be assigned to parity 0,
    all with age equal to or greater than \code{x} will be distributed proportionally.}
  \item{proportional}{all females with unknown parity will be distributed between parity levels proportional
    to the recorded population at each level.}
  } 
}
\value{
  A data frame in the same format as \code{parity} with females with unknown parity redistributed
  according to the chosen method for each year and the data rows for totals and unknowns removed.
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
\note{
  Further fumctions for redistribution may be supplied and called by users. Each should have a name
  of the form \code{parity.unk.redist.<method-name>} and arguments \code{parity} and \code{\dots}, as well
  as any other named arguments required. \code{parity} should be expected to be a data frame representing
  a single year from a HFD parity input file. Such functions may then be used by supplying
  \code{<method-name>} in \code{method} to \code{parity.unk.redist}.
}
\examples{
data(czeCensus)
p <- parity.unk.redist(czeCensus, "allToZero") # returns invisibly
p
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
