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
knit_hooks$set(
    normalsize=function(before,options,envir){
        if(before){
            "\\normalsize \\color{blue}"
        } else{
            "\\normalsize \\color{black}"
        }
    })


## ------------------------------------------------------------------------
data(mtcars)
(result=table(mtcars$cyl))

## ------------------------------------------------------------------------
prop.table(result)

## ------------------------------------------------------------------------
prop.table(result)*100

## ------------------------------------------------------------------------
table(mtcars$cyl,mtcars$am)

## ------------------------------------------------------------------------
mtcars$tm=factor(mtcars$am,labels=c("automatic","manual"))
table(mtcars$cyl,mtcars$tm)

## ------------------------------------------------------------------------
mtcars$tm=ifelse(mtcars$am==0,"automatic","manual")

## ------------------------------------------------------------------------
result=table(mtcars$cyl,mtcars$tm)
result

## ------------------------------------------------------------------------
result
addmargins(result)

## ------------------------------------------------------------------------
result1=xtabs(~cyl+tm,data=mtcars)
result1

## ----fig.width=4,fig.height=4--------------------------------------------
plot(result1)

## ------------------------------------------------------------------------
prop.table(result1)

## ------------------------------------------------------------------------
prop.table(result1)*100

## ------------------------------------------------------------------------
addmargins(prop.table(result1))*100

## ------------------------------------------------------------------------
chisq.test(result)

## ------------------------------------------------------------------------
fisher.test(result)

## ----fig.width=4,fig.height=4--------------------------------------------
plot(result)

## ----fig.width=4,fig.height=4--------------------------------------------
mosaicplot(result,color=c("tan1","firebrick2"))  #plot()도 같은 결과이다.

## ----fig.width=4,fig.height=4--------------------------------------------
t(result)

## ----fig.width=4,fig.height=4--------------------------------------------
mosaicplot(t(result))

## ----eval=FALSE----------------------------------------------------------
## colors()
## demo("colors")

## ------------------------------------------------------------------------
require(moonBook)
data(acs)
(result=table(acs$HBP,acs$smoking))
round(prop.table(result)*100,2)

## ------------------------------------------------------------------------
acs$smoking=factor(acs$smoking,levels=c("Never","Ex-smoker","Smoker"))
str(acs$smoking)
(result=table(acs$HBP,acs$smoking))

## ------------------------------------------------------------------------
result[2,]

## ------------------------------------------------------------------------
colSums(result)

## ------------------------------------------------------------------------
res=prop.trend.test(result[2,],colSums(result))
res

## ----fig.width=4,fig.height=4--------------------------------------------
plot(t(result),col=c("deepskyblue","brown2"),main="Hypertension and Smoking",
     ylab="Hypertension",xlab="Smoking")

## ------------------------------------------------------------------------
mytable(smoking~age,data=acs)

## ----fig.width=4,fig.height=5--------------------------------------------
result=table(mtcars$cyl,mtcars$tm)
barplot(result)

## ----fig.width=4,fig.height=4.5------------------------------------------
barplot(result,legend=rownames(result),ylim=c(0,20))

## ------------------------------------------------------------------------
mylegend=paste(rownames(result),"cyl")
mylegend

## ----fig.width=5,fig.height=4--------------------------------------------
barplot(result,legend=mylegend,ylim=c(0,20))

## ----fig.width=5,fig.height=4--------------------------------------------
barplot(result,legend=mylegend,beside=TRUE)

## ----fig.width=5,fig.height=4--------------------------------------------
barplot(result,legend=mylegend,beside=TRUE,horiz=TRUE)

## ----fig.width=5,fig.height=4--------------------------------------------
mycol=c("tan1","coral2","firebrick2")
barplot(result,legend=mylegend,beside=TRUE,col=mycol)

## ----fig.width=5,fig.height=4.5------------------------------------------
barplot(result,beside=TRUE,col=mycol)
abline(h=1:12,col="white",lwd=2)
legend("topright",legend=mylegend,fill=mycol)

## ----fig.width=5,fig.height=4.5------------------------------------------
barplot(t(result),beside=TRUE,legend=rownames(t(result)),
        args.legend=list(x="top"))

## ------------------------------------------------------------------------
blue=rbind(c(5,3,4,3),
           c(3,2,5,1))
dimnames(blue)<-list(c("A","B"),c("t1","t2","t3","t4"))
red=rbind(c(1.7,3.5,1.6,1.1),
          c(2.1,1.0,1.7,0.5))
dimnames(red)<-list(c("A","B"),c("t1","t2","t3","t4"))
blue
red

## ----fig.height=7,fig.show='hold'----------------------------------------
par(mfrow=c(1,2))
barplot(blue,col=c("lightblue","blue"),ylim=c(0,10))
barplot(red,col=c("salmon","red"),ylim=c(0,10))
par(mfrow=c(1,1))

## ----echo=FALSE,fig.height=7---------------------------------------------
barplot(blue,col=c("lightblue","blue"),ylim=c(0,10),xlim=c(0,9),
        space=c(0,1,1,1),axisnames=FALSE)
