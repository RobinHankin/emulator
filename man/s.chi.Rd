\name{s.chi}
\alias{s.chi}
\title{Variance estimator}
\description{
  Returns estimator for a priori \eqn{\sigma^2}{sigma^2}
}
\usage{
s.chi(H, Ainv, d, s0 = 0, fast.but.opaque = TRUE)
}
\arguments{
  \item{H}{Regression basis function (eg that returned by \code{regressor.multi()})}
  \item{Ainv}{\eqn{A^{-1}}{inv(A)} where \eqn{A}{A} is a correlation matrix  (eg that
    returned by \code{corr.matrix()})}
  \item{d}{Vector of data points}
  \item{s0}{Optional offset}
  \item{fast.but.opaque}{Boolean, with default \code{TRUE} meaning to
    use \code{quad.form()}, and \code{FALSE} meaning to use straightforward
    \code{\%*\%}.  The first form should be faster, but the code is less
    intelligible than the second form.  Comparing the returned value
    with this argument on or off should indicate the likely accuracy attained.}
}
\details{
  See O'Hagan's paper (ref below), equation 12 for details and context.
}
\references{
  A. O'Hagan 1992. \dQuote{Some Bayesian Numerical Analysis}, pp345-363 of
  \emph{Bayesian Statistics 4} (ed J. M. Bernardo et al), Oxford University
  Press
}  
\author{Robin K. S. Hankin}
\examples{

# example has 10 observations on 6 dimensions.
# function is just sum( (1:6)*x) where x=c(x_1, ... , x_2)
data(toy)
val <- toy
colnames(val) <- letters[1:6]
H <- regressor.multi(val)
d <- apply(H,1,function(x){sum((0:6)*x)})


# create A matrix and its inverse:
A <- corr.matrix(val,scales=rep(1,ncol(val)))
Ainv <- solve(A)

# add some suitably correlated noise:
d <- as.vector(rmvnorm(n=1, mean=d, 0.1*A))

# now evaluate s.chi():
s.chi(H, Ainv, d)


# assess accuracy:
s.chi(H, Ainv, d, fast=TRUE) - s.chi(H, Ainv, d, fast=FALSE)

}
\keyword{models}
