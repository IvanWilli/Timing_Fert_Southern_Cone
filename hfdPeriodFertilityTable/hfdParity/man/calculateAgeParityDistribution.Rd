%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: calculateAgeParityDistribution.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{calculateAgeParityDistribution}
\alias{calculateAgeParityDistribution}
\alias{calculateAgeParityDistribution.census}
\alias{calculateAgeParityDistribution.cumulative}
\alias{calculateAgeParityDistribution.golden}
\alias{calculateAgeParityDistribution.register}
\title{
  Calculate mid-year estimates of the age- and parity-specific distribution of women wi(x,t) 
}
\description{
  These four functions calculate the mid-year estimates of the age- and parity-specific distribution
  of women, wi(x,t), used to determine the age- and parity-specific female population exposures Ei(x,t)
  needed for production of period fertility tables. The estimated distribution may come from
  cumulating fertility histories, use of a \dQuote{golden census} to estimate unobserved fertility
  histories, or directly from census or register data. In the latter two cases, age-parity
  distributions are calculated only for the years for which census or register data is available, in
  the former two from 30 years after the first observation or from the \dQuote{golden census} year
  until the end of the available observations.
}
\usage{
calculateAgeParityDistribution.census(bTR, eTR, wiyT, \dots)
calculateAgeParityDistribution.cumulative(bTR, eTR, observeFrom = 15, observeTo = 45, \dots)
calculateAgeParityDistribution.golden(bTR, eTR, wiyT, goldenYear, observeFrom = 15, observeTo = 45, switchToCumulative = TRUE, \dots)
calculateAgeParityDistribution.register(bTR, eTR, wiyT, \dots)
}
\arguments{
  \item{bTR}{
  A data frame of observed births by order arranged by Lexis triangles
}
  \item{eTR}{
  A data frame of estimated female population exposure arranged by Lexis triangles
}
  \item{wiyT}{
  A 3D \code{\link{array}} of female population distribution by parity on 1st January with named dimensions Year, Age and Parity or
  a \code{\link{data.frame}} with columns as produced by \code{\link{parity.1Jan.weights}}.
}
  \item{goldenYear}{
  The census year to use as the \dQuote{golden census}: this year must be present in \code{wiyT}
}
  \item{observeFrom}{
  The maximum age from which cohorts must have been observed to be used in calculating cumulative
  parity distributions.
}
  \item{observeTo}{
  The minumum age to which cohorts must have been observed to be used in calculating cumulative
  parity distributions.
}
  \item{switchToCumulative}{
  Whether the parity distribution calculation method should switch to cumulative once
  cohorts have been observed for a sufficiently long period (\code{TRUE}), or the entire
  distribution should be calculated based on cumulating forward from the golden census (\code{FALSE}).
}
  \item{\dots}{
  Included for compatibility between functions and for future extensions:
  currently ignored in all cases.
}
}
\details{
  \code{bTR} and \code{eTR} should both cover the same range of years and ages. \code{wiyT} is assumed
  to cover the range of ages starting at xmin - 1 (e.g. age 11 for births/exposure data from age 12) up to xmax.
  For the data frames, the columns initial columns Year, Age, Cohort are assumed followed by
  Total, B1, B2, ..., Bnp for \code{bTR} and Exposure for \code{eTR}.  
}
\value{
  a 3D array of estimated female population distribution by age and parity with the named dimensions
  Year, Age and Parity. The Age and Parity ranges included are dependent upon that of the input data.
  The Year range is dependent on the method: \itemize{
  \item for \code{cumulative}, from the year the first cohort observed from \code{observeFrom} reaches
  \code{observeTo} until the end of the observations in \code{bTR}.
  \item for \code{golden}, from the \code{goldenYear} until the end of the observations in \code{bTR}.
  \item for \code{census} and \code{register}, for the years included in the input \code{wiyT}.
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
  \code{\link{parity.census.weights}} for production of age-parity distributions
  in census years and \code{\link[hfdPeriodFertilityTable:calculate.E.pft]{calculate.E.pft}}
  for an example of how the output from these functions may be used.
}
\examples{
  data(someBirths.TR, someExpos.TR, czeCensus, sweRegisterPath)

  calculateAgeParityDistribution.cumulative(someBirths.TR, someExpos.TR)

  swe.weights <- parity.1Jan.weights(parity.census.weights(sweRegisterPath))
  w.swe <- parity.prepare.matrix(swe.weights)

  calculateAgeParityDistribution.register(someBirths.TR, someExpos.TR, w.swe) # only for register years

  birthsVV <- produceLexisShapes(someBirths.TR, "VV", "births")
  exposVV <- produceLexisShapes(someExpos.TR, "VV", "expos")
  asfrVV <- calculate.asfr(birthsVV, exposVV, "VV")
  cze.weights <- parity.1Jan.weights(parity.census.weights(czeCensus, parityUnkMethod = "allToZero"), asfrVV)
  w.cze <- parity.prepare.matrix(cze.weights)

  calculateAgeParityDistribution.census(someBirths.TR, someExpos.TR, w.cze) # only for census year 1991

  calculateAgeParityDistribution.golden(someBirths.TR, someExpos.TR, w.cze, 1991) # for 1991 onwards
}\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
