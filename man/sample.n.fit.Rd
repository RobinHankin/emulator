\name{sample.n.fit}
\alias{sample.n.fit}
\title{Sample from a Gaussian process and fit an emulator to the points}
\description{
Sample 'n' fit:  sample from an appropriate multivariate Gaussian
process in one dimension, then fit an emulator to it.
}
\usage{
sample.n.fit(n = 10, scales.generate = 100, scales.fit = 100, func = regressor.basis, ...)
}
\arguments{
  \item{n}{Number of observations to make}
  \item{scales.generate}{Scales to generate the data with: small values
    give uncorrelated observations, large values give correlated
    observations (hence the points fall on a smooth line)}
  \item{scales.fit}{Scales to use to fit the emulator.  Small values
    give an emulator that is the prior with short, sharp excursions to
    make the emulator go through the points; large values give smooth
    emulators that exhibit overshoots resembling Gibbs's phenomenon}
  \item{func}{Function used to determine basis vectors, defaulting
    to \code{regressor.basis} if not given.}
  \item{\dots}{Further arguments passed to \code{plot()}.}
}
\details{
The point of this function is to investigate what happens when
inappropriate scales are used for the emulator: that is, when
\code{scales.generate} and \code{scales.fit} are wildly different.

Note that the sampling distribution has a constant expectation (of
zero); so the prior should be zero, making it easy to see mispredictions
of beta.

}
\author{Robin K. S. Hankin}
\examples{

sample.n.fit(main="Default: scales match")
sample.n.fit(scales.generate=5,main="generate scale small")
sample.n.fit(scales.fit=5,main="fit scales small",sub="note vertical scale")
sample.n.fit(scales.fit=5,main="fit scales small",ylim=c(-3,3),
     sub="note appropriate interpolation, bad extrapolation")

# Now use a quadratic function instead of the default linear:
 f <- function(x){out <- c(1,x,x^2)
 names(out) <- c("const","linear","quadratic")
 out}

sample.n.fit(main="quadratic prior" , func=f)


}
\keyword{models}
