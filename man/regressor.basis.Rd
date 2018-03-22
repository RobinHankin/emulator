\name{regressor.basis}
\alias{regressor.basis}
\alias{regressor.multi}
\title{Regressor basis function}
\description{
  Creates a regressor basis for a vector. 
}
\usage{
regressor.basis(x)
regressor.multi(x.df,func=regressor.basis)
}   
\arguments{
  \item{x}{vector of coordinates}
  \item{x.df}{Matrix whose rows are coordinates of points}
  \item{func}{Regressor basis function to use; defaults to \code{regressor.basis}}
}
\details{
  
  The regressor basis specified by \code{regressor.basis()} is just the
  addition of a constant term, which is conventionally placed in the
  first position.  This is a very common choice for a set of bases,
  although it is important to investigate both simpler and more
  sophisticated alternatives.  Tony would recommend simpler functions
  (perhaps as simple as \code{function(x){1}}, that is, nothing but a
  constant), and Jonty would recommend more complicated bespoke
  functions that reflect prior beliefs.

  Function \code{regressor.multi()} is just a wrapper for
  \code{regressor.basis()} that works for matrices.  This is used
  internally and the user should not need to change it.

  Note that the user is free to define and use functions other than this
  one when using, for example, \code{corr()}.
}
\value{
  Returns simple regressor basis for vectors or matrices.
}
\note{
  When writing replacements for \code{regressor.basis()}, 
  it is important to return a vector with at least one \strong{named}
  element (see the R source code for function \code{regressor.basis()},
  in which the first element is named \dQuote{\code{const}}).

  Returning a vector all of whose elements are unnamed will cause some
  of the package functions to fail in various weird places.  It is good
  practice to use named vectors in any case.

  Function \code{regressor.multi()} includes an ugly hack to ensure that
  the perfectly reasonable choice of
  \code{regressor.basis=function(x){1}} works.  The hack is needed
  because \code{apply()} treats functions that return a length-1 value
  argument differently from functions that return a vector: if \code{x
  <- as.matrix(1:10)}

then

\code{apply(x,1,function(x){c(1,x)})}

returns a matrix (as desired), but

\code{apply(x,1,function(x){c(1)})}

returns a vector (of \code{1}s) which is not what is wanted.  The best
way to deal with this (IMHO) is to confine the ugliness to a single
function, here \code{regressor.multi()}.

}
\author{Robin K. S. Hankin}
\examples{
regressor.basis(rep(5,6))
m <- matrix(1:27,9,3)
regressor.multi(m)
regressor.multi(m,func=function(x){c(a=88,x,x^2,x[1]^4)})


# and now a little example where we can choose the basis functions
# explicitly and see the effect it has.  Note particularly the poor
# performance of func2() in extrapolation:


func1 <- function(x){
  out <- c(1,cos(x))
  names(out) <- letters[1:length(x)]
  return(out)
}

func2 <- function(x){
  out <- c(1,cos(x),cos(2*x),cos(3*x))
  names(out) <- letters[1:length(x)]
  return(out)
}

func3 <- function(x){out <- c(1,x)
names(out)[1] <- "const"
return(out)
}

func.chosen <- func1


toy <- sort(c(seq(from=0,to=1,len=9),0.2))
toy <- as.matrix(toy)
colnames(toy) <- "a"
rownames(toy) <- paste("obs",1:nrow(toy),sep=".")

d.noisy <- as.vector(toy>0.5)+rnorm(length(toy))/40

fish <- 100
x <- seq(from=-1,to=2,len=1000)
A <- corr.matrix(toy,scales=fish)
Ainv <- solve(A)

 ## Now the interpolation.  Change func.chosen() from func1() to func2()
 ## and see the difference!

jj <- interpolant.quick(as.matrix(x), d.noisy, toy, scales=fish,
                        func=func.chosen, 
                         Ainv=Ainv,g=TRUE)

plot(x,jj$mstar.star,xlim=range(x),type="l",col="black",lwd=3)
lines(x,jj$prior,col="green",type="l")
lines(x,jj$mstar.star+jj$Z,type="l",col="red",lty=2)
lines(x,jj$mstar.star-jj$Z,type="l",col="red",lty=2)
points(toy,d.noisy,pch=16,cex=2)
legend("topright",lty=c(1,2,1,0),
    col=c("black","red","green","black"),pch=c(NA,NA,NA,16),
    legend=c("best estimate","+/-1 sd","prior","training set"))


  ## Now we will use O&O 2002.

## First, some simulated design points:
xdash <- as.matrix(c(-0.5, -0.1, -0.2, 1.1, 1.15))

## create an augmented design set:
design.augmented <- rbind(toy,xdash)

## And calculate the correlation matrix of the augmented dataset:
A.augmented <- corr.matrix(design.augmented, scales=fish)
Ainv.augmented <- solve(A.augmented)

## Now, define a function that samples from the
## appropriate posterior t-distribution, adds these random
## variables to the dataset, then calculates a new
## etahat and evaluates and plots it:

f <- function(...){

ddash <- cond.sample(n=1, x=xdash, xold=toy, d=d.noisy, A=A,
                           Ainv=Ainv, scales=fish, func=func.chosen)

        jj.aug <-
          interpolant.quick(x      = as.matrix(x),
                            d      = c(d.noisy,as.vector(ddash)),
                            xold   = design.augmented,
                            Ainv   = Ainv.augmented,
                            scales = fish,func=func.chosen)
points(xdash,ddash,type="p",pch=16,col="gray")
points(x, jj.aug, type="l", col="gray")
}


## Now execute the function a few times to assess the uncertainty in eta:
f()
f()
f()

}
\keyword{models}

