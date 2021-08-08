library("emulator")
`func` <- function(x){out <- c(1,x)
    names(out)[1] <- "const"
    return(out)
}

n <- 5
toy <- as.matrix(c(seq(from=0,to=1,len=n)))
colnames(toy) <- "a"
rownames(toy) <- paste("obs",1:nrow(toy),sep=".")

beta <- c(-1,1)
fish <- 20
A <- corr.matrix(toy, scales=fish)
Ainv <- solve(A)
set.seed(0)
d.mean <- apply(regressor.multi(toy),1,function(x){sum(beta*x)})
d <- c(rmvnorm(n=1,mean=d.mean, sigma=A*0.1))
x <- seq(from=0,to=1,len=100)

jj <- interpolant.quick(as.matrix(x), d, toy, scales=fish,
                        func=func, 
                        Ainv=Ainv,g=TRUE)

pdf(file="emulator_icon.pdf")
plot(x,jj$mstar.star,xlim=c(0,1),ylim=c(-1,1),type="l",col="black",lwd=5,axes=FALSE,xlab="",ylab="")
lines(x,jj$prior,type="l",lwd=2)
lines(x,jj$mstar.star+1.95*jj$Z,type="l",lty=2,lwd=3)
lines(x,jj$mstar.star-1.95*jj$Z,type="l",lty=2,lwd=3)
points(toy,d,pch=16,cex=2)
dev.off()
