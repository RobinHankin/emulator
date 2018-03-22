\name{makeinputfiles}
\alias{makeinputfiles}
\alias{sample.from.exp.est}
\title{Makes input files for condor runs of goldstein}
\description{
  Wrapper to create arbitrary numbers of condor-compatible goldstein
  runnable input files.  Function \code{sample.from.exp.est()} samples from the
  appropriate distribution.

  This function is not designed for the general user: it is tailored for
  use in the environment of the National Oceanographic Centre, with a
  particular version of the specialist model \dQuote{goldstein}.
}
\usage{
makeinputfiles(number.of.runs = 100, gaussian = TRUE,
   directoryname="~/goldstein/genie-cgoldstein/", filename="QWERTYgoin",
   expert.estimates, area.outside=0.05)
sample.from.exp.est(number.of.runs, expert.estimates,
   gaussian=TRUE, area.outside=0.05)
}
\arguments{
  \item{number.of.runs}{Number of condor runs to generate}
  \item{gaussian}{Boolean variable with default TRUE meaning use a lognormal
    distribution, and FALSE meaning a uniform distribution.  In the case
    of a Gaussian distribution, only the \code{upper} and \code{lower}
    columns are used: here these values are interpreted as the
    \eqn{2.5\%\rm{ile}}{2.5\%ile} and \eqn{97.5\%\rm{ile}}{97.5\%ile}
    respectively and a lognormal distribution with the appropriate
    parameters is used.

    Note that this approach discards the \dQuote{best} value, but OTOH it
    seemed to me that my expert chose his \dQuote{best} value as an arithmetic
    (sic) mean of his high and low values, and thus has limited
    information content.
  }
  \item{directoryname}{Name of directory to which input files are
    written}
  \item{filename}{Basename of input files}
  \item{expert.estimates}{Dataframe holding expert estimates (supplied
    by a climate scientist).   Use \code{data(expert.estimates)} to load
    a sample dataset that was supplied by Bob Marsh}
  \item{area.outside}{Area of tails of the lognormal distribution (on a
log scale) that fall  outside the expert ranges.  Default value of 0.05
means interpret \code{a} and \code{b} as the \eqn{2.5\%\rm{ile}}{2.5\%ile}
and \eqn{97.5\%\rm{ile}}{97.5\%ile} respectively.}
}
\details{
  This function creates condor-compatible goldstein
  runnable input files that are placed in directory
  \code{/working/jrd/sat/rksh/goldstein}.  The database
  \code{results.table} is made using the shell scripts currently in
  \code{/users/sat/rksh/goldstein/emulator}.

  Note that \code{makeinputfiles(number.of.runs=n)} creates files
  numbered from \eqn{0}{0} to \eqn{n-1}{n-1}: so be careful of
  off-by-one errors.  It's probably best to avoid reference to the
  \dQuote{first}, \dQuote{second} file etc.  Instead, refer to files
  using their suffix number.  Note that the suffix number is not padded
  with zeros due to the requirements of Condor.

  The suffix number of a file matches the name of its \code{tmp} file
  (so, for example, file with suffix number 15 writes output to files
  \code{tmp/tmp.15} and \code{tmp/tmp.avg.15}).
  }
\value{
  Returns zero on successful completion.  The
  function is used for its side-effect of creating a bunch of Goldstein
  input files.  }
\author{Robin K. S. Hankin}
\examples{
\dontrun{
  data(expert.estimates) system("mkdir /users/sat/rksh/tmp",ignore=TRUE)
  makeinputfiles(number.of.runs = 100, gaussian = TRUE,
  directoryname="~/tmp/", expert.estimate=expert.estimates)
}
data(results.table)
data(expert.estimates)


output.col <- 25
wanted.row <- 1:27
wanted.cols <- c(2:9,12:19)

val <- results.table[wanted.row , wanted.cols]

mins  <- expert.estimates$low 
maxes <- expert.estimates$high

normalize <- function(x){(x-mins)/(maxes-mins)}
unnormalize <- function(x){mins + (maxes-mins)*x}

jj <- t(apply(val,1,normalize))

jj <- as.data.frame(jj)
names(jj) <- names(val)
val <- as.matrix(jj)

scales.optim <- exp(c( -2.63, -3.03, -2.24, 2.61,
-1.65, -3.13, -3.52, 3.16, -3.32, -2.53, -0.25,  -2.55, -4.98, -1.59,
-4.40, -0.81))

d  <- results.table[wanted.row ,  output.col]
A <- corr.matrix(val, scales=scales.optim)
Ainv <- solve(A)

x <- sample.from.exp.est(1000,exp=expert.estimates)
x <- t(apply(x,1,normalize))
ensemble <- interpolant.quick(x , d , val , Ainv, scales=scales.optim) 
hist(ensemble)
}

\seealso{\code{\link{expert.estimates}}, \code{\link{results.table}}}
\keyword{models}