barplot(red,col=c("salmon","red"),ylim=c(0,10),axes=FALSE,
        space=c(0.5,1,1,1),add=TRUE)

## ----eval=FALSE----------------------------------------------------------
## barplot(blue,col=c("lightblue","blue"),ylim=c(0,10),xlim=c(0,9),
##         space=c(0,1,1,1),axisnames=FALSE)
## barplot(red,col=c("salmon","red"),ylim=c(0,10),axes=FALSE,
##         space=c(0.5,1,1,1),add=TRUE)

## ------------------------------------------------------------------------
result=table(acs$sex,acs$HBP)
par(mfrow=c(1,2))
barplot(t(result),main="Stacked Bar Plot")
spineplot(result,main="Spineplot",ylab="Presence of Hypertension")
par(mfrow=c(1,1))

## ------------------------------------------------------------------------
mean(acs$TC)

## ------------------------------------------------------------------------
mean(acs$TC,na.rm=T)

## ------------------------------------------------------------------------
mytable(Dx~TC,data=acs)

## ------------------------------------------------------------------------
tapply(acs$TC,acs$Dx,mean,na.rm=T)
tapply(acs$TC,acs$Dx,sd,na.rm=T)

## ------------------------------------------------------------------------
aggregate(TC~Dx,data=acs,mean)

## ------------------------------------------------------------------------
aggregate(TC~Dx,data=acs,sd)

## ------------------------------------------------------------------------
myfun=function(x){
    result=c(mean(x),sd(x))
}
aggregate(TC~Dx,data=acs,myfun) 

## ------------------------------------------------------------------------
aggregate(TC~Dx, data=acs,function(x) c(mean(x),sd(x)))

## ------------------------------------------------------------------------
aggregate(cbind(TC,TG,HDLC,LDLC)~Dx, data=acs,function(x) c(mean(x),sd(x)))   

## ------------------------------------------------------------------------
aggregate(cbind(TC,TG)~Dx+sex,data=acs,function(x) {c(mean(x),sd(x))})

## ----scriptsize=TRUE-----------------------------------------------------
mytable(sex+Dx~TC+TG,data=acs)

## ------------------------------------------------------------------------
boxplot(TC~sex,data=acs)
boxplot(TC~Dx,data=acs)

## ---- child='chap10-1.rmd'-----------------------------------------------

## ------------------------------------------------------------------------
require(moonBook)
acs$Dx=factor(acs$Dx,levels=c("Unstable Angina","NSTEMI","STEMI"))
boxplot(TG~Dx,data=acs)

## ------------------------------------------------------------------------
boxplot(TG~Dx,data=acs,ylim=c(0,400))

## ------------------------------------------------------------------------
boxplot(TG~Dx,varwidth=T,notch=T,data=acs,ylim=c(0,400))

## ------------------------------------------------------------------------
boxplot(TG~Dx,varwidth=T,notch=T,outline=FALSE,data=acs,ylim=c(0,400))

## ------------------------------------------------------------------------
boxplot(TG~Dx+sex,varwidth=T,notch=T,outline=FALSE,data=acs,ylim=c(0,400))

## ------------------------------------------------------------------------
boxplot(TG~Dx+sex,varwidth=T,notch=T,outline=FALSE,data=acs,ylim=c(0,400),
        col=c(rep("yellow",3),rep("orange",3)))
legend(3,380,c("Male","Female"),fill=c("yellow","orange"))

## ------------------------------------------------------------------------
boxplot(TG ~ Dx, data = acs,boxwex = 0.3, at = 1:3 - 0.2, notch=TRUE,
        outline=FALSE, subset = sex == "Female", col = "yellow",
        xlim=c(0.5,3.5),ylim = c(0, 400), varwidth=T,yaxs = "i")
boxplot(TG ~ Dx, data = acs, varwidth=TRUE, add = TRUE, 
        outline=FALSE,axes=FALSE,
        boxwex = 0.3, at = 1:3 + 0.2, notch=T,
        subset = sex == "Male", col = "orange")

legend(1.7, 380, c("Female", "Male"), fill = c("yellow", "orange"))
abline(h=150,lty="dashed",col="red")

## ------------------------------------------------------------------------
boxplot(TG ~ Dx, data = acs,boxwex = 0.3, at = 1:3 - 0.2, notch=T,outline=FALSE,
        subset = sex == "Female", col = "yellow", axes=FALSE,
        xlim=c(0.5,3.5),ylim = c(0, 400), varwidth=TRUE,yaxs = "i")
boxplot(TG ~ Dx, data = acs, varwidth=T, add = TRUE, outline=FALSE,axes=FALSE,
        boxwex = 0.3, at = 1:3 + 0.2, notch=TRUE,
        subset = sex == "Male", col = "orange")
legend(2.5, 380, c("Female", "Male"), fill = c("yellow", "orange"))
abline(h=150,lty="dashed",col="red")
box()
axis(side=2,)      ## y축 
axis(side=1,at=c(1,2,3),labels=levels(acs$Dx))  ## x축
mtext("Diagnosis",side=1,line=2.2)              ## y축 라벨  
mtext("Serum Triglyceride level(mg/dL)",side=2,line=2.2)  ## x축 라벨

