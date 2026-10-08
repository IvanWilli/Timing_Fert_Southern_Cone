\name{hfdLexisManipulation-package}
\alias{hfdLexisManipulation-package}
\alias{hfdLexisManipulation}
\docType{package}
\title{
  Basic manipulation of data in Lexis shapes
}
\description{
This package contains functions for the handling and manipulation of data in Lexis shapes for the
Human Fertility Database. Examples are the aggregation of Lexis triangles to rectangles and
parallelograms and the conversion between array-based and data frame-based representation of the
data.
}
\details{
\tabular{ll}{
Package: \tab hfdLexisManipulation\cr
Type: \tab Package\cr
Version: \tab 2.0-1077\cr
Date: \tab 2015-04-26\cr
License: \tab GPL (>= 2.0)\cr
LazyLoad: \tab yes\cr
}
}
\author{
Edward Nash \email{edward.nash@gmx.de}

Maintainer: Edward Nash \email{edward.nash@gmx.de}
}
\references{
  Jasilioniene et al.: Methods Protocol for the Human Fertility Database.
  Available from \url{http://www.humanfertility.org} 
}
\keyword{ package }
\examples{
  data(someBirths.TR)
  produceLexisShapes(someBirths.TR, "RR", "births")
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
