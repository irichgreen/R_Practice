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

## ----eval=FALSE----------------------------------------------------------
## install.packages("UsingR")

## ----message=FALSE-------------------------------------------------------
require(UsingR)
data(galton) ; str(galton)

## ----fig.show='hold'-----------------------------------------------------
par(mfrow=c(1,2))
hist(galton$child,col="blue",breaks=100)
hist(galton$parent,col="blue",breaks=100)
par(mfrow=c(1,1))

## ------------------------------------------------------------------------
cor.test(galton$child,galton$parent)

## ------------------------------------------------------------------------
xtabs(~child+parent,data=galton)

## ------------------------------------------------------------------------
out=lm(child~parent,data=galton)
summary(out)

## ------------------------------------------------------------------------
plot(child~parent,data=galton)
abline(out,col="red")

## ------------------------------------------------------------------------
women

## ------------------------------------------------------------------------
fit <- lm(weight~height,data=women)
summary(fit)

## ------------------------------------------------------------------------
cor.test(women$weight,women$height)
0.9955^2

## ------------------------------------------------------------------------
plot(weight~height,data=women)
abline(fit,col="blue")

## ------------------------------------------------------------------------
fit2=lm(weight~height+I(height^2),data=women)
summary(fit2)

## ------------------------------------------------------------------------
plot(weight~height,data=women)
lines(women$height,fitted(fit2),col="red")

## ------------------------------------------------------------------------
fit3 <- lm(weight ~ height + I(height^2) +I(height^3), data=women)

## ------------------------------------------------------------------------
require(car)
scatterplot(weight~height,data=women)

## ------------------------------------------------------------------------
scatterplot(weight~height,data=women,pch=19,
            spread=FALSE,smoother.args=list(lty=2),
            main="Women Age 30-39",
            xlab="Height(inches)",ylab="Weight(lbs.)")

## ------------------------------------------------------------------------
require(MASS)
tail(birthwt)
str(birthwt)

## ------------------------------------------------------------------------
out=lm(bwt~ age+lwt+factor(race)+smoke+ptl+ht+ui,data=birthwt)
anova(out)

## ------------------------------------------------------------------------
out2=lm(bwt~ lwt+factor(race)+smoke+ht+ui,data=birthwt)
anova(out2,out)

## ------------------------------------------------------------------------
anova(out2)

## ------------------------------------------------------------------------
data(mtcars)
fit=lm(mpg~hp*wt,data=mtcars)

## ------------------------------------------------------------------------
summary(fit)

## ------------------------------------------------------------------------
plot(mpg~hp,data=mtcars,main="Interaction of hp:wt")
curve(31.41-0.06*x,add=TRUE)
curve(23.37-0.03*x,add=TRUE,lty=2,col=2)
curve(15.33-0.003*x,add=TRUE,lty=3,col=3)
legend("topright",c("2.2","3.2","4.2"),title="wt",lty=1:3,col=1:3)

