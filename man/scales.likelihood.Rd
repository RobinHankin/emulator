\name{scales.likelihood}
\alias{scales.likelihood}
\title{Likelihood of roughness parameters}
\description{
Gives the a postiori likelihood for the roughness parameters as a
function of the observations.
}
\usage{
scales.likelihood(pos.def.matrix = NULL, scales = NULL, xold,
use.Ainv = TRUE, d, give_log=TRUE, func = regressor.basis)
}
\arguments{
  \item{pos.def.matrix}{Positive definite matrix used for the distance metric}
  \item{scales}{If the positive definite matrix is diagonal, 
    \code{scales} specifies the diagonal elements.  Specify exactly one
    of \code{pos.def.matrix} or \code{scales} (ie not both)}
  \item{xold}{Points at which code has been run}
  \item{use.Ainv}{Boolean, with default \code{TRUE} meaning to calculate
    \eqn{A^{-1}}{A^(-1)} explicitly and use it.  Setting to \code{FALSE}
    means to use methods (such as \code{quad.form.inv()}) which do not
    require inverting the \code{A} matrix.  Although one should avoid
    inverting a matrix if possible, in practice there does not appear
    to be much difference in execution time for the two methods}
  \item{d}{Observations in the form of a vector with entries
    corresponding to the rows of \code{xold}}
  \item{give_log}{Boolean, with default \code{TRUE} meaning to return
    the logarithm of the likelihood (ie the support) and \code{FALSE}
    meaning to return the likelihood itself}
    \item{func}{Function used to determine basis vectors, defaulting
    to \code{regressor.basis} if not given}
}
\details{
This function returns the likelihood function defined in Oakley's PhD
thesis, equation 2.37.  Maximizing this likelihood to estimate the
roughness parameters is an alternative to the leave-out-one method on
the \code{interpolant()} helppage; both methods perform similarly.

The value returned is

\deqn{
\left(\hat{\sigma}\right)^{-(n-q)/2}
\left|A\right|^{-1/2}\cdot\left|H^TA^{-1}H\right|^{-1/2}.
}{(sigmahatsquared)^{-(n-q)/2}|A|^{-1/2}|t(H) \%*\% A \%*\% H|^{-1/2}.}

}
\value{
Returns the likelihood or support.
}
\note{
  This function uses a Boolean flag, \code{use.Ainv}, to determine
  whether \code{A} has to be inverted or not.  Compare the other
  strategy in which separate functions, eg \code{foo()} and
  \code{foo.A()}, are written.  An example would be \code{betahat.fun()}.
}
\references{
  \itemize{
    \item
    J. Oakley 1999. \emph{Bayesian uncertainty analysis for complex
      computer codes}, PhD thesis, University of Sheffield.
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
\seealso{\code{\link{optimal.scales}}}
\examples{
 data(toy)
 val <- toy

 #define a real relation
 real.relation <- function(x){sum( (0:6)*x )}

 #Some scales:
 fish <- rep(1,6)
 fish[6] <- 4
 A <- corr.matrix(val,scales=fish)
 Ainv <- solve(A)

 # Gaussian process noise:
 H <- regressor.multi(val)
 d <- apply(H,1,real.relation)
 d.noisy <- as.vector(rmvnorm(n=1,mean=d, 0.1*A))

 # Compare likelihoods with true values and another value:
 scales.likelihood(scales=rep(1,6),xold=toy,d=d.noisy)
 scales.likelihood(scales=fish    ,xold=toy,d=d.noisy)


 # Verify that use.Ainv does not affect the numerical result:
u.true  <- scales.likelihood(scales=rep(1,6),xold=toy,d=d.noisy,use.Ainv=TRUE)
u.false <- scales.likelihood(scales=rep(1,6),xold=toy,d=d.noisy,use.Ainv=FALSE)
print(c(u.true, u.false))  # should be identical up to numerical accuracy


 # Now use optim():
 f <- function(fish){scales.likelihood(scales=exp(fish), xold=toy, d=d.noisy)}
 e <-
optim(log(fish),f,method="Nelder-Mead",control=list(trace=0,maxit=10,fnscale=
-1))
best.scales <- exp(e$par)

}
\keyword{array}
