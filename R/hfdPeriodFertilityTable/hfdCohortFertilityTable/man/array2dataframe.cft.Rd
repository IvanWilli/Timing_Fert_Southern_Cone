%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: array2dataframe.cft.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{array2dataframe.cft}
\alias{array2dataframe.cft}
\title{
Convert the 3D array from one of the CFT functions to a HFD-style data frame
}
\description{
The processing functions for calculating the individual indicators of the cohort
fertility table produce their results as 3D arrays. It may be more convenient to
view these results as data frames in the style of the HFD output tables, i.e.
in much the same format as the input and the sample data in \code{\link{someAsfr}}.
}
\usage{
array2dataframe.cft(myData)
}
\arguments{
  \item{myData}{
  A 3D array of data from the cohort fertility table with named dimensions
  Cohort, Age and Order|Parity|Indicator
}
}
\value{
  A data frame with the columns Cohort, x and then the names included in the
  third dimension of \code{myData}.
}
\references{
  Human Fertility Database data format documentation, available from
  \url{http://www.humanfertility.org}.
}
\author{
  Edward Nash \email{edward.nash@gmx.de}
}
\note{
  A check is made that the array \code{myData} corresponds to the expected
  format, i.e. 3 named dimensions with suitable names
}
\seealso{
  \code{\link{calculate.cft}} for some ways of generating \code{myData} and
  \code{\link{someAsfr}} for a data frame which is already in the format
  produced as output from this function.
}
\examples{
  someArray <- array(runif(1860), dim = c(20, 31, 3), dimnames = list(Cohort = 1950:1969, Age = c(15:45), Order = c("m1x", "m2x", "m3px")))
  array2dataframe.cft(someArray)
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
