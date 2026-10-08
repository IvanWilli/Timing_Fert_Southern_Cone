%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: onlyObservationsFromAgeOrLess.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{onlyObservationsFromAgeOrLess}
\alias{onlyObservationsFromAgeOrLess}
\title{
  Trim a cohort dataset to only those cohorts observed from a certain minimum age
}
\description{
  This function truncates a supplied dataset to only include cohorts which have been observed
  from a certain minimum age, i.e. only those cohorts for which a sufficiently long history
  is available.
}
\usage{
onlyObservationsFromAgeOrLess(age, cohortDataset, dataColumn)
}
\arguments{
  \item{age}{
  The minimum age (in completed years) from which cohorts must have been observed
}
  \item{cohortDataset}{
  A data frame containing a Cohort column
}
  \item{dataColumn}{
  The data column to inspect in order to determine whether a cohort was observed (e.g. ASFR)
}
}
\details{
  Both VH and VV data should be handled correctly: the age column may be called either
  Age or ARDY, and it assumed that \code{age} is given appropriately.
}
\value{
  A data frame with the same columns as \code{cohortDataset}, but potentially truncated to
  remove cohorts not observed from the required age
}
\author{
  Edward Nash \email{edward.nash@gmx.de}
}
\examples{
  data(someBirths.TR)
  birthsVH <- produceLexisShapes(someBirths.TR, "VH", "births")
  onlyObservationsFromAgeOrLess(15, birthsVH, "Total")
}\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
