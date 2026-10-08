%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: internal.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{internal}
\alias{.calculateCensusAgeParityWeights}
\alias{.calculateCensusPlusOneParityDistributions}
\alias{.calculateCohortBirthsMatrix}
\alias{.calculateCumulativeAgeParityDistribution}
\alias{.calculateGoldenCensusBasedParityDistributions}
\title{Internal functions used in calculating age/parity distributions}
\description{
  These functions are used internally in the calculation of age/parity
  distributions and are not intended to be called directly. They implement
  much of the internal workings of the methods documented in
  \code{\link{calculateAgeParityDistribution}}.
  
  \code{.calculateCensusAgeParityWeights} calculates the relative distribution of
  females by parity in a census year based on the distribution on 1st January of
  the census year and the distribution on 1st January of the following year.
  
  \code{.calculateCensusPlusOneParityDistributions} uses data on fertility rates, calculated
  from the supplied births and exposure data by Lexis triangles, to estimate the relative
  female parity distribution on 1st January of the years following census years (data in wiyT)
  using the methods described in the Methods Protocol of the Human Fertility Database.

  \code{.calculateCohortBirthsMatrix} calculates a matrix of cohort births per 10000 table
  population to use as input for calculation of population parity distribution.
  
  \code{.calculateCumulativeAgeParityDistribution} calculates the estimated mid-year age- and
  parity-specific relative distribution (w) of the female population based on the population
  by parity data from a cohort fertility table.
  
  \code{.calculateGoldenCensusBasedParityDistributions} calculates the estimated mid-year age-
  and parity-specific relative distribution (w) of the female population based on cumulating
  cohort parity histories forward from a \dQuote{Golden Census} which is used to produce
  left-censored cohort fertility tables for cohorts which would otherwise not be observed
  for a sufficient time period and thus to extend the period for which period fertility tables
  may be produced. 
 }
