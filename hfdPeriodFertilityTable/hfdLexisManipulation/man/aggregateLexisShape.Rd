%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: aggregateLexisShape.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{aggregateLexisShape}
\alias{aggregateLexisShape}
\title{
  Aggregate data held as Lexis triangles into other Lexis shapes
}
\description{
  This function aggregates births or exposure data held in Lexis triangles in a data frame into
  a 3D-array containing the data in Lexis rectangles or horizontal or vertical parallelograms
}
\usage{
aggregateLexisShape(TRdata, shape, \dots)
}
\arguments{
  \item{TRdata}{
  Births or exposure data (or, conceptually, any data which can be aggregated by summation)
  in Lexis triangles. See details.
}
  \item{shape}{
  the Lexis shape into which the data should be aggregated; one of RR, VH or VV
}
  \item{\dots}{
  Named arguments which will potentially be passed to \code{\link{read.table}}. See details.
}
}
\details{
If supplied as a \code{\link{data.frame}}, for \code{TRdata}, the columns
Year, Cohort, Age and any number of data columns are expected,
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
\value{
  A 3D-array with named dimensions containing the aggregated data by year|cohort, age|cohort and order, or NULL
  if no data supplied.
}
\references{
  Jasilioniene et al.: Methods Protocol for the Human Fertility Database.
  Available from \url{http://www.humanfertility.org} 
}
\author{
  Edward Nash \email{edward.nash@gmx.de}
}
\note{
Even if no order-specific data is present, the resulting array will still be 3D,
with a length 1 3rd dimension.

In some cases, the \code{TRdata} should be preprocessed using \code{\link{preprocessLexisTriangles}}
to ensure correct aggregation of edge cases.
}
\seealso{
\code{\link{reshapeLexisShapeData}} for converting the resulting array back into a data frame,
\code{\link{lexisShapePrimaryFactor}} and \code{\link{lexisShapeSecondaryFactor}} for identifying
the first and second dimensions of the resulting array and \code{\link{preprocessLexisTriangles}} for
doing some basic preparation of the triangle data before aggregating.
}
\examples{
data(someExpos.TR)
aggregateLexisShape(someExpos.TR, "RR")
\dontrun{
  # assuming comma-separated file with column headings and no other header rows
  aggregateLexisShape("mybirths.txt", "VV", skip = 0, header = TRUE, sep = ",", na.strings = "")
}
}\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
