\name{results.table}
\alias{results.table}
\docType{data}
\title{Results from 100 Goldstein runs}
\description{
A dataframe consisting of 100 rows, corresponding to 100 runs of
Goldstein.   Columns 1-19 are input values; columns 20-27
are outputs gleaned from \code{goout} files.
}
\usage{data(results.table)}
\format{
  A data frame with 100 observations on the following 27 variables.
  \describe{
    \item{filenumber}{Number of the condor run (ie file appenge of
      \code{goin.*} and \code{goout.*})}
    \item{windstress}{a numeric vector (input value)} 
    \item{oc.horiz.diffus}{a numeric vector (input value)} 
    \item{oc.vert.diffus}{a numeric vector (input value)} 
    \item{oc.drag}{a numeric vector (input value)} 
    \item{at.heat.diffus}{a numeric vector (input value)} 
    \item{at.mois.diffus}{a numeric vector (input value)} 
    \item{at.width}{a numeric vector (input value)} 
    \item{at.slope}{a numeric vector (input value)} 
    \item{advfact.zonalheat}{a numeric vector (input value)} 
    \item{advfact.meridheat}{a numeric vector (input value)} 
    \item{advfact.zonalmois}{a numeric vector (input value)} 
    \item{advfact.meridmois}{a numeric vector (input value)} 
    \item{co2.scaling}{a numeric vector (input value)} 
    \item{clim.sens}{a numeric vector (input value)} 
    \item{thres.humid}{a numeric vector (input value)} 
    \item{ice.diffus}{a numeric vector (input value)} 
    \item{fw.scaling}{a numeric vector (input value)} 
    \item{solar.const}{a numeric vector (input value)} 
    \item{ominp}{a numeric vector (output value)} 
    \item{omaxp}{a numeric vector (output value)} 
    \item{omina}{a numeric vector (output value)} 
    \item{omaxa}{a numeric vector (output value)} 
    \item{avn}{a numeric vector (output value)} 
    \item{rms}{a numeric vector (output value)} 
    \item{average.SAT}{a numeric vector (output value)} 
    \item{model.error}{a numeric vector (output value)} 
  }
}
\examples{
data(results.table)
}
\keyword{datasets}