\usage{
.calculateCensusAgeParityWeights(wiyT, wiyT1)
.calculateCensusPlusOneParityDistributions(bTR, eTR, wiyT)
.calculateCohortBirthsMatrix(bTR, eTR, bottomFilter = 15, topFilter = 45)
.calculateCumulativeAgeParityDistribution(l, years = NULL, observeFrom = 15, observeTo = 45)
.calculateGoldenCensusBasedParityDistributions(censusWeights, b, goldenYear, years)
}
\arguments{
  \item{wiyT}{
  a 3D array with named dimensions of the relative female parity distribution on 1st January of the
  census year(s)
}
  \item{wiyT1}{
  a 3D array with named dimensions of the actual or estimated relative female parity distribution on
  1st January of the year following each census year
}
  \item{bTR}{
  A data frame of observed births by order arranged by Lexis triangles
}
  \item{eTR}{
  A data frame of estimated female population exposure arranged by Lexis triangles
}
  \item{bottomFilter}{
  Whether to bottom-filter for cohorts an with insufficient observation
  period for a cohort fertility table, or the age from which cohorts must be observed.
}
  \item{topFilter}{
  Whether to bottom-filter for cohorts an with insufficient observation
  period for a cohort fertility table, or the age up to which cohorts must be observed.
}
  \item{l}{
  Cohort table population by parity as a 3D array with named dimensions
  Cohort, Age and Parity 
}
  \item{years}{
  The range of years for which the distribution should be calculated
}
  \item{observeFrom}{
    The maximum starting age for observation of cohorts for them to be included
    in the cumulative distribution.
}
  \item{observeTo}{
    The minimum age to which cohorts must be observed to be included in the
    calculated distribution.
}
  \item{censusWeights}{
  Mid-year age-parity distribution estimates for the golden census year as a 2D array
  with named dimensions Age and Parity or a 3D-array with named dimensions Year, Age
  and Parity where Year must contain \code{goldenYear}.  
}
  \item{b}{
  A 3D-array of cohort table births with named dimensions Cohort, Age and Order 
}
  \item{goldenYear}{
  The year of the \dQuote{Golden Census}
}
}
\details{
  Both \code{wiyT} and \code{wiyT1} are assumed to contain the same
  range of ages and parities, with the Year range of \code{wiyT1} being that
  of \code{wiyT} shifted by +1. If this is not the case then the behaviour is
  undefined. Axis order is year, age (ACY), parity

  \code{bTR} and \code{eTR} should both cover the same range of years and ages. \code{wiyT} is assumed
  to cover the same range of ages up to xmax + 1 (e.g. age 56 for births/exposure data up to age 55).
  For the data frames, the columns initial columns Year, Age, Cohort are assumed followed by
  Total, B1, B2, ..., Bnp for \code{bTR} and Exposure for \code{eTR}. The order of the dimensions
  for \code{wiyT} should be Year, Age, Parity, with the parity range corresponding to the order range
  in \code{bTR}.

  See \code{\link{calculate.b.cft}} argument \code{observeFrom} for the semantics of \code{bottomFilter}: the
  \code{observeTo} from that function is set to \code{FALSE}

  \code{years} may be \code{NULL}: in this case, the distribution will be calculated
  from the year in which the first cohort observed from age \code{observeFrom} reaches
  \code{observeTo} until the last year of the observations.

  It is assumed that the age ranges in \code{censusWeights} and \code{b} match.
  Behaviour otherwise is undefined.
}
\value{\enumerate{
\item{\code{.calculateCensusAgeParityWeights}}{
  A 3D array of mid-year age-parity distribution estimates for each
  year and parity included in \code{wiyT} with named dimensions. The age range will
  be shortened by one at the lower end, i.e. if the lowest age in wiyT is 11
  then the lowest age in the output will be 12.
}
\item{\code{.calculateCensusPlusOneParityDistributions}}{
  a 3D array with the same dimensions as \code{wiyT} containing the estimated relative female parity
  distributions on 1st January the year after each census year. The (named dimension) years will therefore
  be those of \code{wiyT} shifted by +1.
}
\item{\code{.calculateCohortBirthsMatrix}}{
  A 3D array of cohort table births with named dimensions Cohort, Age, Order
}
\item{\code{.calculateCumulativeAgeParityDistribution}}{
  A 3D array of estimated mid-year age- and parity specific relative population
  distribution (w) indexed by year, age and parity: this may be empty if an insufficient
  time series of observations was supplied to fulfil the specified \code{years},
  \code{observeFrom} and \code{observeTo} criteria. In this case the first array
  dimension (years) will be of length 0.
}
\item{\code{.calculateGoldenCensusBasedParityDistributions}}{
  A 3D array of parity distributions with named dimensions Year, Age and Parity. The year
  range corresponds to \code{years}, age to that in \code{censusWeights} and \code{b} and the
  parity range to that in \code{b}. 
}
}
}
\references{
  Jasilioniene et al.: Methods Protocol for the Human Fertility Database.
  Available from \url{http://www.humanfertility.org} 
}
\author{
Edward Nash \email{edward.nash@gmx.de}
}
\examples{
  data(someBirths.TR, someExpos.TR, sweRegisterPath)
  b <- hfdParity:::.calculateCohortBirthsMatrix(someBirths.TR, someExpos.TR, FALSE, FALSE)
  l <- calculate.l.cft(b)$parities
  
  w.cumulative <- hfdParity:::.calculateCumulativeAgeParityDistribution(l)
  
  wiyT <- parity.1Jan.weights(parity.census.weights(sweRegisterPath))
  wiyT <- subset(wiyT, Year == 1985)
  wiyT <- parity.prepare.matrix(wiyT)
  wiyT1 <- hfdParity:::.calculateCensusPlusOneParityDistributions(someBirths.TR, someExpos.TR, wiyT)
  wi <- hfdParity:::.calculateCensusAgeParityWeights(wiyT, wiyT1)
  
  w.golden <- hfdParity:::.calculateGoldenCensusBasedParityDistributions(wi, b, 1985, 1985:1995)
}\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
