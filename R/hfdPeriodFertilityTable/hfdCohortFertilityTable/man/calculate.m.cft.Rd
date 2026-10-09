\name{calculate.m.cft}
\alias{calculate.m.cft}
\title{
  Calculate conditional age- and parity- specific fertility rates for cohort fertility tables
}
\description{
  Calculate age- and parity- specific (conditional) fertility rates from
  births by age and order, populations by age and parity and average
  share of the interval [x, x + 1) lived before giving birth to a child.
}
\usage{
calculate.m.cft(b, l, a = 0.5)
}
\arguments{
  \item{b}{
  A 3D \code{array} of births by order with named dimensions cohort, age and order
}
  \item{l}{
  A 3D \code{array} of population by parity with named dimensions cohort, age and parity 
}
  \item{a}{
    The average share of the age interval [x, x+1) lived before giving birth to a
    child, either as a constant, by cohort or by cohort and age.
}
}
\details{
\code{a} may be supplied as: \describe{
\item{numeric}{a single \code{numeric} value for all cohorts and ages}
\item{vector}{a \code{vector} of numeric values, one per cohort which is included in the CFT produced. Note
  that this is not necessarily the same as the number of cohorts in \code{asfr} due to the
  filtering effects of \code{observeTo} and \code{observeFrom}. If the required length is
  not clear, the function may be called once with constant \code{a} in order to find this out.}
\item{array}{a 2D \code{array} of numeric values, one row per cohort and one column per age. Note that
  the same restrictions as for a \code{vector} argument apply.}
}
It is assumed that \code{b} and \code{l} have matching dimensions.
}
\value{
  A 3D \code{array} of conditional fertility rates by cohort, age and order
  of the same dimensions as \code{b}
}
\references{
  Jasilioniene et al.: Methods Protocol for the Human Fertility Database.
  Available from \url{http://www.humanfertility.org} 
}
\author{
  Edward Nash \email{edward.nash@gmx.de}
}
\seealso{
  \code{\link{calculate.b.cft}} for producing \code{b},
  \code{\link{calculate.l.cft}} for producing \code{l},
  \code{\link{calculate.cft}} for producing complete cohort fertility tables
}
\examples{
  data(someAsfr)
  b <- calculate.b.cft(someAsfr)
  l <- calculate.l.cft(b)
  corrections <- l$corrections
  l <- l$parities
  b[corrections] <- l[corrections]
  m <- calculate.m.cft(b, l)
  m[corrections] <- NA
}\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
