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
knit_hooks$set(
    scriptsize=function(before,options,envir){
        if(before){
            "\\scriptsize \\color{blue}"
        } else{
            "\\normalsize \\color{black}"
        }
    })
knit_hooks$set(
    tiny=function(before,options,envir){
        if(before){
            "\\tiny \\color{blue}"
        } else{
            "\\normalsize \\color{black}"
        }
    })


## ----echo=FALSE, message=FALSE,results='asis'----------------------------
require(moonBook)
out=mytable(Dx~.,data=acs);mylatex(out,caption="Table 1. Descriptive Statistics by Final Diagnosis")

## ----echo=FALSE,warning=FALSE,results='asis'-----------------------------
out1=mytable(sex+DM~.-smoking,data=acs)
mylatex(out1,size=3,caption="Table 2. Descriptive Statistics stratified by sex and presence(Yes) or absence(No) of DM")

## ----eval=FALSE----------------------------------------------------------
## install.packages("moonBook") # 패키지를 이미 설치한 경우는 생략한다.

## ----message=FALSE-------------------------------------------------------
require(moonBook)   # 패키지를 이미 불러온 경우에는 생략한다.

## ------------------------------------------------------------------------
data(acs)

## ----comment=NA----------------------------------------------------------
str(acs)

## ------------------------------------------------------------------------
mytable(Dx~.,data=acs)

## ----comment=NA----------------------------------------------------------
mytable(sex~age+Dx,data=acs)

## ---- comment=NA---------------------------------------------------------
mytable(am~.-hp-disp-cyl-carb-gear,data=mtcars)

## ----comment=NA----------------------------------------------------------
data(radial)
mytable(sex~age+weight+TC+hsCRP,data=radial,method=3)

## ---- comment=NA,warning=FALSE-------------------------------------------
mytable(am~.,data=mtcars)

## ----comment=NA,warning=FALSE--------------------------------------------
mytable(am~carb,data=mtcars,max.ylev=6)

## ------------------------------------------------------------------------
mytable(sex+DM~.,data=acs)

## ----eval=FALSE----------------------------------------------------------
## mytable(sex+Dx~.,data=acs)

## ----comment=NA,echo=FALSE,warning=FALSE,scriptsize=TRUE-----------------
mytable(sex+Dx~.,data=acs)

## ----results='asis'------------------------------------------------------
out=mytable(Dx~.,data=acs);mylatex(out)

## ----eval=FALSE----------------------------------------------------------
## out1=mytable(sex+Dx~.-smoking,data=acs);mylatex(out1,size=4)

## ----echo=FALSE,warning=FALSE,results='asis'-----------------------------
out1=mytable(sex+Dx~.-smoking,data=acs)
mylatex(out1,size=4)

## ----results='asis'------------------------------------------------------
out=mytable(sex~age+Dx,data=acs)
for(i in 1:8) mylatex(out,size=i,caption=paste("Table ",i,". Fontsize=",i,sep=""))

## ------------------------------------------------------------------------
mycsv(out,file="test1.csv")
mycsv(mytable(sex+DM~age+Dx,data=acs),file="test2.csv")

## ----eval=FALSE----------------------------------------------------------
## out=mytable(sex~age+Dx,data=acs)
## myhtml(out)
## myhtml(mytable(sex+DM~age+Dx,data=acs))

## ------------------------------------------------------------------------
myhtml(out)

## ----echo=FALSE,comment=NA-----------------------------------------------
cat("```{r results='asis'}")

## ----eval=FALSE----------------------------------------------------------
## out=mytable(sex~age+Dx,data=acs)
## myhtml(out)
## myhtml(mytable(sex+DM~age+Dx,data=acs))

## ----echo=FALSE,comment=NA-----------------------------------------------
cat("```")

