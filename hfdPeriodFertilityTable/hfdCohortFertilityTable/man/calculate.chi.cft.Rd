\name{calculate.chi.cft}
\alias{calculate.chi.cft}
\title{
  Calculate the average number of children born to women in the highest parity category 
}
\description{
  This function calculates the average number of children born to women in the highest
  parity category included in a cohort fertility table, based on the number of births at
  the highest order and the population of the highest parity.
}
\usage{
calculate.chi.cft(l, b)
}
\arguments{
  \item{l}{
    A 3D \code{array} of table populations with named dimensions cohort, age and parity
}
  \item{b}{
    A 3D \code{array} of table births by order with named dimensions cohort, age and order
}
}
\details{
  Note that it is assumed that the dimensions of l and b match.
}
\value{
  A 2D array of average number of children born to women in the highest parity
  category by cohort and age.
}
\references{
  Jasilioniene et al.: Methods Protocol for the Human Fertility Database.
  Available from \url{http://www.humanfertility.org} 
}
\author{
  Edward Nash \email{edward.nash@gmx.de}
}
\seealso{
  \code{\link{calculate.cft}} for the calculation of the entire CFT,
  \code{\link{calculate.b.cft}} for the calculation of b and
  \code{\link{calculate.l.cft}} for the calculation of l
}
\examples{
  data(someAsfr)
  b <- calculate.b.cft(someAsfr)
  l <- calculate.l.cft(b)
  corrections <- l$corrections
  l <- l$parities
  b[corrections] <- l[corrections]
  chi <- calculate.chi.cft(l, b)
}\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
