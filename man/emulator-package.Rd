\name{emulator-package}
\alias{emulator-package}
\alias{emulator}
\docType{package}
\title{
Emulation of computer code output
}
\description{
  This package allows one to estimate the output of a computer program,
 as a function of the input parameters, without actually running it.
 The computer program is assumed to be a Gaussian process, whose
 parameters are estimated using Bayesian techniqes that give a PDF of
 expected program output.  This PDF is conditional on a \dQuote{training
 set} of runs, each consisting of a point in parameter space and the
 model output at that point.  The emphasis is on complex codes that take
 weeks or months to run, and that have a large number of undetermined
 input parameters; many climate prediction models fall into this class.
 The emulator essentially determines Bayesian a-postiori estimates of
 the PDF of the output of a model, conditioned on results from previous
 runs and a user-specified prior linear model.  A working example is
 given in the help page for function \code{interpolant()}, which should
 be the users's first point of reference.
}
\details{
\tabular{ll}{
Package: \tab emulator\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2007-05-02\cr
License: \tab GPL\cr
}

The primary function of the package is \code{interpolant()}.


}
\author{
Robin K. S. Hankin

Maintainer: <hankin.robin@gmail.com>
}
\references{
  \itemize{
    \item
    J. Oakley 1999. \emph{Bayesian uncertainty analysis for complex
      computer codes}, PhD thesis, University of Sheffield
    \item
    J. Oakley and A. O'Hagan, 2002. \emph{Bayesian Inference for the
      Uncertainty Distribution of Computer Model Outputs}, Biometrika
    89(4), pp769-784
    \item
    R. K. S. Hankin 2005. \emph{Introducing BACCO, an R bundle for
      Bayesian analysis of computer code output}, Journal of Statistical
    Software, 14(16)
  }
}
\keyword{ package }
\examples{

# The following example takes a toy dataframe (toy), which represents an
#  experimental design.  Variable d contains observations at points in a
#  six dimensional parameter space specified by the rows of toy.
#  Function interpolant() is then called to estimate what the
#  observation would be at a point that has no direct observation.


data(toy)
d <- c(11.05, 7.48, 12.94, 14.91, 11.34, 5.0, 11.83, 11.761, 11.62, 6.70)
fish <- rep(1,6)
x <- rep(0.5, 6)
interpolant(x, d, toy, scales=fish,give=TRUE)
}
