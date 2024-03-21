\name{estimator}
\alias{estimator}
\title{Estimates each known datapoint using the others as datapoints}
\description{
Uses Bayesian techniques to estimate a model's prediction at each of
\code{n} datapoints.  To estimate the \eqn{i^{\rm th}}{i-th} point,
conditioning variables of \eqn{1,\ldots, i-1}{1, ..., i-1}
and \eqn{i+1,\ldots, n}{i+1, ..., n} inclusive are used (ie, all points
except point \eqn{i}).

This routine is useful when finding optimal coefficients for the
correlation using boot methods.
}
\usage{
estimator(val, A, d, scales=NULL, pos.def.matrix=NULL,
func=regressor.basis)
}
\arguments{
  \item{val}{Design matrix with rows corresponding to points at which the
    function is known}
  \item{A}{Correlation matrix (note that this is \strong{not} the
    inverse of the correlation matrix)}
  \item{d}{Vector of observations}
  \item{scales}{Scales to be used to calculate \code{t(x)}.  Note that
    \code{scales} has no default value because \code{estimator()} is
    most often used in the context of assessing the appropriateness of a
    given value of \code{scales}.  If the desired distance matrix
    (called \eqn{B}{B} in Oakley) is not diagonal, pass this matrix to
    \code{estimator()} via the \code{pos.def.matrix} argument.}
  \item{pos.def.matrix}{Positive definite matrix \eqn{B}{B}}
  \item{func}{Function used to determine basis vectors, defaulting
    to \code{regressor.basis} if not given.}
  }
\details{
Given a matrix of observation points and a vector of observations,
\code{estimator()} returns a vector of predictions.  Each prediction is
made in a three step process.  For each index \eqn{i}{i}:
\itemize{
  \item Observation \code{d[i]} is discarded, and row \code{i} and
  column \code{i} deleted from \code{A} (giving \code{A[-i,-i]}).
  Thus \code{d} and \code{A} are
  the observation vector and correlation matrix that would have been
  obtained had observation \code{i} not  been available.
  \item The value of \code{d[i]} is estimated on the basis of the
  shortened observation vector and the comatrix of \code{A}.
}
It is then possible to make a scatterplot of \code{d} vs \code{dhat}
where \code{dhat=estimator(val,A,d)}.  If the scales used are
\dQuote{good}, then the points of this scatterplot will be close to
\code{abline(0,1)}.  The third step is to optimize the goodness of fit
of this scatterplot.
}
\value{
A vector of observations of the same length as \code{d}.
}
\author{Robin K. S. Hankin}
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
\seealso{\code{\link{optimal.scales}}}
\examples{
# example has 11 observations on 6 dimensions.
# function is just sum( (1:6)*x) where x=c(x_1, ... , x_2)

val <- latin.hypercube(11,6)
colnames(val) <- letters[1:6]
d <- apply(val,1,function(x){sum((1:6)*x)})

#pick some scales:
fish <- rep(1,ncol(val))
A <- corr.matrix(val,scales=fish)

#add some suitably correlated noise:
d <- as.vector(rmvnorm(n=1, mean=d, 0.1*A))

# estimate d using the leave-out-one technique in estimator():
d.est <- estimator(val, A, d, scales=fish)

#and plot the result:
lims <- range(c(d,d.est))
par(pty="s")
plot(d, d.est, xaxs="r", yaxs="r", xlim=lims, ylim=lims)
abline(0,1)
  }
\keyword{models}
