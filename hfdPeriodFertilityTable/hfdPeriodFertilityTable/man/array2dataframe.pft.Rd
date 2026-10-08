%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: array2dataframe.pft.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{array2dataframe.pft}
\alias{array2dataframe.pft}
\title{
Convert the 3D array from one of the PFT functions to a HFD-style data frame
}
\description{
The processing functions for calculating the individual indicators of the period
fertility table produce their results as 3D arrays. It may be more convenient to
view these results as data frames in the style of the HFD output tables, i.e. converting
data in the rough format of \code{\link{someWeightings}} into much the same format as the
input and the sample data in \code{\link{someBirths.RR}} and \code{\link{someExpos.RR}}.
}
\usage{
array2dataframe.pft(myData)
}
\arguments{
  \item{myData}{
  A 3D array of data from the period fertility table with named dimensions
  Year, Age and Order|Parity|Indicator
}
}
\value{
  A data frame with the columns Year, x and then the names included in the
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
  \code{\link{calculate.pft}} for some ways of generating \code{myData} and
  \code{\link{someWeightings}}, \code{\link{someBirths.RR}} and \code{\link{someExpos.RR}}
  for examples of the input and output data formats respectively.
}
\examples{
  data(someWeightings)
  array2dataframe.pft(someWeightings)
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
