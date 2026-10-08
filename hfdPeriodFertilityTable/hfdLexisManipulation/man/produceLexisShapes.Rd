%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: produceLexisShapes.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{produceLexisShapes}
\alias{produceLexisShapes}
\title{
  Produce a data frame containing aggregated Lexis shape data from Lexis triangle data
}
\description{
  This function produces a data frame containing data aggregated to the given Lexis shape
  from the supplied data frame containing Lexis triangle data. Data with or without
  order-specific data may be transformed
}
\usage{
produceLexisShapes(TRdata, shape, dataType, minAge = 12, maxAge = 55, \dots)
}
\arguments{
  \item{TRdata}{
  Births or exposure data (or, conceptually, any data which may be aggregated by summing)
  in Lexis triangles. See details.
}
  \item{shape}{
  the Lexis shape into which the data should be aggregated; one of RR, VH or VV
}
  \item{dataType}{
  The type of the data in \code{TRdata}; typically either births or expos (for exposure)
}
  \item{minAge}{
  for VV data, the minumum age (ARDY) to include in the resulting data frame. Ignored if shape != VV
}
  \item{maxAge}{
  for VV data, the maximum age (ARDY) to include in the resulting data frame. Ignored if shape != VV
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
  A data frame containing a long-format representation of the
  \code{shapeData}: columns are the factors (plus ARDY for VV data) followed by the total (all-order)
  data and then order-specific data. Column naming is dependent on the \code{dataType}. NULL is returned if
  data is insufficient.
}
\references{
  Jasilioniene et al.: Methods Protocol for the Human Fertility Database.
  Available from \url{http://www.humanfertility.org} 
}
\author{
  Edward Nash \email{edward.nash@gmx.de}
}
\seealso{
  \code{\link{preprocessLexisTriangles}}, \code{\link{aggregateLexisShape}} and
  \code{\link{reshapeLexisShapeData}} which are used internally,
  \code{\link{totalColPositionForShape}} for information about the layout of the resulting
  data frame and \code{\link{lexisShapePrimaryFactor}} and \code{\link{lexisShapeSecondaryFactor}} to
  determine which factors are used for aggregating to each shape.
}
\examples{
data(someBirths.TR)
produceLexisShapes(someBirths.TR, "RR", "births")
\dontrun{
# read from a comma-separated file using empty cells as a NA value and with no header lines to be skipped
produceLexisShapes("mybirths.txt", "VV", minAge = 15, maxAge = 45, skip = 0, sep = ",", na.strings = "")
}
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
