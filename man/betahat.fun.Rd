\name{betahat.fun}
\alias{betahat.fun}
\alias{betahat.fun.A}
\title{Calculates MLE coefficients of linear fit}
\description{

  Determines the maximum likelihood regression coeffients for the
  specified regression basis and correlation matrix \code{A}.

  The \dQuote{\code{.A}} form needs only \code{A} (and not \code{Ainv}),
  thus removing the need to calculate a matrix inverse.  Note that this
  form is \emph{slower} than the other if \code{Ainv} is known in
  advance, as \code{solve(.,.)} is slow.

  If \code{Ainv} is not known in advance, the two forms seem to
  perform similarly in the cases considered here and in the
  \code{goldstein} package.
  
}
\usage{
betahat.fun(xold, Ainv, d, give.variance=FALSE, func)
betahat.fun.A(xold, A, d, give.variance=FALSE, func)
}
\arguments{
  \item{xold}{Data frame, each line being the parameters of one run}
  \item{A}{Correlation matrix, typically provided by
    \code{corr.matrix()}}
  \item{Ainv}{Inverse of the correlation matrix \code{A}}
  \item{d}{Vector of results at the points specified in \code{xold}}
  \item{give.variance}{Boolean, with \code{TRUE} meaning to return
    information on the variance of \eqn{\hat{\beta}}{betahat} and
    default \code{FALSE} meaning to return just the estimator}
  \item{func}{Function to generate regression basis; defaults to \code{regressor.basis}}
}

\note{
  Here, the strategy of using two separate functions, eg \code{foo()}
  and \code{foo.A()}, one of which inverts \code{A} and one of which
  uses notionally more efficient means.  Compare the other
  strategy in which a Boolean flag, \code{use.Ainv}, has the same
  effect.  An example would be \code{scales.likelihood()}.
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
data(toy)
val <- toy
H <- regressor.multi(val)
d <- apply(H,1,function(x){sum((0:6)*x)})


fish <- rep(2,6)
A <- corr.matrix(val,scales=fish)
Ainv <- solve(A)

# now add suitably correlated Gaussian noise:
d <-  as.vector(rmvnorm(n=1,mean=d, 0.1*A))

betahat.fun(val , Ainv , d)           # should be close to c(0,1:6)


# Now look at the variances:
betahat.fun(val,Ainv,give.variance=TRUE, d)


     # now find the value of the prior expectation (ie the regression
     # plane) at an unknown point:
x.unknown <- rep(0.5 , 6)
regressor.basis(x.unknown) \%*\% betahat.fun(val, Ainv, d)

     # compare the prior with the posterior
interpolant(x.unknown, d, val, Ainv,scales=fish)
     # Heh, it's the same!  (of course it is, there is no error here!)


     # OK, put some error on the old observations:
d.noisy <- as.vector(rmvnorm(n=1,mean=d,0.1*A))

     # now compute the regression point:
regressor.basis(x.unknown) \%*\% betahat.fun(val, Ainv, d.noisy)

     # and compare with the output of interpolant():
interpolant(x.unknown, d.noisy, val, Ainv, scales=fish)
     # there is a difference!



     # now try a basis function that has superfluous degrees of freedom.
     # we need a bigger dataset.  Try 100:
val <- latin.hypercube(100,6)
colnames(val) <- letters[1:6]
d <- apply(val,1,function(x){sum((1:6)*x)})
A <- corr.matrix(val,scales=rep(1,6))
Ainv <- solve(A)

    
betahat.fun(val, Ainv, d, func=function(x){c(1,x,x^2)})
     # should be c(0:6 ,rep(0,6).  The zeroes should be zero exactly
     # because the original function didn't include any squares.


## And finally a sanity check:
f <- function(x){c(1,x,x^2)}
jj1 <- betahat.fun(val, Ainv, d, func=f)
jj2 <- betahat.fun.A(val, A, d, func=f)

abs(jj1-jj2)  # should be small

}
\keyword{models}
