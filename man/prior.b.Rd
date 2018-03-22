\name{prior.b}
\alias{prior.b}
\alias{prior.B}
\title{Prior linear fits}
\description{
  Gives the fitted regression coefficients corresponding to the
  specified regression model.
}
\usage{
prior.b(H, Ainv, d, b0 = NULL, B0 = NULL)
prior.B(H , Ainv , B0=NULL)
}
\arguments{
  \item{H}{Regression basis function (eg that returned by \code{regressor.multi()})}
  \item{Ainv}{\eqn{A^{-1}}{inv(A)} where \eqn{A}{A} is a correlation matrix  (eg that
    returned by \code{corr.matrix()})}
  \item{d}{Vector of data points}
  \item{b0}{prior constant}
  \item{B0}{prior coefficients}
}
\references{
  \itemize{
    \item
    J. Oakley 2004. \emph{Estimating percentiles of uncertain
      computer code outputs}.  Applied Statistics, 53(1), pp89-93.
    \item
    J. Oakley 1999. \emph{Bayesian uncertainty analysis for complex
      computer codes}, PhD thesis, University of Sheffield.
  }
}
\author{Robin K. S. Hankin}
\examples{

# example has 10 observations on 6 dimensions.
# function is just sum( (1:6)*x) where x=c(x_1, ... , x_2)

data(toy)
val <- toy
d <- apply(val,1,function(x){sum((1:6)*x)})

#add some noise:
d <- jitter(d)

A <- corr.matrix(val,scales=rep(1,ncol(val)))
Ainv <- solve(A)
H <- regressor.multi(val)

prior.b(H,Ainv,d)
prior.B(H,Ainv)
}
\keyword{models}
