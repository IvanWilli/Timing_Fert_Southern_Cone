%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: internal.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{internal}
\alias{.calculate.mab.tfr}
\alias{.generateMask}
\alias{.shiftMask}
\title{
  Functions used internally in hfdBasicIndicators
}
\description{
  These functions are used internally within the public functions in the package.
  They are not intended to be called directly.
}
\usage{
  .calculate.mab.tfr(fn, asfr, shape, observeFrom = 15, observeTo = 50, colName, \dots)
  .generateMask(asfr, observeFrom, observeTo)
  .shiftMask(asfr, mask, observeFrom)
}
\arguments{
  \item{fn}{
  A function capable of calculating an indicator from a long data frame with
  columns [primary], Age, Order, ASFR
  }
  \item{asfr}{a data frame of ASFR data in the usual HFD format, path to file or 3D array}
  \item{mask}{previously-produced data mask (from \code{.generateMask})}
  \item{shape}{
  The Lexis shape in which the data is expressed; one of RR or VH
  }
 \item{observeFrom}{
  For VH, the maximum age from which cohorts must have been observed. Ignored for RR.
  }
  \item{observeTo}{
  For VH, the minumum age to which cohorts must have been observed to calculate TFR. Ignored for RR.
  }
  \item{colName}{
  The base of the column names in the output, typically TFR or MAB
  }
  \item{\dots}{
  Named arguments which will potentially be passed to \code{\link{read.table}}.
}
}
\details{
  \code{.calculate.mab.tfr} performs the common part of the data manipulation for the calculation
  of MAB and TFR indicators. \code{.generateMask} is used to produce a list of logical vectors
  indicating cells with \code{NA} values which should be replaced with \code{0} to ease calculation
  of indicators. \code{.shiftMask} is used to produce a list of logical vectors indicating cells
  whose value should be replaced with \code{NA} for output (following prior use of the result from
  \code{.generateMask}.
}
\value{
  For \code{.calculate.mab.tfr}, a data frame containing the calculated indicators.
  
  For \code{.generateMask} and \code{.shiftMask}, a list conatining one logical vector of the length
  of the number of ages in \code{asfr} for each of the values in the primary factor (Year or Cohort) of 
  \code{asfr}.
}
\references{
  Jasilioniene et al.: Methods Protocol for the Human Fertility Database.
  Available from \url{http://www.humanfertility.org} 
}
\author{
  Edward Nash \email{edward.nash@gmx.de}
}
\seealso{
  \code{\link{calculate.tfr}}, \code{\link{calculate.mab}} and \code{\link{calculate.cfr}} for functions
  which use these functions internally.
}\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
