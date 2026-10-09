%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: reshapeLexisShapeData.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{reshapeLexisShapeData}
\alias{reshapeLexisShapeData}
\alias{totalColPositionForShape}
\title{
  Convert a 3D array of aggregated Lexis shape data to a data frame
}
\description{
  These functions convert a 3D array of aggregated 1x1 Lexis shape data (rectangles/squares,
  horizontal or vertical parallelograms) into a long format data frame. The helper function
  totalColPositionForShape can be used to identify which column the total (i.e. not by
  birth order) data is held in as not all shapes have the same number of factors.
}
\usage{
reshapeLexisShapeData(shapeData, shape, dataType, minAge = NULL, maxAge = NULL)
totalColPositionForShape(shape)
}
\arguments{
  \item{shapeData}{
  a 3D array with named dimensions containing the aggregated Lexis shape data
}
  \item{shape}{
  the Lexis shape in which the data is held; one of TR (totalColPositionForShape only), RR, VH or VV
}
  \item{dataType}{
  the type of the data; e.g. births, expos, asfr, etc.
}
  \item{minAge}{
  for VV data, the minumum age (ARDY) to include in the resulting data frame. Ignored if shape != VV
}
  \item{maxAge}{
  for VV data, the maximum age (ARDY) to include in the resulting data frame. Ignored if shape != VV
}
}
\details{
  The \code{shapeData} is expected to be a 3D array with named dimensions corresponding to the
  primary and secondary factors for the shape (as given by \code{\link{lexisShapePrimaryFactor}} and
  \code{\link{lexisShapeSecondaryFactor}} and the order: total (all-orders) is treated as an order,
  and so for data without order-specific data, the 3rd dimension will have length 1. Column names
  in the output are determined by the names in the 3rd dimension of \code{shapeData}
}
\value{
  For \code{reshapeLexisShapeData}, a data frame containing a long-format representation of the
  \code{shapeData}: columns are the factors (plus ARDY for VV data) followed by the total (all-order)
  data and then order-specific data. Column naming is dependent on the \code{dataType}. NULL is returned
  if the input data is NULL.
  
  For \code{totalColPositionForShape}, an integer indicating the position of the total data column:
  3 for RR and VH and 4 for TR and VV.
}
\author{
  Edward Nash \email{edward.nash@gmx.de}
}
\seealso{
  \code{\link{aggregateLexisShape}} for aggregation of data frames of Lexis triangle data to 3D arrays
of Lexis shapes.
}
\examples{
  totalColPositionForShape("TR") # == 4
  totalColPositionForShape("RR") # == 3
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
