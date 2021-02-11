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
  
  Given a square matrix \eqn{M} of size \eqn{n\times n}{n*n}, and a
  matrix \eqn{x} of size \eqn{n\times p}{n*p} (or a vector of length
  \eqn{n}), evaluate various quadratic forms.

  (in the following, \eqn{x^T}{t(x)} denotes the complex conjugate of
  the transpose, also known as the Hermitian transpose.  This only
  matters when considering complex numbers).
  
  \itemize{
    \item Function \code{quad.form(M,x)} evaluates \eqn{x^TMx}{t(x)
      \%*\% M \%*\% x} in an efficient manner
    
    \item Function \code{quad.form.inv(M,x)} returns \eqn{x^TM^{-1}x}{t(x)
      \%*\% solve(M) \%*\% x} using an efficient method that avoids
    inverting \eqn{M}
    
    \item Function \code{quad.tform(M,x)} returns \eqn{xMx^T}{x \%*\% A
      \%*\% t(x)} using \code{tcrossprod()} without taking
      a transpose

    \item Function \code{quad.tform.inv(M,x)} returns \eqn{xM^{-1}x^T}{x
      \%*\% solve(M) \%*\% t(x)}, although a single transpose is needed

    \item Function \code{quad.3form(M,l,r)} returns \eqn{l^TMr}{t(l)
      \%*\% M \%*\% r} using nested calls to \code{crossprod()}.  It's
    no faster than calling \code{crossprod()} directly, but makes code
    neater and less error-prone (IMHO)

    \item Function \code{quad.3form.inv(M,l,r)} returns
      \eqn{l^TM^{-1}r}{t(l) \%*\% solve(M) \%*\% r}

    \item Function \code{quad.3tform(M,l,r)} returns \eqn{lMr^T}{l \%*\%
      M \%*\% t(r)} using nested calls to \code{tcrossprod()}.  Again,
    this is to make for neater code
    
    \item Function \code{quad.diag(M,x)} returns the \emph{diagonal} of
    the (potentially very large) square matrix \code{quad.form(M,x)}
    without calculating the off diagonal elements
    
    \item Function \code{quad.tdiag(M,x)} similarly returns the diagonal of
    \code{quad.tform(M,x)}

    \item Function \code{quad.3diag(M,l,r)} returns the diagonal of
    \code{quad.3form(M,l,r)} 

    \item Function \code{quad.3tdiag(M,l,r)} returns the diagonal of
    \code{quad.3tform(M,l,r)} 

  }
    
  These functions invoke the following lower-level calls:
  
  \itemize{
    \item Function \code{ht(x)} returns the Hermitian transpose, that is,
    the complex conjugate of the transpose, sometimes written \eqn{x^*}

    \item Function \code{cprod(x,y)} returns \eqn{x^T y}{t(x) \%*\% y},
    equivalent to \code{crossprod(Conj(x),y)}
    
    \item Function \code{tcprod(x,y)} returns \eqn{x y^T}{x \%*\% t(y)},
    equivalent to \code{crossprod(x,Conj(y))} }
   
  Note again that in the calls above, \dQuote{transpose} [that is,
  \eqn{x^T}{t(x)}] means \dQuote{Conjugate transpose}, or the Hermitian
  transpose.
  
}
\usage{
quad.form(M, x, chol=FALSE)
quad.form.inv(M, x)
quad.tform(M, x)
quad.3form(M,left,right)
quad.3tform(M,left,right)
quad.tform.inv(M,x)
quad.diag(M,x)
quad.tdiag(M,x)
quad.3diag(M,left,right)
quad.3tdiag(M,left,right)
cprod(x,y)
tcprod(x,y)
ht(x)
}
\arguments{
  \item{M}{Square matrix of size \eqn{n\times n}{n*n}}
  \item{x,y}{Matrix of size \eqn{n\times p}{n*p}, or vector of length \eqn{n}}
  \item{chol}{Boolean, with \code{TRUE} meaning to interpret
    argument \code{M} as the lower triangular Cholesky decomposition
    of the quadratic form.  Remember that 
    \code{M.lower \%*\% M.upper == M},  and \code{chol()} returns the
    upper triangular matrix, so one needs to use the transpose
    \code{t(chol(M))}}
  \item{left,right}{In function \code{quad.3form()}, matrices with
    \eqn{n} rows and arbitrary number of columns}
}
\details{
  The \dQuote{meat} of \code{quad.form()} for \code{chol=FALSE} is just
  \code{crossprod(crossprod(M, x), x)}, and that of
  \code{quad.form.inv()} is \code{crossprod(x, solve(M, x))}.
  
  If the Cholesky decomposition of \code{M} is available, then calling
  with \code{chol=TRUE} and supplying \code{M.upper} should generally be
  faster (for large matrices) than calling with \code{chol=FALSE} and
  using \code{M} directly.  The time saving is negligible for matrices
  smaller than about \eqn{50\times 50}{50*50}, even if the overhead of
  computing \code{M.upper} is ignored.

}
\author{Robin K. S. Hankin}

\note{
  These functions are used extensively in the emulator and
  calibrator packages' R code, primarily in the interests of elegant
  code, but also speed.  For the problems I usually consider, the
  speedup (of \code{quad.form(M,x)} over \code{t(x) \%*\% M \%*\% x},
  say) is marginal at best.
}
\seealso{\code{\link{optimize}}}
\examples{
jj <- matrix(rnorm(80),20,4)
M <- crossprod(jj,jj)
M.lower <- t(chol(M))
x <- matrix(rnorm(8),4,2)

jj.1 <- t(x) \%*\% M \%*\% x
jj.2 <- quad.form(M,x)
jj.3 <- quad.form(M.lower,x,chol=TRUE)
print(jj.1)
print(jj.2)
print(jj.3)




## Make two Hermitian positive-definite matrices:
L <- matrix(c(1,0.1i,-0.1i,1),2,2)
LL <- diag(11)
LL[2,1] <- -(LL[1,2] <- 0.1i)


z <- t(latin.hypercube(11,2,complex=TRUE))


quad.diag(L,z)     # elements real because L is HPD
quad.tdiag(LL,z)   # ditto




## Now consider accuracy:
quad.form(solve(M),x) - quad.form.inv(M,x)  # should be zero
quad.form(M,x) - quad.tform(M,t(x))         # should be zero
quad.diag(M,x) - diag(quad.form(M,x))       # should be zero
diag(quad.form(L,z))   - quad.diag(L,z)     # should be zero
diag(quad.tform(LL,z)) - quad.tdiag(LL,z)   # should be zero
}
\keyword{array}
