\name{dry}
\alias{dry}
\title{Don't Repeat Yourself}
\description{
  A function, used many times in the package, that checks for
  exactly one of \code{scales} or \code{pos.def.matrix} supplied as
  arguments.
}
\usage{
dry(scales, pos.def.matrix)
}
\arguments{
  \item{scales}{A vector of scales}
  \item{pos.def.matrix}{A positive-definite matrix}
}
\value{
Returns \code{TRUE} if exactly one of \code{scales} and
\code{pos.def.matrix} is supplied, stops otherwise.
}
\author{Robin K. S. Hankin}
