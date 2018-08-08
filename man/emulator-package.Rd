\name{emulator-package}
\alias{emulator-package}
\alias{emulator}
\docType{package}
\title{
\packageTitle{emulator}
}
\description{
\packageDescription{emulator}
}
\details{
The DESCRIPTION file:
\packageDESCRIPTION{emulator}
\packageIndices{emulator}

}
\author{
\packageAuthor{emulator}

Maintainer: \packageMaintainer{emulator}
}
\references{
  \itemize{
    \item
    J. Oakley 1999. \dQuote{Bayesian uncertainty analysis for complex
      computer codes}, PhD thesis, University of Sheffield.
    \item
    R. K. S. Hankin 2005. \dQuote{Introducing BACCO, an R bundle for
      Bayesian analysis of computer code output}, Journal of Statistical
    Software, 14(16)
  }
}
\keyword{ package }
\examples{
## More detail given in optimal.scales.Rd
scales_true  <- c(1,1,1,1,1,4)

## and a real (linear) relation:
real.relation <- function(x){sum( (1:6)*x )}

## Now a design matrix:
val  <- latin.hypercube(100,6)

## apply the real relation:
d <- apply(val,1,real.relation)

## and add some suitably correlated Gaussian noise:
A <- corr.matrix(val,scales=scales_true)
d.noisy <-  as.vector(rmvnorm(n=1,mean=apply(val,1,real.relation), 0.3*A))

## Now try to predict the values at points x:

x <- latin.hypercube(20,6)
predicted <- int.qq(x,d.noisy,xold=val, Ainv=solve(A),pos.def.matrix=diag(scales_true))
observed <- apply(x,1,real.relation)

par(pty='s')
plot(predicted,observed,xlim=c(4,18),ylim=c(4,18))
abline(0,1)

}
