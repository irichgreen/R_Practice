#  Copyright 2015 Guido Masarotto (University of Padova) and Cristiano Varin
#  (Ca’ Foscari University).
#  Permission to use, copy, modify and distribute this software and
#  its documentation, for any purpose and without fee, is hereby granted,
#  provided that:
#  1) this copyright notice appears in all copies and
#  2) the source is acknowledged through a citation to the paper
#     Masarotto G. and Varin C. (2012). The ranking lasso and its application
#     to sport tournaments. The Annals of Applied Statistics 6 (4), 1949-1970. 
#  The Authors make no representation about the suitability of this software
#  for any purpose.  It is provided "as is", without express or implied warranty.
 
 require(Matrix)

ranking.lasso <- function(y, X, adaptive=TRUE, refit=FALSE, wt=rep(1, NROW(y))){

  ## (minus) log likelihood
  llik <- function(beta){
    eta <- X%*%beta
    -sum( ( y[,1]*eta-(y[,1]+y[,2])*log(1+exp(eta)) )*wt )
  }
  ## score function
  gllik <- function(beta){
    eta <- X%*%beta
    mu <- plogis(as.vector(eta))
    -t(X)%*%( ( y[,1]-(y[,1]+y[,2])*mu )*wt )
  }
  ## ranking lasso design matrix
  Dmatrix <- rankingD(ncol(X)+1)
  fit <- glassomany(llik, gllik, Dmatrix, control=list(adaptive=adaptive))
  res <- glassomodlik(fit, llik, gllik, as.matrix(Dmatrix), refit=refit)

  return(res)
}

## Zhang-Zhou-Li (IMA J.Num.An., 2006) conjugate gradient method
.cg <- function(x, fn, gr, control=list()) {
    eps <- .Machine$double.eps
    o <- list(maxfn=10000, armijo=0.2, epsilon=1.0e-04, tol=sqrt(eps))
    lapply(names(control), function(n) o[[n]] <<- control[[n]])
    f <- fn(x)
    g <- gr(x)
    d <- -g
    v <- max(abs(g))
    ifn <- 1
    iter <- 0
    while ((ifn<o$maxfn) && (v>=o$tol)) {
        iter <- iter+1
        z <- abs(sum(d*((gr(x+o$epsilon*d)-g)/o$epsilon)))
        a <- if(!is.finite(z) || (z<eps)) 1 else abs(sum(g*d))/z
        fm <- f+eps*abs(f)
        done <- FALSE
        while (!done && (ifn<o$maxfn)) {
            xnew <- x+a*d
            fnew <- fn(xnew)
            done <- is.finite(fnew) && (fnew<fm)
            ifn <- ifn+1
            a <- o$armijo*a
        }
        if (!done) break
        x <- xnew
        f <- fnew
        y <- g
        g <- gr(x)
        y <- (g-y)/sum(y^2)
        d <- -g+sum(g*y)*d-sum(g*d)*y
        v <- max(abs(g))
    }
    list(x=x, fn=f, gr=g, counts=c(iter,ifn), tol=v, control=o)
}

soft.thresholding <- function(z,w,s) {
    if (s<.Machine$double.eps) return(rep(0,length(z)))
    a <- abs(z)
    if (sum(w*a)<s) return(z)
    lambda <- uniroot(function(l)sum(w*(a-l*w)*(a>l*w))-s,c(0,max(a/w)))$root
    sign(z)*pmax(0,a-lambda*w)
}

glasso1 <- function(beta, llik, gllik, D, s, w=1, control=list()) {
    l <- dim(D)[1]
    o <- list(psi=10, phi=rep(0,l), tol=1.0e-5, maxiter=1000,opt=list(maxfn=100))
    lapply(names(control),function(n) o[[n]] <<- control[[n]])
    o$opt$tol <- o$tol
    if (length(w)==1) w <- rep(w,l)
    z <- soft.thresholding(as.double(D%*%beta),w,s)
    iter <- 0
    counts <- 0
    while (iter<=o$maxiter) {
        iter <- iter+1
        g <- o$phi-z
        fn <- function(b) llik(b)+o$psi*sum((D%*%b+g)^2)/2
        gr <- function(b) as.double(gllik(b)+o$psi*crossprod(D,D%*%b+g))
        u <- .cg(beta,fn,gr,o$opt)
        beta <- u$x
        counts <- counts + (u$counts-counts)/iter
        r <- as.double(D%*%beta)
        z <- soft.thresholding(r+o$phi,w,s)
        r <- r-z
        vr <- max(abs(r))
        if ((vr<o$tol) && (u$tol<o$tol)) break
        o$phi <- o$phi + r
        o$psi <- max(10,o$phi^2)
    }
    list(beta=beta,tol=c(u$tol,vr),counts=c(iter,counts),control=o)
}


