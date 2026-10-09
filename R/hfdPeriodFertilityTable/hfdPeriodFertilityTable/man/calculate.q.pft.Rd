\name{calculate.q.pft}
\alias{calculate.q.pft}
\title{
  Calculate age- and order- specific period birth probabilities 
}
\description{
  This function calculates the age- and order- specific period birth probabilities
  based on the conditional age- and order- specific fertility rates.  
}
\usage{
calculate.q.pft(m, a = 0.5, filterPlausible = FALSE, \dots)
}
\arguments{
  \item{m}{
  Conditional age- and order-specific fertility rates as a data frame, 3D array or path to file. See details.
}
  \item{a}{
  the average share of the age interval [x,x+1] lived before giving birth to a child. See details.
}
  \item{filterPlausible}{
  a Boolean value indicating whether implausible values (greater than 1.0) should be replaced
  with \code{NA}s
}
  \item{\dots}{
  arguments which will be passed through to \code{\link{read.table}} for inputs which are to be read
  from file. See details.
}
}
\details{
  a 3D \code{\link{array}} of conditional age- and order-specific fertility rates with
  named dimensions Year, Age and Order.

  \code{a} may be supplied as anything that is compatible for operations with \code{m}, e.g. a
  single value, a vector (by year), 2D array (by year and age), 3D array (by year, age and order). Note
  that if supplying as a vector or array, the number of years must match those of the resulting
  period fertility table, which is not guaranteed to be the same as the years in \code{w}.
}
\section{Warning}{
 It is up to the user to ensure that \code{a} has sensible dimensions, although a warning
 or error \strong{may} be raised if it does not (or calculations may continue with garbage results).
}
\value{
  A 3D array of order-specific birth probabilities with named dimensions Year, Age and Order. If
  \code{filterPlausible} is \code{TRUE}, any values greater than 1.0 will be replaced with \code{NA}.
  Other non-finite values (e.g. \code{Inf}) may in any case be present.
}
\references{
  Jasilioniene et al.: Methods Protocol for the Human Fertility Database.
  Available from \url{http://www.humanfertility.org} 
}
\author{
Edward Nash \email{edward.nash@gmx.de}
}
\seealso{
  \code{\link{calculate.E.m.q.corrections.pft}} for identifying cells requiring corrections and
  \code{\link[hfdCohortFertilityTable:calculate.q.cft]{calculate.q.cft}} for the comparable cohort
  fertility table function.
}
\examples{
data(someBirths.RR, someExpos.RR, someWeightings)
E <- calculate.E.pft(someWeightings, someExpos.RR)
m <- calculate.m.pft(someBirths.RR, E, FALSE)
calculate.q.pft(m)
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
