func <- function(x){out <- c(1,x)
    names(out)[1] <- "const"
    return(out)
}

n <- 5
toy <- as.matrix(c(seq(from=0,to=1,len=n)))
colnames(toy) <- "a"
rownames(toy) <- paste("obs",1:nrow(toy),sep=".")

beta <- c(-1,1)
fish <- 10
A <- corr.matrix(toy, scales=fish)
Ainv <- solve(A)
set.seed(0)
d.mean <- apply(regressor.multi(toy),1,function(x){sum(beta*x)})
d <- c(rmvnorm(n=1,mean=d.mean, sigma=A*0.1))

plot(c(toy),d)
x <- seq(from=0,to=1,len=100)

jj <- interpolant.quick(as.matrix(x), d, toy, scales=fish,
                        func=func, 
                        Ainv=Ainv,g=TRUE)

plot(x,jj$mstar.star,xlim=c(0,1),ylim=c(-1,1),type="l",col="black",lwd=3,axes=FALSE,xlab="",ylab="")
lines(x,jj$prior,col="green",type="l")
lines(x,jj$mstar.star+2*jj$Z,type="l",col="red",lty=2)
lines(x,jj$mstar.star-2*jj$Z,type="l",col="red",lty=2)
points(toy,d,pch=16,cex=2)


