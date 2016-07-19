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

## ----message=FALSE,myCode=TRUE-------------------------------------------
require(survival)
data(colon)
attach(colon)
#생존분석을 위한 Surv() 함수의 결과를 colon$TS에 저장한다. 
colon$TS = Surv(time,status==1)  # TS ; Time Status의 약자로 임의로 정했다.

## ----myCode=TRUE---------------------------------------------------------
out1=coxph(TS~rx,data=colon)
summary(out1)

## ------------------------------------------------------------------------
require(moonBook)
out=mycph(TS~.,data=colon)
out

## ----eval=FALSE----------------------------------------------------------
## mycph=function(formula,data,digits=2){
##     call=paste(deparse(formula),", ","data= ",substitute(data),sep="")
##     f=formula
##     myt=terms(f,data=data)
##     y=as.character(f[[2]])
##     # formula의 앞부분이 Surv 클래스가 아니면 중단한다.
##     if(class(data[[y]])!="Surv") {
##         cat(y, "is not a object of class Surv")
##         return(invisible())
##     }
##     myvar=attr(myt,"term.labels")   # 열 이름을 myvar에 저장
##     count=length(myvar)             # 열의 갯수를 count에 저장
##     ...
##     ...
## }

## ----eval=FALSE----------------------------------------------------------
##     ...
##     # 변수 이름, HR, 신뢰구간 저장할 변수를 초기화
##     var<-HR<-lcl<-ucl<-p.value<-c()
##     # 변수의 개수만큼 반복한다.
##     for(i in 1:count) {
##         s=paste(y,myvar[i],sep="~")   #(1)
##         suppressWarnings(out<-summary(coxph(as.formula(s),data)))  #(2)
##         if(any(is.infinite(out$conf.int))){
##             cat(dimnames(out$conf.int)[[1]]," was excluded : infinite\n")
##             next
##         }  # (3) 신뢰구간이 무한대로 나오는 경우 다음 변수로 진행
##         if(any(is.nan(out$coef))){
##             cat(dimnames(out$conf.int)[[1]]," was excluded : NaN\n")
##             next
##         }  # (4) p값이 NaN인 경우 다음 변수로 진행한다.
##         var=c(var,dimnames(out$conf.int)[[1]])   # 변수 이름 저장(5)
##         HR=c(HR,out$coef[,2])                    # HR 저장
##         lcl=c(lcl,out$conf.int[,3])              # lcl저장
##         ucl=c(ucl,out$conf.int[,4])              # ucl 저장
##         p.value=c(p.value,out$coef[,5])          # p 값 저장
##     }
##     ...

## ----eval=FALSE----------------------------------------------------------
##     if(length(HR)<1) return(invisible())                #(1)
##     result=round(data.frame(HR,lcl,ucl),digits)         #(2)
##     rownames(result)=var
##     result=cbind(result,round(p.value,max(3,digits)))   #(3)
##     colnames(result)[4]="p"
##     result   #결과 반환

## ----eval=FALSE----------------------------------------------------------
## mycph=function(formula,data,digits=2){
##     call=paste(deparse(formula),", ","data= ",substitute(data),sep="")
##     cat("\n mycph : perform coxph of individual expecting variables\n")
##     cat("\n Call:",call,"\n\n")
##     f=formula
##     myt=terms(f,data=data)
##     y=as.character(f[[2]])
##     if(class(data[[y]])!="Surv") {
##         cat(y, "is not a object of class Surv")
##         return(invisible())
##     }
##     myvar=attr(myt,"term.labels")
##     count=length(myvar)
##     var<-HR<-lcl<-ucl<-p.value<-c()
##     for(i in 1:count) {
##         s=paste(y,myvar[i],sep="~")
##         suppressWarnings(out<-summary(coxph(as.formula(s),data)))
##         if(any(is.infinite(out$conf.int))){
##             cat(dimnames(out$conf.int)[[1]]," was excluded : infinite\n")
##             next
##         }
##         if(any(is.nan(out$coef))){
##             cat(dimnames(out$conf.int)[[1]]," was excluded : NaN\n")
##             next
##         }
##         var=c(var,dimnames(out$conf.int)[[1]])
##         HR=c(HR,out$coef[,2])
##         lcl=c(lcl,out$conf.int[,3])
##         ucl=c(ucl,out$conf.int[,4])
##         p.value=c(p.value,out$coef[,5])
##     }
##     if(length(HR)<1) return(invisible())
##     result=round(data.frame(HR,lcl,ucl),digits)
##     rownames(result)=var
##     result=cbind(result,round(p.value,max(3,digits)))
##     colnames(result)[4]="p"
##     result
## }

