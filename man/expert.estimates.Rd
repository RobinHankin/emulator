\name{expert.estimates}
\alias{expert.estimates}
\docType{data}
\title{Expert estimates for Goldstein input parameters}
\description{
A dataframe consisting of expert judgements  of low, best, and high
values for each of 19 variables that are used in the creation of
the \code{QWERTYgoin.*} files by \code{makeinputfiles()}.
}
\usage{data(expert.estimates)}
\format{
  A data frame with 19 observations on the following 3 variables.
  \describe{
    \item{low}{a numeric vector: low estimate}
    \item{best}{a numeric vector: best estimate}
    \item{high}{a numeric vector: high estimate}
  }
}
\details{
  The rows correspond to the column names of \code{results.table}.
 }
\examples{
data(expert.estimates)
}
\keyword{datasets}
