\name{calculate.q.cft}
\alias{calculate.q.cft}
\title{
  Calculate age- and parity- specific fertility rates
}
\description{
  Calculate probability of giving birth by birth order by cohort and age.
}
\usage{
calculate.q.cft(b, l)
}
\arguments{
  \item{b}{
  A 3D \code{array} of births by order with named dimensions cohort, age and order
}
  \item{l}{
  A 3D \code{array} of population by parity with named dimensions cohort, age and parity 
}
}
\details{
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
  q <- calculate.q.cft(b, l)
  q[corrections] <- NA
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
