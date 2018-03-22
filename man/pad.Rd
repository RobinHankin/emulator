\name{pad}
\alias{pad}
\title{Simple pad function}
\description{
Places zeros to the left of a string.  If the string
consists only of digits 0-9, \code{pad()} does not change the value of
the string if interpreted as a numeric.
}
\usage{
pad(x,len,padchar="0",strict=TRUE)
}
\arguments{
  \item{x}{Input argument (converted to character)}
  \item{len}{Desired length of output}
  \item{padchar}{Character to pad x with, defaulting to \dQuote{0}}
  \item{strict}{Boolean variable governing the behaviour when length of
    \code{x} is less than \code{len}.  Under these circumstances, if
    \code{strict} takes the default value of \code{TRUE}, then
    return an error; if \code{FALSE}, return a truncated version of \code{x}
    (least significant characters retained)}
}

\author{Robin K. S. Hankin}
\examples{
pad("1234",len=10)
pad("1234",len=3,strict=FALSE)
}
\keyword{array}
