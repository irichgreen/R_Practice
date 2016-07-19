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

## ----message=FALSE-------------------------------------------------------
require(moonBook)
data(acs)
acs$smoking=factor(acs$smoking,levels=c("Never","Ex-smoker","Smoker"))
plot(age~smoking,data=acs,color=c("red","green","blue"))

## ------------------------------------------------------------------------
densityplot(age~smoking,data=acs)

## ------------------------------------------------------------------------
out1=lm(age~smoking,data=acs)
anova(out1)
summary(out1)

## ------------------------------------------------------------------------
out2=lm(age~smoking+BMI,data=acs)
summary(out2)

## ----fig.height=6--------------------------------------------------------
colors=rainbow(acs$smoking)
colors=colors[c(3,2,1)]
plot(age~BMI,col=colors,data=acs)
legend("topright",legend=levels(acs$smoking),pch=1,col=colors,lty=1)
curve(85.077-0.767*x,col=colors[1],add=TRUE)
curve(85.077-0.767*x-1.130,col=colors[2],add=TRUE)
curve(85.077-0.767*x-8.074,col=colors[3],add=TRUE)

## ----message=FALSE-------------------------------------------------------
require(multcomp)
tukey=glht(out2,linfct=mcp(smoking="Tukey"))
summary(tukey)

## ------------------------------------------------------------------------
data(radial)

## ------------------------------------------------------------------------
out=lm(NTAV~age,data=radial)
summary(out)

## ----fig.height=6--------------------------------------------------------
plot(NTAV~age,data=radial,col=ifelse(radial$sex=="M","blue","red"))
abline(out,col="red",lwd=2)
title(expression(italic(NTAV==0.385%*%Age +44.34)),family="Times")

## ------------------------------------------------------------------------
out1=lm(NTAV~age-1,data=radial)
summary(out1)

## ----fig.height=6--------------------------------------------------------
plot(NTAV~age,data=radial,col=ifelse(radial$sex=="M","blue","red"))
abline(out1,col="red",lwd=2)
title(expression(italic(NTAV==1.065%*%Age)),family="Times")

## ----fig.height=6,fig.show='hold'----------------------------------------
par(mfrow=c(2,2))
plot(out1)
par(mfrow=c(1,1))

## ------------------------------------------------------------------------
hist(radial$NTAV)

## ----fig.height=7,fig.width=7,fig.show='hold'----------------------------
par(mfrow=c(1,2))
plot(sqrt(NTAV)~age,data=radial,main="sqrt transformation")
plot(log(NTAV)~age,data=radial,main="Log transformation")
par(mfrow=c(1,1))

## ------------------------------------------------------------------------
summary(car::powerTransform(radial$NTAV))

## ------------------------------------------------------------------------
out2=lm(log(NTAV)~(age-1)+male,data=radial)
summary(out2)
shapiro.test(resid(out2))

## ----fig.height=6--------------------------------------------------------
plot(log(NTAV)~age,data=radial,col=ifelse(radial$sex=="M","blue","red"))
curve(0.0594*x,col="red",lty=2,add=TRUE)
curve(0.0594*x+0.656,col="blue",lty=1,add=TRUE)
legend("topleft",legend=c("Male","Female"),col=c("blue","red"),pch=1,lty=1:2)

## ----fig.height=7--------------------------------------------------------
plot(NTAV~age,data=radial,col=ifelse(radial$sex=="M","blue","red"))
curve(exp(0.0594*x),col="red",lty=2,add=TRUE)
curve(exp(0.0594*x+0.656),col="blue",add=TRUE)
title(expression(NTAV==e^(0.0594%*%age+0.656%*%male)),family="Times")
legend(36,170,legend=c("Male","Female"),col=c("blue","red"),pch=1,lty=1:2)

## ----fig.height=7,echo=FALSE---------------------------------------------
plot(NTAV~age,data=radial,col=ifelse(radial$sex=="M","blue","red"),
     pch=as.character(sex))
curve(exp(0.0594*x),col="red",lty=2,add=TRUE)
curve(exp(0.0594*x+0.656),col="blue",add=TRUE)
title(expression(NTAV==e^(0.0594%*%age+0.656%*%male)),family="Times")
legend(36,170,legend=c("Male","Female"),col=c("blue","red"),pch=c("M","F"),lty=1:2)

## ----eval=FALSE----------------------------------------------------------
## plot(NTAV~age,data=radial,col=ifelse(radial$sex=="M","blue","red"),
##      pch=as.character(sex))
## curve(exp(0.0594*x),col="red",lty=2,add=TRUE)
## curve(exp(0.0594*x+0.656),col="blue",add=TRUE)
## title(expression(NTAV==e^(0.0594%*%age+0.656%*%male)),family="Times")
## legend(36,170,legend=c("Male","Female"),col=c("blue","red"),
##        pch=c("M","F"),lty=1:2)

