library("hexSticker")
library("emulator")

`func` <- function(x){out <- c(1,x,x^2)
    names(out)[1] <- "const"
    return(out)
}

`regressor.quad` <- function(x){cbind(regressor.multi(x),x^2)}

n <- 7
toy <- as.matrix(c(seq(from=0,to=1,len=n)))
colnames(toy) <- "a"
rownames(toy) <- paste("obs",1:nrow(toy),sep=".")

beta <- c(-1,-7,7.5)
fish <- 50
A <- corr.matrix(toy, scales=fish)
Ainv <- solve(A)
set.seed(1)
d.mean <- apply(regressor.quad(toy),1,function(x){sum(beta*x)})
d <- c(rmvnorm(n=1,mean=d.mean, sigma=A*0.1))
d <- c(-1.19, -1.96, -2.69, -2.15, -2.2, -1.67, -0.38)
x <- seq(from=0,to=1,len=300)

jj <- interpolant.quick(as.matrix(x), d, toy, scales=fish,
                        func=func, 
                        Ainv=Ainv,g=TRUE)

png(file="emulator_icon.png",width=1000,height=1000,bg="transparent")
plot(x,jj$mstar.star,xlim=c(0,1),ylim=c(-3,1),type="l",col="black",lwd=12,axes=FALSE,xlab="",ylab="")
lines(x,jj$prior,type="l",lwd=7)
lines(x,jj$mstar.star+1.95*jj$Z,type="l",lty=3,lwd=5)
lines(x,jj$mstar.star-1.95*jj$Z,type="l",lty=3,lwd=5)
points(toy,d,pch=16,cex=8)
dev.off()


sticker("emulator_icon.png", package="emulator", p_size=80, s_x=0.975, s_y=1.5,
s_width=1.6,asp=sqrt(3)/2, white_around_sticker=TRUE, h_fill="#7733FF", dpi=1000,
h_color="#000000", filename="emulator.png")



