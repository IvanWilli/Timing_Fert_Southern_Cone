%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: calculate.cft.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{calculate.cft}
\alias{calculate.cft}
\title{
  Produce Cohort Fertility Tables using the HFD methodology
}
\description{
  This function produces cohort fertility tables (CFT) according to the methods
  described in the Methods Protocol for the Human Fertility Database.
  Featured indicators are births by age and order (b), population by age and
  parity (l), conditional fertility rates by age and birth order (m), conditional
  probabilities by age and birth order (q), cumulative births by age and order (Sb)
  and average number of children born to women in the highest parity
  category by age (chi).
}
\usage{
calculate.cft(asfr, observeTo = 25, observeFrom = 15, radix = 10000, a = 0.5, returnType = "data.frame", applyCorrections = TRUE, \dots)
}
\arguments{
  \item{asfr}{
    The Age Specific Fertility Rates by birth order on which to base the CFT
}
  \item{observeTo}{
    The minimum age to which cohorts must be observed to be included in the CFT.
}
  \item{observeFrom}{
    The maximum starting age for observation of cohorts for them to be included
    in the CFT.
}
  \item{radix}{
    The size of the table population.
}
  \item{a}{
    The average share of the age interval [x, x+1) lived before giving birth to a
    child, either as a constant, by cohort or by cohort and age.
}
  \item{returnType}{
    The format in which the cohort fertility table is to be returned.
}
  \item{applyCorrections}{
    Whether the birth and parity data should be corrected to avoid implausible
    populations (<0) and probabilities (>1)
}
  \item{\dots}{
    Arguments passed to read.table in the case that ASFR is supplied as a file path
    or connection.
}
}
\details{
\code{asfr} may be supplied as one of: \describe{
\item{data.frame}{a \code{\link{data.frame}} containing the age specific fertility rate dataset
  as horizontal parallelograms. The columns Cohort, Age, ASFR, ASFR1, \ldots{}, ASFRxp
  are assumed, with the first three of these tested for.}
\item{character or connection}{a \code{\link{character}} vector pointing to the path from which
  the ASFR values may be read, or a \code{\link{connection}} object. \code{\link{read.table}}
  will be called on this, with the default options being \code{header = T, skip = 2, na.strings = "."}: these
  may be overridden using further arguments (see \code{\dots})}
\item{array}{a 3D \code{\link{array}} of ASFR with the dimensions named according to the Cohort,
  Age and Order respectively. In this case, it is expected that there is no total ASFR
  included in the array.}
  }
\code{observeFrom} and \code{observeTo} may be supplied as a \code{numeric}, or a \code{logical}
with \code{FALSE} indicating no filtering and \code{TRUE} indicating that the default value
should be used. \cr
\code{a} may be supplied as: \describe{
\item{numeric}{a single \code{numeric} value for all cohorts and ages}
\item{vector}{a \code{vector} of numeric values, one per cohort which is included in the CFT produced. Note
  that this is not necessarily the same as the number of cohorts in \code{asfr} due to the
  filtering effects of \code{observeTo} and \code{observeFrom}. If the required length is
  not clear, the function may be called once with constant \code{a} in order to find this out.}
\item{array}{a 2D \code{array} of numeric values, one row per cohort and one column per age. Note that
  the same restrictions as for a \code{vector} argument apply.}
}
\code{returnType} may be one of \describe{
\item{"data.frame"}{(default) returns a \code{data.frame} with the columns ordered by order/parity
  and then indicator}
\item{"array"}{returns a 3D \code{array} with the dimensions Cohort, Age and Indicator, where Indicator
  is ordered by indicator and then parity}
\item{"list"}{returns a \code{list} of \code{arrays}, containing the indicators arranged by
  Cohort, Age and (for all except chi) Order. List entries are: \describe{
  \item{b}{Births by cohort, age and birth order}
  \item{l}{Population by cohort, age and parity}
  \item{m}{Conditional fertility rates by cohort, age and birth order}
  \item{q}{Conditional probability of giving birth by cohort, age and birth order}
  \item{Sb}{Cumulative births by cohort, age and birth order}
  \item{chi}{Average number of children born to women in the highest parity category by cohort and age}
  }}
}
\code{\dots} are named arguments passed to \code{\link{read.table}} to either override the default arguments
(which are designed to enable the HFD files of ASFR by cohort, age and birth order to be read) or to
supply further arguments for reading otherwise formatted data.
}
\value{
  The cohort fertility table in the format determined by \code{returnType}.
}
\note{
  If there is a break in the series of ASFR for some cohorts, then if
  this break falls within the range (\code{observeFrom}, \code{observeTo}] the
  cohort will be excluded from the calculated births matrix. If the break falls outside
  this range, the data series for that cohort will be truncated at the break.
  
  This means that there is no guarantee that the series of cohorts included in the output
  is continuous.
}
\references{
  Jasilioniene et al.: Methods Protocol for the Human Fertility Database.
  Available from \url{http://www.humanfertility.org} 
}
\author{
  Edward Nash \email{edward.nash@gmx.de}
}
\seealso{
  \code{\link{calculate.b.cft}}, \code{\link{calculate.l.cft}},
  \code{\link{calculate.m.cft}}, \code{\link{calculate.q.cft}},
  \code{\link{calculate.Sb}}, \code{\link{calculate.chi.cft}} for the
  calculation of individual indicators 
}
\examples{
  data(someAsfr)
  cft <- calculate.cft(someAsfr)
\dontrun{
  cohortChildlessness <- data.frame(Cohort = unique(cft$Cohort), Childlessness = cft[cft$x == "55+", "l0x"] / 100)
  cohortChildlessness <- cohortChildlessness[!is.na(cohortChildlessness$Childlessness), ]
  cohortChildlessness$Cohort <- as.numeric(levels(cohortChildlessness$Cohort))[cohortChildlessness$Cohort]
  plot(cohortChildlessness, type = "l", main = "Cohort childlessness (\%) at age 55", ylab = "Childlessness (\%)")
}
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
