\name{quad.form}
\alias{quad.form}
\alias{quad.form.inv}
\alias{quad.3form}
\alias{quad.3form.inv}
\alias{quad.tform}
\alias{quad.3tform}
\alias{quad.tform.inv}
\alias{quad.diag}
\alias{quad.tdiag}
\alias{quad.3diag}
\alias{quad.3tdiag}
\alias{cprod}
\alias{tcprod}
\alias{ht}
\title{Evaluate a quadratic form efficiently}
\description{

  Functionality for evaluating quadratic forms.
  
  \strong{If you want to use these functions, import them from the
    \CRANpkg{quadform} package, which has more extensive functionality,
    and is maintained.}

}
\usage{
quad.form(M, x)
quad.form.inv(M, x)
quad.tform(M, x)
cprod(x,y)
ht(x)
}
\arguments{
  \item{M}{Square matrix of size \eqn{n\times n}{n*n}}
  \item{x,y}{Matrix of size \eqn{n\times p}{n*p}, or vector of length \eqn{n}}
}
\details{See the \CRANpkg{quadform} package for further detail.}
\author{Robin K. S. Hankin}

\note{ See the \CRANpkg{quadform} package for further detail.}
\seealso{\code{\link{optimize}}}
\examples{

jj <- matrix(rnorm(80),20,4)
M <- crossprod(jj,jj)

x <- matrix(rnorm(8),4,2)

jj.1 <- t(x) \%*\% M \%*\% x
jj.2 <- quad.form(M,x)
print(jj.1)
print(jj.2)

}
\keyword{array}
