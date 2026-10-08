\name{calculate.b.l.L.pft}
\alias{calculate.b.l.L.pft}
\title{
  Calculate period fertility table births and parity-specific populations and exposures
}
\description{
  This function calculates the period-, age and parity-specific table populations and
  exposures as well as order-specific births based on the conditional age- and order-
  specific birth rates and probabilities.
}
\usage{
calculate.b.l.L.pft(m, qix, a = 0.5)
}
\arguments{
  \item{m}{
  a 3D \code{\link{array}} of conditional age- and order-specific fertility rates with
  named dimensions Year, Age and Order.
}
  \item{qix}{
  a 3D \code{\link{array}} of age- and order-specific birth probabilities with named
  dimensions Year, Age and Order.
}
  \item{a}{
  the average share of the age interval [x,x+1] lived before giving birth to a child. See details.
}
}
\details{
  \code{a} may be supplied as anything that is compatible for operations with \code{m}, e.g. a
  single value, a vector (by year), 2D array (by year and age), 3D array (by year, age and order).
  In each case, the dimensions should match the corresponding dimensions of \code{m} and \code{q}.
}
\note{
  It is assumed that \code{m} and \code{qix} have the same dimensions.
}
\section{Warning}{
 It is up to the user to ensure that \code{a} has sensible dimensions, although a warning
 or error \strong{may} be raised if it does not (or calculations may continue with garbage results).
}
\value{
A list containing the entries:
  \item{b}{A 3D \code{\link{array}} of table births with named dimensions Year, Age and Order}
  \item{l}{A 3D \code{\link{array}} of table populations by parity with named dimensions Year, Age and Parity}
  \item{L}{A 3D \code{\link{array}} of table population exposure by parity with named dimensions Year, Age and Parity}
The dimensions of all of these will match the dimensions of the inputs \code{m} and \code{q}.
}
\references{
  Jasilioniene et al.: Methods Protocol for the Human Fertility Database.
  Available from \url{http://www.humanfertility.org} 
}
\author{
Edward Nash \email{edward.nash@gmx.de}
}
\seealso{
  \code{\link{calculate.m.pft}} and \code{\link{calculate.q.pft}} for calculation of the inputs,
  \code{\link{calculate.pft}} for calculation of the entire period fertility table and
  \code{\link[hfdCohortFertilityTable:calculate.b.cft]{calculate.b.cft}} and
  \code{\link[hfdCohortFertilityTable:calculate.l.cft]{calculate.l.cft}} for the cohort
  fertility table equivalents. 
}
\examples{
data(someBirths.RR, someExpos.RR, someWeightings)
E <- calculate.E.pft(someWeightings, someExpos.RR)
m <- calculate.m.pft(someBirths.RR, E, FALSE)
qix <- calculate.q.pft(m)
b.l.L <- calculate.b.l.L.pft(m, qix)
l <- b.l.L$l
years <- as.numeric(dimnames(l)[[1]])
ages <- as.numeric(gsub("([[:digit:]]+)[+-]", "\\\\1", dimnames(l)[[2]]))
persp(years, ages, l[, , 1] / 100, main = "Childlessness by age and year", theta = 225, zlab = "Childlessness (\%)", ticktype = "detailed", zlim = c(0, 100), ltheta = 270, lphi = 135)
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
