%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: preprocessLexisTriangles.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{preprocessLexisTriangles}
\alias{preprocessLexisTriangles}
\title{
  Preprocess a Lexis triangle dataset so it will aggregate correctly
}
\description{
  This function performs preprocessing of a Lexis triangle dataset so that it will
  aggregate correctly for the HFD when using the function \code{\link{aggregateLexisShape}}.
  Operations performed are \itemize{
  \item for VH, upper triangles in the first year and lower triangles in the last year are discarded
  \item for VV births, upper triangles for the maximum age have 1 added to their Cohort value
} 
}
\usage{
preprocessLexisTriangles(TRdata, shape, dataType, \dots)
}
\arguments{
  \item{TRdata}{
  The Lexis triangle data. See details.
}
  \item{shape}{
  The shape to which the Lexis triangle data is to be aggregated; one of RR, VH or VV
}
  \item{dataType}{
  The type of the data in \code{TRdata}; typically either births or expos (for exposure)
}
  \item{\dots}{
  Named arguments which will potentially be passed to \code{\link{read.table}}. See details.
}
}
\details{
If passed as a \code{\link{data.frame}}, for \code{TRdata}, the columns Year, Cohort, Age
and any number of data columns are expected,
allowing either order-specific or total values to be handled. Shape is one of \describe{
\item{RR}{Lexis rectangles/squares: aggregate by year and age}
\item{VH}{Lexis horizontal parallelograms: aggregate by cohort and age}
\item{VV}{Lexis vertical parallelograms: aggregate by year and cohort}
}

\code{TRdata} may be supplied as: \describe{
  \item{\code{\link{data.frame}}}{Which is assumed to contain the data in a format analogous
    the usual HFD output format, i.e. as described in the previous paragraph.
  }
  \item{\code{\link{character}} (or \code{\link{connection}})}{the path to a file containing
    the data in the format as for a \code{data.frame}. This file will be read in using
    \code{\link{read.table}} with the parameters \code{skip = 2, header = TRUE, na.strings = "."}.
    These parameters may be modified or additional parameters supplied by passing named arguments
    as \dots.}
}
}
\note{
  The published files of births by Lexis triangles from the HFD include 
  the open-age intervals 12- and 55+ as Lexis RR with Cohort \code{NA} (.). Any
  rows containing +- in Age or \code{NA} in Cohort will be dropped. For VH and VV, using
  these input files directly will therefore result in a dataset from age 13 to 54.
}
\value{
  A data frame either the same columns as \code{TRdata} containing the preprocessed data: unless
  \code{shape} is VH or \code{shape} is VV and \code{dataType} is births then this is identical
  to \code{TRdata} 
}
\author{
  Edward Nash \email{edward.nash@gmx.de}
}
\seealso{
  \code{\link{aggregateLexisShape}} for what to do with the preprocessed data and
  \code{\link{produceLexisShapes}} which uses this function internally
}
\examples{
  data(someBirths.TR, someExpos.TR)
  preprocessLexisTriangles(someBirths.TR, "VH", "births")
  preprocessLexisTriangles(someExpos.TR, "VV", "expos") # returns someExpos.TR
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
