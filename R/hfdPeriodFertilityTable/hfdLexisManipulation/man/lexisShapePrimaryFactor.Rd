%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: lexisShapePrimaryFactor.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{lexisShapePrimaryFactor}
\alias{lexisShapePrimaryFactor}
\alias{lexisShapeSecondaryFactor}
\title{
  Determining factors used for identifying Lexis shapes.
}
\description{
  These two functions are used to retrieve the factors used for identifying Lexis shapes, i.e. the
  first and second dimensions used when representing the shape data as an array.
}
\usage{
lexisShapePrimaryFactor(shape)
lexisShapeSecondaryFactor(shape)
}
\arguments{
  \item{shape}{
  A string representing the shape for which to return the factor; RR, VH or VV
}
}
\value{
As indicated in the table below, or \code{NULL} is shape is invalid
\tabular{rccl}{
\emph{shape} \tab \emph{primary} \tab \emph{secondary} \tab \emph{note}\cr
RR \tab Year \tab Age \tab Lexis rectangle/square\cr
VH \tab Cohort \tab Age \tab Lexis horizontal parallelogram\cr
VV \tab Year \tab Cohort \tab Lexis vertical parallelogram\cr
}
}
\references{
  Jasilioniene et al.: Methods Protocol for the Human Fertility Database.
  Available from \url{http://www.humanfertility.org} 
}
\author{
  Edward Nash \email{edward.nash@gmx.de}
}
\seealso{
  \code{\link{aggregateLexisShape}} for an example usage of these two functions
}
\examples{
  lexisShapePrimaryFactor("RR") # Year
  lexisShapeSecondaryFactor("VV") # Cohort
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