## ------------------------------------------------------------------------
boxplot(TG~sex+Dx,varwidth=T,notch=T,outline=FALSE,data=acs,ylim=c(0,400),
        col=c(rep(c("yellow","orange"),3)),axes=FALSE)
box()
axis(side=2,)
axis(side=1,at=c(1.5,3.5,5.5),labels=levels(acs$Dx))
legend(4.5,390,c("Female","Male"),fill=c("yellow","orange"))
abline(h=150,lty="dashed",col="red")
mtext("Diagnosis",side=1,line=2.2)
mtext("Serum Triglyceride level(mg/dL)",side=2,line=2.2)


## ------------------------------------------------------------------------
x=c(15.5,11.21,12.67,8.87,12.15,9.88,2.06,14.50,0,4.97)
mean(x)
sd(x)

## ------------------------------------------------------------------------
shapiro.test(x)

## ------------------------------------------------------------------------
t.test(x,mu=8.1)

## ------------------------------------------------------------------------
t.test(x,mu=8.1,conf.level=0.99,alter="greater")

## ------------------------------------------------------------------------
data(sleep)
head(sleep)
str(sleep)

## ------------------------------------------------------------------------
with(sleep,
     shapiro.test(extra[group == 2] - extra[group == 1]))

## ------------------------------------------------------------------------
with(sleep,
     wilcox.test(extra[group == 2] - extra[group == 1]))

## ------------------------------------------------------------------------
with(sleep,
     wilcox.test(extra[group == 2] - extra[group == 1],exact=FALSE))

## ------------------------------------------------------------------------
with(sleep,
     t.test(extra[group == 1],
            extra[group == 2], paired = TRUE))

## ------------------------------------------------------------------------
sleep1 <- with(sleep, extra[group == 2] - extra[group == 1])
summary(sleep1)
stripchart(sleep1, method = "stack", xlab = "hours",
           main = "Sleep prolongation (n = 10)")
boxplot(sleep1, horizontal = TRUE, add = TRUE,
        at = .6, pars = list(boxwex = 0.5, staplewex = 0.25))

## ------------------------------------------------------------------------
boxplot(age~sex,data=acs,col=c("brown2","deepskyblue"))

## ------------------------------------------------------------------------
var.test(age~sex,data=acs)

## ------------------------------------------------------------------------
t.test(age~sex,data=acs, var.equal=TRUE)

## ------------------------------------------------------------------------
t.test(age~sex,data=acs)

## ------------------------------------------------------------------------
aggregate(age~Dx,data=acs,function(x) {c(mean(x),sd(x))})
boxplot(LDLC~Dx,data=acs)

## ----echo=FALSE----------------------------------------------------------
require(moonBook)

## ------------------------------------------------------------------------
moonBook::densityplot(age~Dx,data=acs)

## ------------------------------------------------------------------------
out=aov(LDLC~Dx,data=acs)
summary(out)

## ------------------------------------------------------------------------
TukeyHSD(out)

## ----fig.height=4--------------------------------------------------------
plot(TukeyHSD(out))

## ----fig.show='hold'-----------------------------------------------------
par(las=1)
plot(TukeyHSD(out))
par(las=0)

## ----fig.show='hold'-----------------------------------------------------
par(las=1)
par(mar=c(5,12,4,2))
plot(TukeyHSD(out))
par(mar=c(5,4,4,2))
par(las=0)

## ----message=FALSE-------------------------------------------------------
# install.packages("car")  # 설치하지 않은 경우 한 번만 실행
require(car)
qqPlot(lm(LDLC~Dx,data=acs),main="qqPlot",simulate=TRUE,labels=TRUE)

## ------------------------------------------------------------------------
shapiro.test(resid(out))

## ------------------------------------------------------------------------
#install.packages("nortest")  # 설치하지 않은 경우 한 번만 실행
nortest::ad.test(resid(out))

## ------------------------------------------------------------------------
bartlett.test(LDLC~Dx,data=acs)

## ------------------------------------------------------------------------
outlierTest(out)

## ------------------------------------------------------------------------
moonBook::densityplot(age~sex,data=acs)

## ------------------------------------------------------------------------
out=lm(age~sex,data=acs)
shapiro.test(resid(out))

## ------------------------------------------------------------------------
wilcox.test(age~sex,data=acs)

## ------------------------------------------------------------------------
kruskal.test(LDLC~factor(Dx),data=acs)

## ----message=FALSE,warning=FALSE,results='hide'--------------------------
# install.packages("nparcomp")    # 설치가 안 된 경우 처음 한 번만 실행
require(nparcomp)
result=mctp(LDLC~Dx,data=acs)

## ------------------------------------------------------------------------
summary(result)

## ----fig.show='hold'-----------------------------------------------------
par(las=1)
par(mar=c(5,12,4,2))
plot(result)
par(mar=c(5,4,4,2))
par(las=0)

## ------------------------------------------------------------------------
pairwise.wilcox.test(acs$LDLC,acs$Dx,p.adj="bonferroni")

## ------------------------------------------------------------------------
mytable(Dx~LDLC,data=acs,method=3)

