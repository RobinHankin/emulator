ht <- function(x){  #Hermitian transpose
 if(is.complex(x)){
    return(t(Conj(x)))
 } else {
    return(t(x))
 }
}

"cprod" <- function(x,y=NULL){
 if(is.complex(x) | is.complex(y)){
    if(is.null(y)){
     return(crossprod(Conj(x),x))
    } else {
     return(crossprod(Conj(x),y))
    }
 } else {
    return(crossprod(x,y))
 }
}

"tcprod" <- function(x,y=NULL){
 if(is.complex(x) | is.complex(y)){
    if(is.null(y)){
     return(tcrossprod(x,Conj(x)))
    } else {
     return(tcrossprod(x,Conj(y)))
    }
 } else {
    return(tcrossprod(x,y))
 }
}

"quad.form" <-  # x' M x
function (M, x, chol = FALSE)
{
    if (chol == FALSE) {
       return(drop(crossprod(crossprod(M,Conj(x)),x)))
    }
    else {
       jj <- cprod(M, x)
       return(drop(cprod(jj, jj)))
    }
}

"quad.form.inv" <-  # x' M^-1 x
function (M, x)
{
    drop(cprod(x, solve(M, x)))
}

"quad.3form" <-  # left' M right
function(M,left,right)
{
    crossprod(crossprod(M,Conj(left)),right)
}  

"quad.3tform" <- function(M,left,right)   # left M right'
{
  tcrossprod(left,tcrossprod(Conj(right),M))
}

"quad.tform" <- # x M x'
function(M,x)
{  
  tcrossprod(x,tcrossprod(Conj(x),M))
}

"quad.tform.inv" <-  # x M^-1 x'
function(M,x){
 drop(quad.form.inv(M,ht(x)))
}

"quad.diag" <-   # diag(quad.form(M,x)) == diag(x' M x)
function(M,x){   
  colSums(crossprod(M,Conj(x)) * x)
}

"quad.tdiag" <-  # diag(quad.tform(M,x)) == diag(x M x')
function(M,x){   
  rowSums(tcrossprod(Conj(x), M) * x)
}

"quad.3diag" <- function(M,left,right){
  colSums(crossprod(M, Conj(left)) * right)
}

"quad.3tdiag" <- function(M,left,right){
  colSums(t(left) * tcprod(M, right))
}

#"cmahal" <- 
#    function (z, center, cov, inverted = FALSE, ...) 
#{
#    if(is.vector(z)){
#        z <- matrix(z, ncol = length(z))
#    } else {
#        z <- as.matrix(x)
#    }
#    
#    if (!inverted) { cov <- solve(cov, ...)}
#    quad.diag(cov,sweep(z, 2, center))
#}

