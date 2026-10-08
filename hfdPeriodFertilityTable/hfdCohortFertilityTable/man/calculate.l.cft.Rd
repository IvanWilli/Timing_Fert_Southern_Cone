%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: calculate.l.cft.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{calculate.l.cft}
\alias{calculate.l.cft}
\title{
  Calculate the parity-specific table populations from a 3D array of births
}
\description{
  This function calculates the cohort-, age- and parity-specific table populations
  given an array of births by cohort, age and order and a radix. Additionally,
  a left-censored table may be produced by supplying a pre-initialised array
  containing initial parity-specific populations at some age for each cohort. 
}
\usage{
calculate.l.cft(b, l = NULL, radix = 10000, applyCorrections = TRUE)
}
\arguments{
  \item{b}{
    A 3D array of births by cohort, age and birth order for the table population.
}
  \item{l}{
    A pre-initialised left-censored 3D array of table populations by
    cohort, age and parity which is to be completed, or \code{NULL} to
    produce a standard parity matrix using only the available births data.
}
  \item{radix}{
    The size of the table population.
}
  \item{applyCorrections}{
    Whether the birth and parity data should be corrected to avoid implausible
    populations (<0) and probabilities (>1)
}
}
\details{
  The option to supply \code{l} is necessary for the "Golden Census" method for the calculation
  of Period Fertility Tables. If supplied, the array dimensions should be named appropriately.
  This argument is unnecessary for calculating Cohort Fertility Tables. 
}
\value{
  A list containing
  \item{parities}{a 3D array of table population by cohort, age and parity with named dimensions. If
    \code{l} is supplied, the dimensions are those of \code{l}, otherwise those of \code{b}.}
  \item{corrections}{a 3D array of \code{logical} indicating data cells for which the input births data
    and/or the parity data were corrected according to the HFD methodology to avoid implausible values.
    If \code{applyCorrections} is \code{FALSE} then this will simply be an array of \code{FALSE}. Dimensions
    are those of \code{l} if supplied, otherwise those of \code{b}.}
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
  \code{\link{calculate.cft}} for producing complete cohort fertility tables
}
\examples{
  data(someAsfr)
  b <- calculate.b.cft(someAsfr)
  l <- calculate.l.cft(b)
  b[l$corrections] <- l$parities[l$corrections]
  l <- l$parities
  cohorts <- as.numeric(dimnames(l)[[1]])
  ages <- as.numeric(gsub("([[:digit:]]+)[\\\\+-]", "\\\\1", dimnames(l)[[2]]))
  persp(cohorts, ages, l[, , 1] / 100, main = "Childlessness (\%) by age and cohort")
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
