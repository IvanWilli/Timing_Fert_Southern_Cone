%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: calculate.E.pft.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{calculate.E.pft}
\alias{calculate.E.pft}
\title{
  Calculate age- and parity- specific female population exposures
}
\description{
  This function calculates the age- and parity- specific female population exposures from a set
  of mid-year age- and parity- distributions and a set of total female population exposures by
  Lexis squares.
}
\usage{
calculate.E.pft(w, exposRR, \dots)
}
\arguments{
  \item{w}{
  Estimated relative distribution of female population by parity. See details.
}
  \item{exposRR}{
  Total female population exposure by Lexis squares. See details.
}
  \item{\dots}{
  arguments which will be passed through to \code{\link{read.table}} for inputs which are to be read
  from file. See details.
}
}
\details{
Both \code{w} and \code{exposRR} may be supplied as: \describe{
  \item{\code{\link{data.frame}}}{Which is assumed to contain the data in a format analogous
    the usual HFD output format, i.e. with lead columns Year and Age. For \code{exposRR}, the
    columns Year, Age and Exposure are expected, for \code{w} the columns Year, Age, w1x, w2x,
    \dots, wnpx, where n is the highest (open) parity. See \code{\link{someExpos.RR}} for an example.}
  \item{\code{\link{character}} (or \code{\link{connection}})}{the path to a file containing
    the data in the format as for a \code{data.frame}. This file will be read in using
    \code{\link{read.table}} with the parameters \code{skip = 2, header = TRUE, na.strings = "."}.
    These parameters may be modified or additional parameters supplied by passing named arguments
    as \dots.}
  \item{\code{\link{array}}}{A 3D array containing the data arranged by Year, Age, Indicator, where
    Indicator are the columns as described for data.frame. The dimensions must be named. For
    \code{exposRR}, a 2D array (Year/Age) is also acceptable. See \code{\link{someWeightings}}
    for an example.}
}

\code{\dots} may be supplied either as named arguments to \code{\link{read.table}} or as a
\code{\link{list}} with arguments named according to the data item they refer to (i.e.
\code{exposRR} and \code{w} and entries being a list containing the named arguments for that
data item (see Examples to clarify this!).
}
\section{Warning}{
  It is assumed that \code{w} and \code{exposRR} cover the same range of ages. Behaviour if they do
  not is undefined.
}
\value{
  A 3D array of female population exposure by age and parity with named dimensions Year, Age and Parity.
  The range of years is the intersection of the years in the inputs \code{w} and \code{exposTR}.
}
\references{
  Jasilioniene et al.: Methods Protocol for the Human Fertility Database.
  Available from \url{http://www.humanfertility.org} 
}
\author{
Edward Nash \email{edward.nash@gmx.de}
}
\seealso{
The package \pkg{\link[hfdParity:hfdParity-package]{hfdParity}} for functions to calculate \code{w}.
}
\examples{
data(someExpos.RR, someWeightings)
calculate.E.pft(someWeightings, someExpos.RR)
\dontrun{
## Examples of passing arguments to read.table:
# skip first 4 rows of myexpos.txt, which has . as NA and column headings
calculate.E.pft(someWeightings, "myexpos.txt", skip = 4)

# myexpos.txt has no column names and uses NA for NA values (but has 2 header lines)
# myweightings is ;-separated and uses , as a decimal point - (but has 2 header lines, . as NA and column headings) 
calculate.E.pft("myweightings.txt", "myexpos.txt", list(exposRR = list(headers = FALSE, na.strings = "NA"), w = list(sep = ";", dec = ","))
} 
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