glassomany <- function(llik, gllik, D, s, w, bhat, control=list()) {
    eps <- .Machine$double.eps^(1/3)
    o <- list(adaptive=FALSE, ridge=eps)
    lapply(names(control),function(n) o[[n]] <<- control[[n]])
    p <- dim(D)[2]
    if (missing(bhat)) {
        fn <- function(b) llik(b)+o$ridge*sum(b*b)
        gr <- function(b) as.double(gllik(b)+o$ridge*b)
        ctrl <- if(is.null(control$opt)) list() else control$opt
        bhat <- .cg(rep(0,p),fn,gr,ctrl)$x
    }
    if (!missing(w)) {
        w <- w
    } else {
        if (o$adaptive)
            w <- 1/pmax(0.0001,abs(as.double(D%*%bhat)))
        else
            w <- 1
    }
    if (missing(s)) s <- seq(0.02, 0.98, by=0.02)
    s <- sort(s)
    beta <- matrix(0,length(s)+2,p)
    rownames(beta) <- c(0,s,"1")
    beta[length(s)+2,] <- bhat
    v <- sum(w*abs(D%*%bhat))
    a <- list(control=control)
    for (i in length(s):1) {
        a <- glasso1(beta[i+2,],llik,gllik,D,s[i]*v,w,a$control)
        beta[i+1,] <- a$beta
    }
    ndf <- function(beta) {
        u <- unique(beta)
        length(u[abs(u)>10*.Machine$double.eps])
    }
    beta <- 10*a$control$tol*round(beta/(10*a$control$tol))
    list(beta=beta, lik=apply(beta,1,llik), df=apply(beta,1,ndf),
         s=s, control=control)
}


glassomodlik <- function(obj, llik, gllik, D, control=list(), refit=FALSE) {
    o <- list(tiny=1.0e-4, big=1.0e4, opt=list(tol=1.0e-3))
    lapply(names(control),function(n) o[[n]] <<- control[[n]])
    nb <- dim(obj$beta)[1]
    bhat <- obj$beta[nb,]
    idxold <- rep(FALSE,dim(D)[1])
    for (i in (nb-1):2) {
        idx <- abs(D%*%obj$beta[i,])<o$tiny
        if (all(idx==idxold)) {
            obj$lik[i] <- obj$lik[i+1]
            if(refit)
              obj$beta[i,] <- obj$beta[i+1,]
        } else {
            Di <- D[idx,,drop=FALSE]
            fn <- function(b) llik(b)+o$big*sum((Di%*%b)^2)/2
            gr <- function(b) as.double(gllik(b)+o$big*crossprod(Di,Di%*%b))
            bhat<-.cg(bhat,fn,gr,o$opt)$x
            if(refit)
              obj$beta[i,] <- bhat
            obj$lik[i] <- llik(bhat)
        }
        idxold <- idx
    }
    obj
} 

rankingD <- function(n, sparse=(n>50)) {
    m <- choose(n,2)
    D <- if (sparse) Matrix(0,m,n-1) else matrix(0,m,n-1)
    indeces <- cbind(1:m, t(combn(1:n, 2))-1)
    D <- replace(D,indeces[indeces[,2]>0,c(1,2)],1)
    replace(D,indeces[,c(1,3)],-1)
}

lassoD <- function(n, sparse=(n>50)) {
    D <- if (sparse) Matrix(0,n,n) else matrix(0,n,n)
    replace(D, cbind(1:n,1:n), 1)
}


 
