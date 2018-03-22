\name{OO2002}
\alias{OO2002}
\alias{oo2002}
\alias{cond.sample}
\alias{var.conditional}
\title{Implementation of the ideas of Oakley and O'Hagan 2002}
\description{
Implementation of the ideas of Oakley and O'Hagan 2002:
\code{var.conditional()} calculates the conditional variance-covariance
matrix, and \code{cond.sample()} samples from the appropriate
multivariate t distribution.
}
\usage{
cond.sample(n = 1, x, xold, d, A, Ainv, scales = NULL, pos.def.matrix =
NULL, func = regressor.basis, ...)
var.conditional(x, xold, d, A, Ainv, scales = NULL, pos.def.matrix = NULL, 
    func = regressor.basis, distance.function = corr, ...)
}
\arguments{
  \item{n}{In function \code{cond.sample()}, the number of observations
    to take, defaulting to 1}
  \item{x}{Simulation design points}
  \item{xold}{Design points} 
  \item{d}{Data vector}
  \item{A}{Correlation matrix}
  \item{Ainv}{Inverse of correlation matrix \eqn{A}}
  \item{scales}{Roughness lengths}
  \item{pos.def.matrix}{Positive definite matrix of correlations}
  \item{func}{Function to calculate \eqn{H}}
  \item{distance.function}{Distance function (defaulting to \code{corr()})}
  \item{...}{Further arguments passed to the distance function, usually \code{corr()}}
}
\details{
  We wish to generate the distribution for the process at uncertain
  point \code{x}; uncertainty in \code{x} is captured by assuming it to
  be drawn from a pdf \code{X}.
  
  The basic idea is to estimate \eqn{m^*}{m*} at \emph{simulated} design
  points using \code{cond.sample()}, which samples from the multivariate
  t distribution conditional on the data \code{d} at the design points.
  The random datavector of estimates \eqn{m^*}{m*} is called \code{ddash}.

  We repeat this process many times, each time estimating
  \eqn{\eta(\cdot)}{eta(.)} using the augmented dataset
  \code{c(d,ddash)} as a training set.

  For each estimated \eqn{\eta(\cdot)}{eta(.)}, we have a complete
  emulator that can be used to build up an ensemble of estimates.  
      
}

\value{

Function \code{cond.sample()} returns a \eqn{n\times p}{n*p} matrix
whose rows are independent samples from the appropriate multivariate
\eqn{t} distribution.  Here, \eqn{p} is the number of rows of \code{x}
(ie the number of simulated design points).  Consider a case where there
are just two simulated design points, close to each other but far from
any point of the original design points.  Then function
\code{cond.sample(n=4, ...)} will give four numbers which are close to
one another but have high (between-instantiation) variance.

Function \code{var.conditional()} calculates the denominator of equation
3 of Oakley and OHagan 2002.  This function is intended to be called by
\code{cond.sample()} but might be interesting \emph{per se} when
debugging or comparing different choices of simulated design points.
}
\references{
  \itemize{
    \item
    J. Oakley 2002. \emph{Bayesian inference for the
      uncertainty distribution of computer model outputs}.  Biometrika,
    89(4):769--784
    \item
    R. K. S. Hankin 2005. \emph{Introducing BACCO, an R bundle for
      Bayesian analysis of computer code output}, Journal of Statistical
    Software, 14(16)
  }
}
\author{Robin K. S. Hankin}
\note{
  Function \code{cond.sample()} and \code{var.conditional()} together
  are a superset of function \code{interpolant()} because it accounts
  for covariance between multiple observations.  It is, however, much
  slower.

  Also note that these functions are used to good effect in the examples
  section of \code{oo2002.Rd}.
}
\seealso{\code{\link{regressor.basis}}, for a more visually informative
  example of \code{cond.sample()} et seq; and \code{\link{interpolant}}
  for more examples
}
\examples{


     # Now we use the functions.  First we set up some design points:
     # Suppose we are given the toy dataset and want to know the PDF of
     # fourth power of the response at point x, where uncertainty in x
     # may be represented as it being drawn from a normnl distribution
     # with mean c(0.5,0.5,...,0.5) and a variance of 0.001.

data(toy)
val <- toy
real.relation <- function(x){sum( (0:6)*x )}
H <- regressor.multi(val)
d <- apply(H,1,real.relation)

     # and some scales (which are assumed to be known):
fish <- rep(1,6)
fish[6] <- 4

     # And determine A and Ainv:
A <- corr.matrix(val,scales=fish)
Ainv <- solve(A)

     # and add some suitably correlated Gaussian noise:
d.noisy <-  as.vector(rmvnorm(n=1, mean=d, 0.1*A))
names(d.noisy) <- names(d)

     # Now some simulation design points.  Choose n'=6:
xdash <-  matrix(runif(36),ncol=6)

     # And just for fun, we insert a near-useless seventh simulation
     # design point (it is nearly useless because it is a near copy of
     # the sixth).  We do this in order to test the coding:
xdash <- rbind(xdash,xdash[6,] + 1e-4)
colnames(xdash) <- colnames(val)
rownames(xdash) <- c("alpha","beta","gamma","delta","epsilon","zeta","zeta.copy")

     # Print the variance matrix:
(vm <- var.conditional(x=xdash,xold=val,d=d.noisy,A=A,Ainv=Ainv,scales=fish))
     # Note that the sixth and seventh columns are almost identical
     # (and so, therefore, are the sixth and seventh rows) as
     # expected.

     # Also, the final eigenvalue of vm should be small:
eigen(vm)$values


     # Now sample from the conditional t-distribution.  Taking n=3 samples:
(cs <- cond.sample(n=3, x=xdash, xold=val, d=d.noisy, A=A, Ainv=Ainv,
                   scales = fish, func = regressor.basis))

     # Note the last two columns are nearly identical, as expected.

     # Just as a test, what is the variance matrix at the design points?
(vc <- var.conditional(x=val,xold=val,d=d.noisy,A=A,Ainv=Ainv,scales=fish))
     # (This should be exactly zero);
max(eigen(vc)$values)
     # should be small

     # Next, we apply the methods of OO2002 using Monte Carlo techniques.
     # We will generate  10 different versions of eta:
number.of.eta <- 10

     # And, for each eta,  we will sample from the posterior t distribution 11 times:
number.of.X <- 11


     # create an augmented design matrix, of the design points plus the
     # simulated design points:
design.augmented <- rbind(val,xdash)
A.augmented <- corr.matrix(design.augmented, scales=fish)
Ainv.augmented <- solve(A.augmented)

out <- NULL
for(i in seq_len(number.of.eta)){
        # Create random data by sampling from the conditional
        # multivariate t at the simulated design points xdash, from
        # the t-distribution given the data d:
   ddash <- cond.sample(n=1, x=xdash, xold=val, d=d.noisy, Ainv=Ainv, scales=fish)

        # Now use the emulator to calculate m^* at points chosen from
        # the PDF of X:
   jj <-
     interpolant.quick(x=rmvnorm(n=number.of.X,rep(0.5,6),diag(6)/1000),
                       d=c(d.noisy,ddash),
                       xold=design.augmented,
                       Ainv=Ainv.augmented,
                       scales=fish)
   out <- c(out,jj)
}

   # histogram of the fourth power:
hist(out^4, col="gray")
   # See oo2002 for another example of cond.sample() in use
}
\keyword{models}
