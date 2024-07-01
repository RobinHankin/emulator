library(emulator)

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


toy <- as.matrix(c(1,1.2,2.4,4,5,6,7,8))
colnames(toy) <- "a"
rownames(toy) <- paste("obs",1:nrow(toy),sep=".")

d.noisy <- c(1.84, 1.9, 2.1, 2.4, 1.6, 1.5, 1.9, 2.6)

fish <- 2
x <- seq(from=-1,to=8,len=200)
A <- corr.matrix(toy,scales=fish)
Ainv <- solve(A)

## Now the interpolation.  Change func.chosen() from func1() to func2()
## and see the difference!

jj <- interpolant.quick(as.matrix(x), d.noisy, toy, scales=fish,
                        func=func.chosen, 
                        Ainv=Ainv,g=TRUE)

plot(x,jj$mstar.star,xlim=range(x),type="l",col="black",lwd=3,ylim=c(1,3))
lines(x,jj$prior,col="green",type="l")
lines(x,jj$mstar.star+jj$Z,type="l",col="red",lty=2)
lines(x,jj$mstar.star-jj$Z,type="l",col="red",lty=2)
points(toy,d.noisy,pch=16,cex=2)
legend("topright",lty=c(1,2,1,0),
       col=c("black","red","green","black"),pch=c(NA,NA,NA,16),
       legend=c("best estimate","+/-1 sd","prior","training set"))
