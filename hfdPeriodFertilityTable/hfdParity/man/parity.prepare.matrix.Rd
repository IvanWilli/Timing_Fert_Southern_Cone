%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: parity.prepare.matrix.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{parity.prepare.matrix}
\alias{parity.prepare.matrix}
\title{
  Prepare a 3D array of census parity data
}
\description{
  This function may be used to prepare a set of census parity data for input
  into functions generating the age-parity distribution for a period fertility table.
  
  Two steps are performed: for each year an initial lower age is prepended with
  the parity distribution 1, 0, \dots, 0, after which the data frame is transformed
  to a 3D array.
}
\usage{
parity.prepare.matrix(parity.weights)
}
\arguments{
  \item{parity.weights}{
  A data frame of female population relative parity distribution, usually on January
  1st, with the columns Year, Age, w0, w1, \dots, wxp
}
}
\value{
  A 3D array with the dimensions Year, Age and Parity. The Year dimension is the
  number of unique Years in \code{parity.weights}, the Age dimension the number
  of ages plus one, and the Parity dimension the number of parity levels.
}
\author{
  Edward Nash \email{edward.nash@gmx.de}
}
\seealso{
  \code{\link{parity.1Jan.weights}} for production of suitable inputs for
  \code{parity.weights}.
}
\examples{
  data(sweRegisterPath)
  p.weights <- parity.1Jan.weights(parity.census.weights(sweRegisterPath))
  parity.prepare.matrix(p.weights)
}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
