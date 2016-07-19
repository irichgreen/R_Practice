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
head(acs)
str(acs)
summary(acs)

## ----myCode=TRUE---------------------------------------------------------
head(acs$BMI)
str(acs$BMI)
summary(acs$BMI)

## ----fig.width=4---------------------------------------------------------
fivenum(acs$BMI,na.rm=T)
quantile(acs$BMI,na.rm=T)

## ----fig.width=4---------------------------------------------------------
hist(acs$BMI)

## ------------------------------------------------------------------------
hist(acs$BMI,breaks=20,col="red",main="Distribution of Body Mass Index(BMI)",
     xlab=expression(BMI(kg/m^2)))

## ------------------------------------------------------------------------
hist(acs$BMI,freq=FALSE,breaks=20,col="salmon",
     main="Histogram, Rug Plot and Density Curve",xlab=expression(BMI(kg/m^2)))
rug(acs$BMI)
lines(density(acs$BMI,na.rm=TRUE),col="blue",lwd=2)

## ----fig.show='hold',fig.height=5----------------------------------------
par(mfrow=c(2,1))
d=density(acs$BMI,na.rm=TRUE)
plot(d)
plot(d,main="Kernel Density of Body Mass Index")
polygon(d,col="red",border="blue",lwd=2)
rug(acs$BMI,col="brown")
par(mfrow=c(1,1))

## ------------------------------------------------------------------------
dm=density(acs$weight[acs$sex=="Male"],na.rm=T)
df=density(acs$weight[acs$sex=="Female"],na.rm=T)
plot(df,main="Density Plot of Weight by Sex",col="blue",lty=1)
lines(dm,col="red",lty=2)
legend("topright",legend=c("Male","Female"),col=c("red","blue"),lty=2:1)

## ------------------------------------------------------------------------
d1=density(acs$LDLC[acs$Dx=="Unstable Angina"],na.rm=TRUE)
d2=density(acs$LDLC[acs$Dx=="NSTEMI"],na.rm=TRUE)
d3=density(acs$LDLC[acs$Dx=="STEMI"],na.rm=TRUE)
plot(d1,col="green",lwd=2,lty=1,main="Density Plot of LDLC by Dx")
lines(d2,col="blue",lwd=2,lty=2)
lines(d3,col="red",lwd=2,lty=3)
legend("topright",legend=c("Unstable Angina","NSTEMI","STEMI"),
       col=c("green","blue","red"),lty=1:3)

## ----fig.width=6---------------------------------------------------------
boxplot(acs$BMI,col="red")
text(0.7,median(acs$BMI,na.rm=T),"median")
text(0.7,quantile(acs$BMI,na.rm=T)[2],"Q1")
text(0.7,quantile(acs$BMI,na.rm=T)[4],"Q3")
text(0.7,fivenum(acs$BMI,na.rm=T)[2]-1.5*IQR(acs$BMI,na.rm=T),"(1)Q1-1.5*IQR")
text(0.7,fivenum(acs$BMI,na.rm=T)[4]+1.5*IQR(acs$BMI,na.rm=T),"(2)Q3+1.5*IQR")

## ------------------------------------------------------------------------
head(mtcars)

## ------------------------------------------------------------------------
rownames(mtcars)

## ------------------------------------------------------------------------
order(rownames(mtcars))

## ------------------------------------------------------------------------
rownames(mtcars)[c(23,15)]

## ------------------------------------------------------------------------
mtcars=mtcars[order(rownames(mtcars)),]
head(mtcars)

## ------------------------------------------------------------------------
mtcars=mtcars[order(mtcars$mpg,decreasing=TRUE),]
head(mtcars)

## ------------------------------------------------------------------------
mtcars=mtcars[order(mtcars$cyl,mtcars$mpg,decreasing=TRUE),]
mtcars

## ------------------------------------------------------------------------
data(mtcars)
table(mtcars$cyl)

## ------------------------------------------------------------------------
mtcars$cyl<7

## ------------------------------------------------------------------------
mtcars1=mtcars[mtcars$cyl<7,]
table(mtcars1$cyl)

## ------------------------------------------------------------------------
# subset(data.frame, subset(행), select(열))
mtcars1=subset(mtcars,cyl<7)
table(mtcars1$cyl)

## ------------------------------------------------------------------------
mtcars2=subset(mtcars,cyl==4,select=c(mpg,cyl))
mtcars2

## ------------------------------------------------------------------------

Height=c(168,173,160,145,NA,180)
mean(Height)

## ------------------------------------------------------------------------
Height[5]
Height[5]==NA

## ------------------------------------------------------------------------
is.na(Height[5])

## ------------------------------------------------------------------------
!is.na(Height)

## ------------------------------------------------------------------------
mean(Height[!is.na(Height)])

## ------------------------------------------------------------------------
mean(Height,na.rm=TRUE)

## ------------------------------------------------------------------------
dim(acs)
acs2=na.omit(acs)
dim(acs2)

## ------------------------------------------------------------------------
library(ggplot2)
data(diamonds)
str(diamonds)
summary(diamonds) 

## ----myCode=TRUE---------------------------------------------------------
diamonds$PriceGroup=1
diamonds$PriceGroup[diamonds$price>=1000]=2
diamonds$PriceGroup[diamonds$price>=5000]=3
table(diamonds$PriceGroup)

## ------------------------------------------------------------------------
diamonds$PriceGroup=ifelse(diamonds$price<1000,1,ifelse(diamonds$price<5000,2,3))
table(diamonds$PriceGroup)

## ------------------------------------------------------------------------
diamonds$PriceGroup=cut(diamonds$price,breaks=c(0,999,4999,99999),labels=c(1,2,3))
table(diamonds$PriceGroup)

## ------------------------------------------------------------------------
rank2group <- function (y,k=4){
    count=length(y)
    z=rank(y,ties.method="min")
    return(floor((z-1)/(count/k))+1)
}
diamonds$PriceGroup=rank2group(diamonds$price,4)
table(diamonds$PriceGroup)
aggregate(price~PriceGroup,data=diamonds,range)

## ------------------------------------------------------------------------
diamonds$PriceGroup3=rank2group(diamonds$price,3)
table(diamonds$PriceGroup3)
aggregate(price~PriceGroup3,data=diamonds,range)

## ------------------------------------------------------------------------
diamonds$PriceGroup5=rank2group(diamonds$price,5)
table(diamonds$PriceGroup5)
aggregate(price~PriceGroup5,data=diamonds,range)

