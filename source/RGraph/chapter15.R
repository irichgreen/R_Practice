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
dose=c(1,1,2,2,3,3)
response=c(0,1,0,1,0,1)
count=c(7,3,5,5,2,8)
toxic=data.frame(dose,response,count)
toxic

## ------------------------------------------------------------------------
out=glm(response~dose,weights=count,family=binomial,data=toxic)
summary(out)

## ------------------------------------------------------------------------
exp(coef(out))
exp(confint(out))

## ----fig.height=6--------------------------------------------------------
plot(response~dose,data=toxic,type="n",main="Predicted Probability of Response")
curve(predict(out,data.frame(dose=x),type="resp"),add=TRUE)

## ----fig.height=6--------------------------------------------------------
plot(response~dose,data=toxic,type="n",main="Predicted Probability of Response")
curve(predict(out,data.frame(dose=x),type="resp"),add=TRUE)
curve(
predict(out,data.frame(dose=x),type="resp", se.fit=TRUE)$fit + 
predict(out,data.frame(dose=x),type="resp", se.fit=TRUE)$se.fit * 1.96, 
add=TRUE, col="blue", lty=2)
curve(
predict(out,data.frame(dose=x),type="resp", se.fit=TRUE)$fit - 
predict(out,data.frame(dose=x),type="resp", se.fit=TRUE)$se.fit * 1.96, 
add=TRUE, col="blue", lty=2)

## ------------------------------------------------------------------------
require(survival)
str(colon)

## ------------------------------------------------------------------------
colon1<-na.omit(colon)
result<-glm(status~rx+sex+age+obstruct+perfor+adhere+nodes+differ+
                extent+surg,family=binomial,data=colon1)
summary(result)

## ------------------------------------------------------------------------
reduced.model=step(result)

## ------------------------------------------------------------------------
summary(reduced.model)

## ----eval=FALSE----------------------------------------------------------
## extractOR=function(x,digits=2){
##     suppressMessages(a<-confint(x))
##     result=data.frame(exp(coef(x)),exp(a))
##     result=round(result,digits)
##     result=cbind(result,round(summary(x)$coefficient[,4],3))
##     colnames(result)=c("OR","2.5%","97.5%","p")
##     result
## }

## ------------------------------------------------------------------------
require(moonBook)
extractOR(reduced.model)

## ------------------------------------------------------------------------
fit=glm(formula = status ~ rx + obstruct + adhere + nodes + extent + 
    surg, family = binomial, data = colon1)
fit.od=glm(formula = status ~ rx + obstruct + adhere + nodes + extent + 
    surg, family = quasibinomial, data = colon1)
pchisq(summary(fit.od)$dispersion*fit$df.residual,
       fit$df.residual,lower=F)

## ----fig.height=6,fig.with=6---------------------------------------------
ORplot(reduced.model, main="Plot for Odds Ratios of Reduced Model") 

## ----fig.height=6,fig.with=6---------------------------------------------
ORplot(reduced.model,type=2,show.OR=FALSE,show.CI=TRUE,pch=15,lwd=3,
       col=c("blue","red"),main="Plot for Odds Ratios; type=2, show.CI=TRUE") 

## ----fig.height=6,fig.with=6---------------------------------------------
ORplot(reduced.model,type=3,main="Bar Plot for ORs with type=3")

## ----fig.height=6,fig.with=6---------------------------------------------
ORplot(reduced.model,type=3,show.CI=TRUE,main="Bar plot for ORs with 95% CI")

## ------------------------------------------------------------------------
data(breslow.dat,package="robust")
summary(breslow.dat[c(6,7,8,10)])

## ----fig.show='hold'-----------------------------------------------------
par(mfrow=c(1,2))
attach(breslow.dat)
hist(sumY,breaks=20,freq=FALSE,col="salmon",main="Distribution of seizures")
lines(density(sumY),col="blue",lwd=2)
plot(sumY~Trt,main="Group Comparison")
par(mfrow=c(1,1))

## ------------------------------------------------------------------------
out=glm(sumY~Base+Age+Trt,family=poisson,data=breslow.dat)
summary(out)

## ------------------------------------------------------------------------
extractOR(out,digits=3)
ORplot(out,type=3,show.OR=FALSE,show.CI=TRUE,main="Result of Poisson Regression")

## ----message=FALSE-------------------------------------------------------
#install.packages("qcc")
require(qcc)
qcc.overdispersion.test(breslow.dat$sumY,type="poisson")

## ------------------------------------------------------------------------
fit=glm(sumY~Base+Age+Trt,family=quasipoisson,data=breslow.dat)
summary(fit)

## ------------------------------------------------------------------------
extractOR(fit,digits=3)
ORplot(fit,type=2,show.CI=TRUE,main="Result of Quasipoisson Regression")

