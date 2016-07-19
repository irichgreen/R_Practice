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
#install.packages("survival") 패키지를 설치하지 않은 경우 한 번만 실행
require(survival)

## ------------------------------------------------------------------------
data(colon)
attach(colon)
str(colon)

## ------------------------------------------------------------------------
fit = survfit(Surv(time,status==1)~1, data=colon)
fit

## ----eval=FALSE----------------------------------------------------------
## summary(fit)

## ------------------------------------------------------------------------
plot(fit)

## ----fig.height=6--------------------------------------------------------
plot(fit, conf.int=FALSE)

## ----fig.height=6--------------------------------------------------------
fit1 = survfit(Surv(time,status==1)~rx, data=colon)
plot(fit1,col=1:3, lty=1:3)
legend("topright",legend=levels(rx),col=1:3, lty=1:3)

## ----fig.height=6--------------------------------------------------------
plot(fit1,col=1:3, lty=1:3,mark.time=FALSE)
legend("topright",legend=levels(rx),col=1:3, lty=1:3)

## ----fig.height=6--------------------------------------------------------
plot(fit1,col=1:3, lty=1:3,fun="cumhaz",mark.time=FALSE,
     ylab="Cumulative hazard",xlab="Days")
legend("topleft",legend=levels(rx),col=1:3, lty=1:3)

## ------------------------------------------------------------------------
survdiff(Surv(time,status==1)~rx, data=colon)

## ------------------------------------------------------------------------
out=coxph(Surv(time,status==1)~rx,data=colon)
out

## ------------------------------------------------------------------------
summary(out)

## ----message=FALSE,fig.height=6------------------------------------------
#install.packages("GGally") 패키지를 설치하지 않은 경우 한 번만 실행
require(GGally)
fit = survfit(Surv(time,status)~rx, data=colon)
fit
ggsurv(fit)  #plot(fit) 대신 사용

## ----fig.height=6--------------------------------------------------------
ggsurv(fit,plot.cens=FALSE) # censored data mark 없앰

## ----eval=FALSE----------------------------------------------------------
## install.packages(c("ggplot2","plyr")) # 처음 한번만 실행

## ----message=FALSE,fig.height=5------------------------------------------
data(colon)
fit = survfit(Surv(time,status)~rx, data=colon)
plot(fit, xlab="Time", ylab="Survival Probability", main="Kaplan-Meier plot")

## ----eval=FALSE----------------------------------------------------------
## require(ggplot2)
## require(plyr)
## #다운받은 함수를 불러들인다.현재 작업디렉토리에 ggkm.R파일이 있어야 한다.
## source("ggkm.R")
## ggkm(fit, timeby=500)

## ----eval=FALSE----------------------------------------------------------
## p = ggkm(fit, timeby=500, return=TRUE)
## ggsave("Survival Analysis - Kaplan Meier plot.png", p)

## ----eval=FALSE----------------------------------------------------------
## fit = survfit(Surv(time,status)~1, data=colon)
## p = ggkm(fit, timeby=500, return=TRUE, legend=FALSE, marks=T)

## ----message=FALSE-------------------------------------------------------
#install.packages("rms") 패키지를 설치하지 않은 경우 한 번만 실행
require(rms)
S=Surv(time,status==1)
f=npsurv(S~rx)
survplot(f,xlab="Days")

## ------------------------------------------------------------------------
survplot(f,conf="none",xlab="Days",col=3:1)

## ------------------------------------------------------------------------
survplot(f,conf="none",label.curve=FALSE,label.curves=list(keys="lines"),
         xlab="",col=3:1)

## ------------------------------------------------------------------------
survplot(f,conf="none",n.risk=TRUE,col=3:1,,xlab="")

## ------------------------------------------------------------------------
survplot(f,conf="none",n.risk=TRUE,y.n.risk=-0.25,cex.n.risk=0.6,
         col=3:1,,xlab="")

## ------------------------------------------------------------------------
data(colon)
#생존분석을 위한 Surv()함수의 결과를 colon$TS에 저장한다.
colon$TS = Surv(time,status==1) 
out=coxph(TS~rx,data=colon)
out

## ------------------------------------------------------------------------
summary(out)

## ------------------------------------------------------------------------
require(moonBook)
out=mycph(TS~.-id-study-time-status-etype,data=colon)
out

## ----fig.height=7--------------------------------------------------------
HRplot(out,type=2,show.CI=TRUE,
       main="Hazard ratios of all individual variables")

## ----fig.height=7--------------------------------------------------------
HRplot(out,type=3,show.CI=TRUE,sig.level=0.05,
       main="Hazard ratios of significant variables")

## ----fig.height=7--------------------------------------------------------
out2=coxph(TS~.,data=colon)
HRplot(out2,show.CI=TRUE,main="Cox Model with All Variables")

## ------------------------------------------------------------------------
colon1=na.omit(colon) #결측치 제거

## ------------------------------------------------------------------------
out=coxph(TS~.-id-study-time-status-etype-nodes,data=colon1)

## ------------------------------------------------------------------------
final=step(out,direction="backward")                
summary(final)

## ----fig.height=7--------------------------------------------------------
HRplot(final,type=3,show.CI=TRUE,
       main="Final Model Selected by Backward Elimination")
detach(colon) #colon데이터를 메모리에서 삭제한다.

## ------------------------------------------------------------------------
require(survival)
require(rms)
data(lung)
# Prepare the variables
lung$sex <- factor(lung$sex, levels=1:2, labels=c("Male", "Female"))

## ------------------------------------------------------------------------
# prepare for survival analysis
TS <- with(lung, Surv(time,status))

## ------------------------------------------------------------------------
# The rms survival
ddist <- datadist(lung)
options(datadist="ddist")

## ----fig.show='hold'-----------------------------------------------------
fit = coxph(TS ~ rcs(age, 4)+sex, lung, x=T, y=T)
# The plot.summary.rms
par(mfrow=c(1,2))
termplot(fit, se=T, rug=T,ylab=rep("Hazard Ratio", times=2),
          main=rep("cph() plot", times=2),
          col.se=rgb(.2,.2,1,.4), col.term="black")
par(mfrow=c(1,1))

## ----echo=FALSE----------------------------------------------------------
source("termplot2.R")

## ----eval=FALSE----------------------------------------------------------
## par(mfrow=c(1,2))
## termplot2(fit, se=T, rug.type="density", rug=T, density.proportion=.05,
##          se.type="polygon",
##          ylab=rep("Hazard Ratio", times=2),
##          main=rep("cph() plot", times=2),
##          col.se=rgb(.2,.2,1,.4), col.term="black")
## par(mfrow=c(1,1))

## ----eval=FALSE----------------------------------------------------------
## fit1 <- cph(TS~rcs(age, 4)+sex, data=lung, x=T, y=T)
## fit1
## result=Predict(fit1, age, sex, fun=exp)
## plot(result)

## ----eval=FALSE----------------------------------------------------------
## plot(result, ~ age | sex)

