%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Subversion file information - please do not edit this block
%% $Rev: 1072 $
%% $Date: 2015-02-27 23:21:59 +0100 (Fr, 27. Feb 2015) $
%% $Author: svnNash $
%% $Id: sweRegisterPath.Rd 1072 2015-02-27 22:21:59Z svnNash $
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{sweRegisterPath}
\alias{sweRegisterPath}
\docType{data}
\title{
  Path to a file containing population by parity data from the Swedish population register
}
\description{
  In order to demonstrate file-based access to the functions in this package,
  a file \code{SWEparity-extract.txt} is installed in the directory
  \code{sampleFiles} of the package. This data object returns the path to
  that file to allow it to be easily accessed.
  
  The file itself is an extract of the file \code{SWEparity.txt} from the
  Human Fertility Database \url{http://www.humanfertility.org}. It contains
  data from the Swedish population register of the female population by parity
  on December 31st in the years 1980-1984.
}
\usage{data(sweRegisterPath)}
\format{
  \code{sweRegisterPath} returns a character vector containing the path to the file.
  
  The file itself is in the standard HFD format as described in the data format
  documentation available on the HFD website:
  \url{http://www.humanfertility.org/Docs/formats.pdf}.
}
\source{
Human Fertility Database \url{http://www.humanfertility.org}
} 
\examples{
data(sweRegisterPath)
}
\keyword{datasets}
\section{Copyright}{
(c) Human Fertility Database project:
  Max Planck Institute for Demographic Research (Germany) and
  Vienna Institute of Demography (Austria)
}
