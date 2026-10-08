%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: internal.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{.internal}
\alias{.internal}
\alias{.convertInputDataFrameToArray}
\alias{.readInputData}
\title{
  Internal functions for the hfdPeriodFertilityTable package
}
\description{Internal functions in the package are (un)documented here}
\details{
\verb{.convertInputDataFrameToArray(someData)}
Arguments:\describe{
  \item{someData}{
  a data frame containing some dataset (probably births or expos)
  as Lexis squares. The columns
  Year, Age, data, [data1, ..., dataxp] are assumed.
  Data with or without order-specific may be supplied.
}
}

\verb{.readInputData(file, \dots)}
Arguments:\describe{
  \item{file}{The path to a file or a connection}
  \item{\dots}{Arguments passed to \code{\link{read.table}}, potentially as a \code{\link{list}}
  with named entries, each of which is a list of arguments to read.table}
}
Arguments \code{skip = 2, header = TRUE, na.strings = "."} are appended
to \dots if not present, and so must be supplied if these default values should
be overridden.
}
\value{
For \code{.convertInputDataFrameToArra}, a 3D array with named dimensions Year, Age, Order
containing the data.

For \code{.readInputData}, the result of calling \code{\link{read.table}} with arguments \dots - 
probably a \code{\link{data.frame}}, maybe an error.
}
\author{
Edward Nash \email{edward.nash@gmx.de}
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
