## ----include=FALSE,cache=FALSE-------------------------------------------
library(knitr)

opts_chunk$set(comment=NA, myCode=TRUE)
opts_template$set(myFig=list(fig.height=6,fig.width=6))
knit_hooks$set(
    myCode=function(before,options,envir){
        if(before){
            "\\footnotesize \\color{blue}"
        } else{
            "\\normalsize \\color{black}"
        }
    })

## ------------------------------------------------------------------------
states <- as.data.frame(state.x77[,c("Murder", "Population",
                             "Illiteracy", "Income", "Frost")])
fit=lm(Murder~Population+Illiteracy+Income+Frost,data=states)
summary(fit)

## ------------------------------------------------------------------------
confint(fit)

## ----fig.height=5.5------------------------------------------------------
fit <- lm(weight~height,data=women)
fit
plot(weight~height,data=women)
abline(fit,col="red")
title(expression(italic(weight==3.45%*%height-87.52)))

## ----fig.height=7,fig.show='hold'----------------------------------------
par(mfrow=c(2,2))
plot(fit)
par(mfrow=c(1,1))

## ----fig.height=6.5,fig.show='hold'--------------------------------------
fit2=lm(weight~height+I(height^2),data=women)
par(mfrow=c(2,2))
plot(fit2)
par(mfrow=c(1,1))

## ----eval=FALSE----------------------------------------------------------
## newfit <- lm(weight~ height + I(height^2), data=women[-c(13,15),])

## ----fig.height=6.5,fig.show='hold'--------------------------------------
states <- as.data.frame(state.x77[,c("Murder", "Population",
                             "Illiteracy", "Income", "Frost")])
fit=lm(Murder~Population+Illiteracy+Income+Frost,data=states)
par(mfrow=c(2,2))
plot(fit)
par(mfrow=c(1,1))

## ------------------------------------------------------------------------
require(car)
vif(fit)
sqrt(vif(fit))>2

## ------------------------------------------------------------------------
car::outlierTest(fit)

## ----eval=FALSE----------------------------------------------------------
## hat.plot <- function(fit) {
##      p <- length(coefficients(fit))
##      n <- length(fitted(fit))
##      plot(hatvalues(fit), main="Index Plot of Hat Values")
##      abline(h=c(2,3)*p/n, col="red", lty=2)
##      identify(1:n, hatvalues(fit), names(hatvalues(fit)))
## }
## hat.plot(fit)

## ------------------------------------------------------------------------
cutoff <- 4/(nrow(states)-length(fit$coefficients)-2)
plot(fit, which=4, cook.levels=cutoff)
abline(h=cutoff, lty=2, col="red")

## ----eval=FALSE----------------------------------------------------------
## car::avPlots(fit,ask=FALSE,id.method="identify")

## ----eval=FALSE----------------------------------------------------------
## car::influencePlot(fit, id.method="identify", main="Influence Plot",
##                  sub="Circle size is proportional to Cook’s distance")

## ------------------------------------------------------------------------
summary(car::powerTransform(states$Murder))

## ------------------------------------------------------------------------
car::boxTidwell(Murder~Population+Illiteracy,data=states)

## ------------------------------------------------------------------------
car::ncvTest(fit)
car::spreadLevelPlot(fit)

## ------------------------------------------------------------------------
states <- as.data.frame(state.x77[,c("Murder", "Population",
                                 "Illiteracy", "Income", "Frost")])
fit1 <- lm(Murder ~ . ,data=states)
summary(fit1)

## ------------------------------------------------------------------------
fit2 <- lm(Murder ~ Population + Illiteracy, data=states)
summary(fit2)

## ------------------------------------------------------------------------
anova(fit2, fit1)

## ------------------------------------------------------------------------
AIC(fit1,fit2)

## ------------------------------------------------------------------------
full.model=lm(Murder~.,data=states)
reduced.model=step(full.model,direction="backward")

## ------------------------------------------------------------------------
summary(reduced.model)

## ------------------------------------------------------------------------
min.model=lm(Murder~1,data=states)

## ------------------------------------------------------------------------
fwd.model=step(min.model,direction="forward",
               scope=(Murder~Population+Illiteracy+Income+Frost),trace=0)
summary(fwd.model)

## ----eval=FALSE----------------------------------------------------------
## full.model=lm(y~(x1+x2+x3+x4)^4)     # all-possible interaction
## reduced.model=step(full.model,direction=”backward”)

## ----fig.height=6.5,message=FALSE----------------------------------------
require(leaps)
states <- as.data.frame(state.x77[,c("Murder", "Population",
            "Illiteracy", "Income", "Frost")])
leaps <-regsubsets(Murder ~ Population + Illiteracy + Income +
                      Frost, data=states, nbest=4)
plot(leaps, scale="adjr2")

## ----eval=FALSE----------------------------------------------------------
## require(car)
## subsets(leaps, statistic="cp",main="Cp Plot for All Subsets Regression")
## abline(1,1,lty=2,col="red")

## ------------------------------------------------------------------------
shrinkage <- function(fit, k=10){ 
  require(bootstrap)
                                  
  theta.fit <- function(x,y){lsfit(x,y)} 
  theta.predict <- function(fit,x){cbind(1,x)%*%fit$coef}
  
  x <- fit$model[,2:ncol(fit$model)] 
  y <- fit$model[,1]
                                  
  results <- crossval(x, y, theta.fit, theta.predict, ngroup=k) 
  r2 <- cor(y, fit$fitted.values)^2 
  r2cv <- cor(y, results$cv.fit)^2 
  cat("Original R-square =", r2, "\n")
  cat(k, "Fold Cross-Validated R-square =", r2cv, "\n") 
  cat("Change =", r2-r2cv, "\n")
}

## ------------------------------------------------------------------------
fit1=lm(Murder~.,data=states)
shrinkage(fit1)

## ------------------------------------------------------------------------
fit2=lm(Murder~Population+Illiteracy,data=states)
shrinkage(fit2)

## ------------------------------------------------------------------------
states <- as.data.frame(state.x77[,c("Murder", "Population",
                                 "Illiteracy", "Income", "Frost")])
zstates <- as.data.frame(scale(states))
zfit <- lm(Murder~Population + Income + Illiteracy + Frost, data=zstates)
coef(zfit)

## ------------------------------------------------------------------------
relweights <- function(fit,...){
         R <- cor(fit$model)
         nvar <- ncol(R)
         rxx <- R[2:nvar, 2:nvar]
         rxy <- R[2:nvar, 1]
         svd <- eigen(rxx)
         evec <- svd$vectors
         ev <- svd$values
         delta <- diag(sqrt(ev))
         lambda <- evec %*% delta %*% t(evec)
         lambdasq <- lambda ^ 2
         beta <- solve(lambda) %*% rxy
         rsquare <- colSums(beta ^ 2)
         rawwgt <- lambdasq %*% beta ^ 2
         import <- (rawwgt / rsquare) * 100
         import <- as.data.frame(import)
         row.names(import) <- names(fit$model[2:nvar])
         names(import) <- "Weights"
         import <- import[order(import),1, drop=FALSE]
         dotchart(import$Weights, labels=row.names(import),
            xlab="% of R-Square", pch=19,
            main="Relative Importance of Predictor Variables",
            sub=paste("Total R-Square=", round(rsquare, digits=3)),
            ...)
         return(import)
}

## ------------------------------------------------------------------------
states <- as.data.frame(state.x77[,c("Murder", "Population",
                "Illiteracy", "Income", "Frost")])
fit <- lm(Murder ~ Population + Illiteracy + Income + Frost, data=states)
relweights(fit, col="blue")

