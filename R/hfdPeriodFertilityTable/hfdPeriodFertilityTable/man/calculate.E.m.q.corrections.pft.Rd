\name{calculate.E.m.q.corrections.pft}
\alias{calculate.E.m.q.corrections.pft}
\title{
  Identify cells in period fertility table E, m and q which require
  correction 
}
\description{
This function identifies cells requiring correction according to the Human Fertility
Database Methods Protocol Section 8.2:
\dQuote{To eliminate huge fluctuations in mi(x) at lowest- and highest-childbearing
ages, attributable to very low observed numbers of births, these rates are
computed in the HFD only for age and parity combinations where
Ei-1(x)>5, mi(x)<1 and qi(x)<1, otherwise, the values of Ei-1(x) are replaced
by zero and the values of qi(x) and mi(x) are presented by dots (implausible
values in the fertility tables.}
}
\usage{
calculate.E.m.q.corrections.pft(E, m, qix)
}
\arguments{
  \item{E}{
  a 3D array of parity-specific female population exposure with named dimensions Year, Age and Parity
}
  \item{m}{
  a 3D \code{\link{array}} of conditional age- and order-specific fertility rates with
  named dimensions Year, Age and Order.
}
  \item{qix}{
  a 3D \code{\link{array}} of age- and order-specific birth probabilities with named
  dimensions Year, Age and Order.
}
}
\details{
  It is assumed that \code{E}, \code{m} and \code{qix} have identical dimensions. Behaviour
  if they do not is undefined
}
\value{
  A 3D array of logical values indicating cells requiring correction with named dimensions
  Year, Age, Order/Parity
}
\references{
  Jasilioniene et al.: Methods Protocol for the Human Fertility Database.
  Available from \url{http://www.humanfertility.org} 
}
\author{
Edward Nash \email{edward.nash@gmx.de}
}
\seealso{
  \code{\link{calculate.E.pft}}, \code{\link{calculate.m.pft}} and
  \code{\link{calculate.q.pft}} for the functions to calculate \code{E}, \code{m}
  and \code{qix} respectively.
}
\examples{
data(someBirths.RR, someExpos.RR, someWeightings)
E <- calculate.E.pft(someWeightings, someExpos.RR)
m <- calculate.m.pft(someBirths.RR, E, FALSE)
qix <- calculate.q.pft(m)
calculate.E.m.q.corrections.pft(E, m, qix)
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
