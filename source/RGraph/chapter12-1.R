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
#install.packages("SwissAir")     # 패키지 설치-한 번만 실행하면 된다.
require(SwissAir)
data(AirQual)
str(AirQual)

## ------------------------------------------------------------------------
Ox <- AirQual[,c("ad.O3","lu.O3","sz.O3")]+
    AirQual[,c("ad.NOx","lu.NOx","sz.NOx")]-
      AirQual[,c("ad.NO","lu.NO","sz.NO")]
names(Ox) <- c("ad","lu","sz")

## ----fig.height=6--------------------------------------------------------
plot(lu~sz,data=Ox)

## ----fig.height=7,message=FALSE------------------------------------------
#install.packages("hexbin")  # 패키지 설치-한번만 실행하면 된다.
require(hexbin)              # hexbin 패키지를 이용한다.  
bin=hexbin(Ox$lu,Ox$sz,xbins=50)
plot(bin,main="Hexagonal binning ")


## ----fig.height=7--------------------------------------------------------
smoothScatter(Ox$lu,Ox$sz,main="Scatterplot by Smoothed Densities")

## ----fig.height=7--------------------------------------------------------
Lab.palette <- colorRampPalette(c("blue", "orange", "red"), space = "Lab")
smoothScatter(Ox$lu,Ox$sz, colramp = Lab.palette)

## ----fig.height=7,message=FALSE------------------------------------------
#install.packages("IDPmisc")   # 패키지 설치-한 번만 실행하면 된다.
require(IDPmisc)              # hexbin 패키지를 이용한다.  
iplot(Ox$lu,Ox$sz, xlab="Schwyz",ylab="Lucerne",
      main="Image Scatter Plot with Color Indicating Density")

## ----fig.height=7,fig.width=7--------------------------------------------
ipairs(Ox)

## ----fig.height=7,fig.width=7--------------------------------------------
ilagplot(Ox$ad,set.lags = 1:9,
           ztransf=function(x){x[x<1] <- 1; log2(x)})

