%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: calculate.b.cft.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{calculate.b.cft}
\alias{calculate.b.cft}
\title{
  Calculate a 3D array of table births by cohort, age and birth order
}
\description{
  This function calculates and returns a 3D array of table births based
  on a supplied set of Age Specific Fertility Rates
}
\usage{
calculate.b.cft(asfr, observeTo = 25, observeFrom = 15, radix = 10000)
}
\arguments{
  \item{asfr}{
    The age-specific fertility rates
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
}
\details{
asfr may be supplied as one of one of \describe{
  \item{data.frame}{a \code{\link{data.frame}} containing the age-specific fertility rate
    dataset as horizontal parallograms. The columns Cohort, Age, ASFR, ASFR1,
    \ldots{}, ASFRxp are assumed, with the first three of these tested for.
  }
  \item{array}{a 3D \code{\link{array}} with the dimensions named according to the
    Cohort, Age and Order respectively. In this case, it is expected that there
    is no total ASFR included in the array (whereas there is in the data.frame)
  }
}
\code{observeFrom} and \code{observeTo} may be supplied as a \code{numeric}, or a \code{logical}
with \code{FALSE} indicating no filtering and \code{TRUE} indicating that the default value
should be used.
}
\value{
  A 3D array of table births in the radix with the named dimensions Cohort, Age and Order 
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
  \code{\link{calculate.cft}} for the calculation of the entire CFT 
}
\examples{
  data(someAsfr)
  tableBirthsPerThousand <- calculate.b.cft(someAsfr, observeTo = FALSE, observeFrom = FALSE, radix = 1000)
}\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
