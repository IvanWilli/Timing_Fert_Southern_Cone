%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: calculate.pft.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{calculate.pft}
\alias{calculate.pft}
\title{
  Produce Period Fertility Tables using the HFD methodology
}
\description{
  This function produces period fertility tables (PFT) according to the methods
  described in the Methods Protocol for the Human Fertility Database.
  Featured indicators are relative distribution of female population exposure by parity (w),
  conditional fertility rates by age and birth order (m), conditional probabilities by age
  and birth order (q), population by age and parity (l), births by age and order (b),
  exposure by age and parity (L) and cumulative births by age and order (Sb).
}
\usage{
calculate.pft(birthsRR, exposRR, w, a = 0.5, returnType = "data.frame", \dots)
}
\arguments{
  \item{birthsRR}{
  observed births by birth order by Lexis squares as a 3D \code{\link{array}}, a \code{\link{data.frame}} or a file path. See details.
}
  \item{exposRR}{
  estimated female population exposure by Lexis squares as a 3D \code{\link{array}}, a \code{\link{data.frame}} or a file path. See details.
}
  \item{w}{
  estimated mid-year relative distribution by parity of female population exposure by Lexis squares as a 3D \code{\link{array}}, a \code{\link{data.frame}} or a file path. See details.
}
  \item{a}{
  the average share of the age interval [x,x+1] lived before giving birth to a child. See details.
}
  \item{returnType}{
    The format in which the period fertility table is to be returned. See details.
}
  \item{\dots}{
  arguments which will be passed through to \code{\link{read.table}} for inputs which are to be read
  from file. See details.
}
}
\details{
\code{birthsRR}, \code{exposRR} and \code{w} may be supplied as: \describe{
  \item{\code{\link{data.frame}}}{Which is assumed to contain the data in a format analogous
    the usual HFD output format, i.e. with lead columns Year and Age. For \code{birthsRR}, the
    columns Year, Age, Total, B1, B2, \dots, Bnpx are expected, for \code{exposRR}, the
    columns Year, Age and Exposure and for \code{w} the columns Year, Age, w1x, w2x,
    \dots, wnpx, where n is the highest (open) parity/order. See \code{\link{someBirths.RR}} and
    \code{\link{someExpos.RR}} for examples.
  }
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

\code{a} may be supplied as anything that is compatible for operations with \code{m}, e.g. a
single value, a vector (by year), 2D array (by year and age), 3D array (by year, age and order). Note
that if supplying as a vector or array, the number of years must match those of the resulting
period fertility table, which is not guaranteed to be the same as the years in \code{w}.

\code{returnType} may be one of \describe{
\item{"data.frame"}{(default) returns a \code{data.frame} with the columns ordered by order/parity
  and then indicator}
\item{"array"}{returns a 3D \code{array} with the dimensions Year, Age and Indicator, where Indicator
  is ordered by indicator and then parity}
\item{"list"}{returns a \code{list} of \code{arrays}, containing the indicators arranged by
  Year, Age and Order. List entries are: \describe{
  \item{w}{Relative mid-year distribution of female population by parity by year, age and parity}
  \item{m}{Conditional fertility rates by year, age and birth order}
  \item{q}{Conditional probability of giving birth by year, age and birth order}
  \item{l}{Population by year, age and parity}
  \item{b}{Births by year, age and birth order}
  \item{L}{Female population exposure by year, age and parity}
  \item{Sb}{Cumulative births by year, age and birth order}
  }}
}
}
\section{Warning}{
  It is assumed that \code{birthsRR}, \code{exposRR} and \code{w} cover the same range of ages and
  that that \code{birthsRR} and \code{w} cover the same range of orders/parities (e.g. B1..5p and
  w1..4p). Behaviour if they do not is undefined.

 It is up to the user to ensure that \code{a} has sensible dimensions, although a warning
 or error \strong{may} be raised if it does not (or calculations may continue with garbage results).
}
\value{
  A data frame with the columns Year, x and then w, m, q, l, b, L and SB for the each of
  the orders/parities in the input data.
}
\references{
  Jasilioniene et al.: Methods Protocol for the Human Fertility Database.
  Available from \url{http://www.humanfertility.org} 
}
\author{
Edward Nash \email{edward.nash@gmx.de}

Maintainer: Edward Nash \email{edward.nash@gmx.de}
}
\seealso{
\pkg{\link[hfdParity:hfdParity-package]{hfdParity}} for functions to calculate \code{w},
\code{\link{calculate.patfr}} and \code{\link{calculate.pmab}} for calculation of summary
indicators from the pft.
}
\examples{
data(someBirths.RR, someExpos.RR, someWeightings)
calculate.pft(someBirths.RR, someExpos.RR, someWeightings)
\dontrun{
## Examples of passing arguments to read.table:
# skip first 4 rows of both mybirths.txt and myexpos.txt, both of which have . as NA and column headings
calculate.pft("mybirths.txt", "myexpos.txt", someWeightings, skip = 4)

# mybirths.txt is comma-separated with no header lines (but has . as NA and column headings)
# myexpos.txt has no column names and uses NA for NA values (but has 2 header lines)
# myweightings is ;-separated and uses , as a decimal point - (but has 2 header lines, . as NA and column headings) 
calculate.pft("mybirths.txt", "myexpos.txt", "myweightings.txt", list(birthsRR = list(sep = ",", skip = 0), exposRR = list(headers = FALSE, na.strings = "NA"), w = list(sep = ";", dec = ","))
} 
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
