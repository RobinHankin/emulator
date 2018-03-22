\name{sigmahatsquared}
\alias{sigmahatsquared}
\alias{sigmahatsquared.A}
\title{Estimator for sigma squared}
\description{
  Returns maximum likelihood estimate for sigma squared.  The
  \dQuote{\code{.A}} form does not need \code{Ainv}, thus removing the need to
  invert \code{A}.  Note that this form is \emph{slower} than
  the other if \code{Ainv} is known in advance, as \code{solve(.,.)} is slow.
}
\usage{
sigmahatsquared(H, Ainv, d)
sigmahatsquared.A(H, A, d)
}
\arguments{
  \item{H}{Regressor matrix (eg as returned by \code{regressor.multi()})}
  \item{A}{Correlation matrix (eg \code{corr.matrix(val)})}
  \item{Ainv}{Inverse of the correlation matrix (eg \code{solve(corr.matrix(val))})}
  \item{d}{Vector of observations}
}
\details{
  The formula is

\deqn{\frac{y^T\left(A^{-1}-A^{-1}H(H^T A^{-1}H)^{-1} H^T
    A^{-1}\right)y}{n-q-2}}{ommitted; see pdf}

where \eqn{y} is the data vector, \eqn{H} the matrix whose rows are the
regressor functions of the design matrix, \eqn{A} the correlation
matrix, \eqn{n} the number of observations and \eqn{q} the number of
elements in the basis function.
}
\references{
  \itemize{
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
\author{Robin K. S. Hankin}
\examples{

## First, set sigmasquared to a value that we will try to estimate at the end:
REAL.SIGMASQ <- 0.3

## First, some data:
val <- latin.hypercube(100,6)
H <- regressor.multi(val,func=regressor.basis)

## now some scales:
 fish <- c(1,1,1,1,1,4)

## A and Ainv
A <- corr.matrix(as.matrix(val),scales=fish)
Ainv <- solve(A)

## a real relation; as used in helppage for interpolant:
real.relation <- function(x){sum( (1:6)*x )}

## use the real relation:
d <- apply(val,1,real.relation)

## now add some Gaussian process noise:
d.noisy <-  as.vector(rmvnorm(n=1,mean=d, REAL.SIGMASQ*A))

## now estimate REAL.SIGMASQ:
sigmahatsquared(H,Ainv,d.noisy)

## That shouldn't be too far from the real value specified above.

## Finally, a sanity check:
sigmahatsquared(H,Ainv,d.noisy) - sigmahatsquared.A(H,A=A,d.noisy)

}
\keyword{models}
