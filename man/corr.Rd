\name{corr}
\alias{corr}
\alias{corr.matrix}
\title{correlation function for calculating A}
\description{
Calculates the correlation function between two points in parameter
space, thus determining the correlation matrix A.
}
\usage{
corr(x1, x2, scales=NULL , pos.def.matrix=NULL,
coords="cartesian", spherical.distance.function=NULL)
corr.matrix(xold, yold=NULL, method=1, distance.function=corr, ...)
}
\arguments{
  \item{x1}{First point}
  \item{x2}{Second point}
  \item{scales}{Vector specifying the diagonal elements of \eqn{B} (see below)}
  \item{pos.def.matrix}{Positive definite matrix to be used by
    \code{corr.matrix()} for \eqn{B}.  Exactly one of \code{scales} and
    \code{pos.definite.matrix} should be specified.  Supplying
    \code{scales} specifies the diagonal elements of \eqn{B} (off diagonal
    elements are set to zero); supply \code{pos.definite.matrix} in the
    general case.  A single value is recycled.   Note that neither
    \code{corr()} nor \code{corr.matrix()} test for positive
    definiteness}
  \item{coords}{In function \code{corr()}, a character string, with
    default \dQuote{cartesian} meaning to interpret the elements of
    \code{x1} (and \code{x2}) as coordinates in Cartesian space.  The
    only other acceptable value is currently \dQuote{spherical}, which
    means to interpret the first element of \code{x1} as row number, and
    the second element as column number, on a spherical computational
    grid (such as used  by climate model Goldstein; see package
    \code{goldstein} for an example of this option in use).
    Spherical geometry is then used to calculate the geotetic (great
    circle) distance between point \code{x1} and \code{x2}, with
    function \code{gcd()}}
  \item{method}{An integer with values 1, 2, or 3.  If 1, then use a
    fast matrix calculation that returns
    \eqn{e^{-(x-x')^TB(x-x')}}{exp(-(x-x')^T B (x-x'))}.  If 2 or 3, return
    the appropriate output from \code{corr()}, noting that ellipsis
    arguments are passed to \code{corr()} (for example, 
    \code{scales}).  The difference between 2 and 3 is a marginal
    difference in numerical efficiency; the main difference is
    computational elegance.
    
    \strong{Warning 1:} The code for \code{method=2} (formerly the
    default), has a bug.  If \code{yold} has only one row, then
    \code{corr.matrix(xold,yold,scales,method=2)} returns the transpose
    of what one would expect.  Methods 1 and 3 return the correct
    matrix.

    \strong{Warning 2:} If argument \code{distance.function} is not the
    default, and \code{method} is the default (ie 1), then \code{method}
    will be silently changed to 2 on the grounds that \code{method=1} is
    meaningless unless the distance function is \code{corr()}} 
  \item{distance.function}{Function to be used to calculate distances in
    \code{corr.matrix()}.  Defaults to \code{corr()}}
  \item{xold}{Matrix, each row of which is an evaluated point}
  \item{yold}{(optional) matrix, each row of which is an evaluated
    point.  If missing, use \code{xold}}
  \item{spherical.distance.function}{In \code{corr}, a function to
    determine the distance between two points; used if
    \code{coords}=\dQuote{spherical}.  A good one to choose is
    \code{gcd()} (that is, Great Circle Distance) of the goldstein library} 
  \item{...}{In function \code{corr.matrix()}, extra arguments that are
    passed on to the distance function.  In the default case in which
    the distance.function is \code{corr()}, one \emph{must} pass
    \code{scales}}
}
\details{

  Function \code{corr()} calculates the correlation between two points
  \code{x1} and \code{x2} in the parameter space.  Function
  \code{corr.matrix()} calculates the correlation matrix between each
  row of \code{xold} and \code{yold}.  If \code{yold=NULL} then the
  correlation matrix between \code{xold} and itself is returned, which
  should be positive definite.
  
  Evaluates Oakley's equation 2.12 for the
  correlation between \eqn{\eta(x)}{eta(x)} and \eqn{\eta(x')}{eta(x')}:
  \eqn{e^{-(x-x')^TB(x-x')}}{exp(-(x-x')^T B (x-x'))}.
  }
\value{
Returns the correlation function
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
\note{
  It is worth reemphasising that supplying \code{scales} makes
  matrix \eqn{B} diagonal.
  
  Thus, if \code{scales} is supplied, \code{B=diag(scales)} and
  \deqn{c(x,x')=\exp\left[-(x-x')^TB(x-x')\right]=\exp\left[\Sigma_i
    s_i(x_i-{x'}_i)^2\right]}{ommitted: see pdf}

  Thus if \eqn{x} has units \eqn{[X]}, the units of \code{scales} are
  \eqn{[X^{-2}]}{X^(-2)}.

  So if \code{scales[i]} is big, even small displacements in \code{x[i]}
  (that is, moving a small distance in parameter space, in the
  \eqn{i}-th dimension) will result in small correlations.  If
  \code{scales[i]} is small, even large displacements in \code{x[1]}
  will have large correlations}

\author{Robin K. S. Hankin}
\examples{

jj <- latin.hypercube(2,10)
x1 <- jj[1,]
x2 <- jj[2,]

corr(x1,x2,scales=rep(1,10))             # correlation between 2 points
corr(x1,x2,pos.def.matrix=0.1+diag(10))  # see effect of offdiagonal elements

x <- latin.hypercube(4,7)                # 4 points in 7-dimensional space
rownames(x) <- letters[1:4]              # name the points

corr.matrix(x,scales=rep(1,7))

x[1,1] <- 100                            # make the first point far away
corr.matrix(x,scales=rep(1,7))

# note that all the first row and first column apart from element [1,1]
# is zero (or very nearly so) because the first point is now very far
# from the other points and has zero correlation with them.

# To use just a single dimension, remember to use the drop=FALSE argument:
corr.matrix(x[,1,drop=FALSE],scales=rep(1,1))


# For problems in 1D, coerce the independent variable to a matrix:
m <- c(0.2, 0.4, 0.403, 0.9)
corr.matrix(cbind(m),scales=1)


# now use a non-default value for distance.function.
# Function f() below taken from Jeremy Oakley's thesis page 12,
# equation 2.10:

f <- function(x,y,theta){
  d <- sum(abs(x-y))
  if(d >= theta){
    return(0)
  }else{
    return(1-d/theta)
  }
}


corr.matrix(xold=x, distance.function=f, method=2, theta=4)

 # Note the first row and first column is a single 1 and 3 zeros
 # (because the first point, viz x[1,], is "far" from the other points).
 # Also note the method=2 argument here; method=1 is the fast slick
 # matrix method suggested by Doug and Jeremy, but this only works
 # for distance.function=corr.



}

\keyword{models}
