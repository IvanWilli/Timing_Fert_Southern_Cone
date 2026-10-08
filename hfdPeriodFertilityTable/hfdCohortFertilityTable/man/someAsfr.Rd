%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: someAsfr.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{someAsfr}
\alias{someAsfr}
\docType{data}
\title{
  Sample ASFR data by cohort, age and birth order
}
\description{
  A data frame containing sample (synthetic) age-specific fertility rate
  data by cohort, age and birth order in the standard HFD data format for
  the file XXXasfrVHbo.txt
}
\usage{data(someAsfr)}
\format{
  A data frame with the following 8 variables.
  \describe{
    \item{\code{Cohort}}{The birth cohort of the mother (\code{numeric}}
    \item{\code{Age}}{The age of the mother (12-, 13, \ldots{}, 54, 55+ (\code{factor})}
    \item{\code{ASFR}}{The all-orders total age-specific fertility rate (\code{numeric}, may be \code{NA})}
    \item{\code{ASFR1}}{The birth order 1 age-specific fertility rate (\code{numeric}, may be \code{NA})}
    \item{\code{ASFR2}}{The birth order 2 age-specific fertility rate (\code{numeric}, may be \code{NA})}
    \item{\code{ASFR3}}{The birth order 3 age-specific fertility rate (\code{numeric}, may be \code{NA})}
    \item{\code{ASFR4}}{The birth order 4 age-specific fertility rate (\code{numeric}, may be \code{NA})}
    \item{\code{ASFR5p}}{The birth order 5+ age-specific fertility rate (\code{numeric}, may be \code{NA})}
  }
}
\source{
  Synthetic data
}
\references{
  Human Fertility Database: \url{http://www.humanfertility.org}
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
\keyword{datasets}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
