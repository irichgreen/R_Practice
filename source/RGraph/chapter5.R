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
## windowsFonts()

## ----eval=FALSE----------------------------------------------------------
## par(family="")
## plot(1:10,type="n",main="MS Windows Fonts 서체 테스트",xlab="",ylab="")
## text(1,8,"family設定을 하지 않은 경우(default)",cex=1.5,pos=4)
## text(1,7,"family=\"serif\"로 設定한 경우",family="serif",cex=1.5,pos=4)
## text(1,6,"다시 family 設定을 안하면 default로",cex=1.5,pos=4)
## text(1,5,"family=\"sans\"로 設定한 경우",family="sans",cex=1.5,pos=4)
## text(1,4,"family=\"mono\"로 設定한 경우",family="mono",cex=1.5,pos=4)

## ------------------------------------------------------------------------
if(Sys.info()[["sysname"]] == "Darwin") { par(family="AppleGothic") }

## ----eval=FALSE----------------------------------------------------------
## plot(1:10,type="n",main="Mac에서 서체(Fonts) 테스트",xlab="",ylab="")
## text(1,8,"\"AppleGothic\"으로 設定한 경우",cex=1.5,pos=4)
## text(1,7,"\"AppleMyungjo\"으로 設定한 경우",family="AppleMyungjo",cex=1.5,pos=4)
## text(1,6,"\"NanumGothic\"으로 設定한 경우",family="NanumGothic",cex=1.5,pos=4)
## text(1,5,"\"NanumMyeongjo\"으로 設定한 경우",family="NanumMyeongjo",cex=1.5,pos=4)
## text(1,4,"\"Senggakdero\"로 設定한 경우",family="Senggakdero",cex=1.5,pos=4)

## ------------------------------------------------------------------------
names(pdfFonts())

## ----fig.height=7,warning=FALSE------------------------------------------
fontNo=length(names(pdfFonts()))
plot(1:fontNo,type="n")
for(i in 1:fontNo) text(fontNo/2,i,names(pdfFonts())[i],family=names(pdfFonts())[i])

## ------------------------------------------------------------------------
?mtcars        # mtcars에 대한 도움말 보기
data(mtcars)   # mtcars 데이터를 메모리로 불러온다.

## ------------------------------------------------------------------------
str(mtcars)    # 자료의 구조를 보여준다. 

## ------------------------------------------------------------------------
tail(mtcars)   # 데이터의 마지막 6개 자료를 보여준다.   

## ----fig.height=4.5------------------------------------------------------
plot(mtcars)
plot(mtcars$mpg)
plot(mpg~disp, data=mtcars)
plot(mpg~ factor(am),data=mtcars)

## ------------------------------------------------------------------------
head(methods(plot),10)
length(methods(plot))

## ------------------------------------------------------------------------
coplot(mpg~disp | factor(am),data=mtcars)

## ----fig.show='hold',fig.height=4.5--------------------------------------
par(mfrow=c(2,2))       # 화면을 2*2로 나눈다
plot(1:10,main="default(type=\"p\")")    # type을 생략할 경우 type="p"가 된다.
plot(1:10,type="l",main="type=\"l\"")     # type="l" 선그래프
plot(1:10,type="b",main="type=\"b\"")     # type="b" both(선과 점)
plot(1:10,type="c",main="type=\"c\"")     # "b"에서 선만 그린다. 
par(mfrow=c(1,1)) 

## ----fig.show='hold'-----------------------------------------------------
par(mfrow=c(2,2)) 
plot(1:10,type="o",main="type=\"o\"")     # both를 겹쳐그린다.
plot(1:10,type="h",main="type=\"h\"")     # 수직선을 그린다.
plot(1:10,type="s",main="type=\"s\"")     # stair steps
plot(1:10,type="n",main="type=\"n\"")     # 축만 그린 빈 그래프를 그린다.
par(mfrow=c(1,1)) 

## ----warning=FALSE,fig.height=6,eval=FALSE-------------------------------
## x=rep(1:5,each=5);
## y=rep(5:1,5);
## plot(1:5,type="n",xlim=c(0,7.5),ylim=c(0,5.5))
## points(x,y,pch=1:25,cex=2)
## text(x-0.5,y,labels=as.character(1:25),cex=1.5)
## points(rep(6,5),5:1,pch=65:69,cex=2)
## text(rep(6,5)-0.5,5:1,labels=as.character(65:69),cex=1.5)
## pchs=c("&","z","M","F","가")
## points(rep(7,5),5:1,pch=pchs,cex=2)
## text(rep(7,5)-0.5,5:1,labels=pchs,cex=1.5)

## ----echo=FALSE,warning=FALSE,fig.height=6-------------------------------
x=rep(1:5,each=5);
y=rep(5:1,5);
plot(1:5,type="n",xlim=c(0,7.5),ylim=c(0,5.5))
points(x,y,pch=1:25,cex=2)
text(x-0.5,y,labels=as.character(1:25),cex=1.5)
points(rep(6,5),5:1,pch=65:69,cex=2)
text(rep(6,5)-0.5,5:1,labels=as.character(65:69),cex=1.5)
pchs=c("&","z","M","F","가")
points(rep(7,5),5:1,pch=pchs,cex=2,family="Korea1")
text(rep(7,5)-0.5,5:1,labels=pchs,cex=1.5,family="Korea1")

## ----warning=FALSE,eval=FALSE--------------------------------------------
## par(mfrow=c(1,2))
## plot(mpg~disp,data=mtcars)
## plot(mpg~disp,data=mtcars,pch=21,col="black",bg=mtcars$am+2,cex=1.2,
##      main="연비와 배기량",
##      xlab="배기량",ylab="연비")
## par(mfrow=c(1,1))

## ----echo=FALSE,warning=FALSE,fig.height=5,fig.width=6.5-----------------
par(mfrow=c(1,2))
plot(mpg~disp,data=mtcars)
plot(mpg~disp,data=mtcars,pch=21,col="black",bg=mtcars$am+2,cex=1.2,
     main="연비와 배기량",
     xlab="배기량",ylab="연비",family="Korea1")
par(mfrow=c(1,1))

## ----fig.height=6,eval=FALSE---------------------------------------------
## plot(-4:4,-4:4,type="n",main="Examples of points()")
## x=rnorm(200)
## y=rnorm(200)
## points(x,y,pch=ifelse(y<x,8,1),col=ifelse(y>x,"red","blue"))
## points(x,y,pch=ifelse(y<x,1,8),col=ifelse(y>x,"red","blue"))

## ----fig.height=6,echo=FALSE---------------------------------------------
plot(-4:4,-4:4,type="n",main="Examples of points()")
x=rnorm(200)
y=rnorm(200)
points(x,y,pch=ifelse(y<x,8,1),col=ifelse(y>x,"red","blue"))
points(x,y,pch=ifelse(y<x,1,8),col=ifelse(y>x,"red","blue"))

## ----eval=FALSE----------------------------------------------------------
## curve(x^2+x,xlim=c(1,10),ylim=c(1,200),main="Examples of curve() and lines()")
## for(i in 0:6) lines(x,y=x^2+i*x+10*i,lty=i,lwd=i,col=i)
## legend("topleft",legend=paste("lty=",0:6),lty=0:6,lwd=2,col=0:6)

## ----fig.height=6,fig.width=6--------------------------------------------
fit=lm(mpg~disp,data=mtcars)
plot(mpg~disp,data=mtcars,main="Examples of abline(),text()")
grid(10,col="darkgray")
abline(fit,col="blue")
points(210,30,pch=8,col="red",cex=1.2)
text(210,30,paste("pos=",1:4,sep=""),pos=1:4)
abline(v=300,lty=3,lwd=3,col=3)
text(300,30,"v=300",col=3,pos=4)
abline(h=25,lty=2,lwd=2,col=2)
text(400,25,"h=25",col=2,pos=3)

## ----fig.height=5--------------------------------------------------------
plot(1:10,type="n",main="segments(), polygon(),mtext()",xlab="",ylab="") 
segments(c(2,4),1:9,5,lwd=2, col=1:3)     # 선분을 9개 그린다.
polygon(c(7,9,7,9,NA,9,7,9,7),1:9, density=c(10,20), angle=c(45,-45),col=2:3)
mtext(side=1,line=2,"mtext,side=1,line=2")
mtext(side=2,line=2,"mtext,side=2,line=2")
mtext(side=3,line=0.5,"mtext,side=3,line=0.5")
mtext(side=4,line=1,"mtext,side=4,line=1")

## ----fig.height=6,eval=FALSE---------------------------------------------
## plot(1:10,type="n",xlab="",ylab="",main="Examples of legend()")
## legend=c("group A","group B")
## location=c("topleft","top","topright","left","center","right","bottomleft",
##            "bottom","bottomright")
## for(i in 1:9) legend(location[i],legend,pch=1:2,col=1:2,title=location[i])
## legend(2,8,legend,lty=1:2,col=1:2)
## legend(7,8,legend,lty=1:2,pch=1:2,col=1:2)
## legend(2,4,legend,fill=1:2,col=1:2)
## legend(7,4,legend,fill=1:2,density=30)
## legend(locator(1),legend="Locator",fill="red")

## ----warning=FALSE,eval=FALSE--------------------------------------------
## plot(mpg~disp,data=mtcars,pch=21,col="black",bg=mtcars$am+2,cex=1.2,
##      main="연비와 배기량",
##      xlab="배기량",ylab="연비",xlim=c(0,500),ylim=c(0,40))
## legend("topright",legend=c("automatic","manual"),pch=21,col="black",pt.bg=2:3,
##        cex=1.2)
## text(100,10,"피타고라스의 정리(定理)")
## text(100,7,labels=expression(italic(c^2==a^2+b^2)))
## polygon(c(200,300,300),c(4,10,4))
## polygon(c(290,290,300,300),c(4,5,5,4))
## text(240,8.2,"c")
## text(260,3,"a")
## text(320,7.5,"b")
## points(350,25,pch=8,col="red",cex=1.5)
## text(350,25,paste("pos=",1:4,sep=""),pos=1:4)
## abline(h=20,col="green",lty=2)
## abline(v=400,col="blue",lty=3)
## lines(lowess(mtcars$mpg~mtcars$disp),lwd=2,col="red")
## arrows(200,30,300,35,angle=30)
## title(sub="subtitle")
## mtext(side=1,line=2,"mtext,side=1,line=2")
## mtext(side=2,line=2,"mtext,side=2,line=2")
## mtext(side=3,line=0.5,"mtext,side=3,line=0.5")

## ----warning=FALSE,echo=FALSE--------------------------------------------
plot(mpg~disp,data=mtcars,pch=21,col="black",bg=mtcars$am+2,cex=1.2,
     main="연비와 배기량",xlim=c(0,500),ylim=c(0,40),
     xlab="배기량",ylab="연비",family="Korea1deb")
legend("topright",legend=c("automatic","manual"),pch=21,col="black",pt.bg=2:3,
       cex=1.2)
text(100,10,"피타고라스의 정리(定理)",family="Korea1")
text(100,7,labels=expression(italic(c^2==a^2+b^2)))
polygon(c(200,300,300),c(4,10,4))
polygon(c(290,290,300,300),c(4,5,5,4))
text(240,8.2,"c")
text(260,3,"a")
text(320,7.5,"b")
points(350,25,pch=8,col="red",cex=1.5)
text(350,25,paste("pos=",1:4,sep=""),pos=1:4)
abline(h=20,col="green",lty=2)
abline(v=400,col="blue",lty=3)
lines(lowess(mtcars$mpg~mtcars$disp),lwd=2,col="red")
arrows(200,30,300,35,angle=30)
title(sub="subtitle")
mtext(side=1,line=2,"mtext,side=1,line=2")
mtext(side=2,line=2,"mtext,side=2,line=2")
mtext(side=3,line=0.5,"mtext,side=3,line=0.5")

## ----eval=FALSE----------------------------------------------------------
## demo(plotmath)

## ------------------------------------------------------------------------
plot(sin,-pi,pi,ylab="y")
plot(cos,-pi,pi,add=T,lty="dotted",col="red")
legend(0,-0.5,legend=c("sin","cos"),lty=1:2,col=1:2)

## ------------------------------------------------------------------------
F = function(x,a) {1/(1+exp(-a-x))}
curve(F(x,-1),col=1,xlim=c(-5,5),ylim=c(0,1),ylab="f(x)")
par(new=TRUE)
curve(F(x,1),col=2,xlim=c(-5,5),ylim=c(0,1),ylab="",axes=FALSE,lty=2)
title(main=expression(f(x)==frac(1,1+exp(-a-x))))
legend(2,0.4,legend=c("a=-1","a=1"),lty=1:2,col=1:2)

## ------------------------------------------------------------------------
help(Devices)

## ----eval=FALSE----------------------------------------------------------
## png(filename="myplot1.png",width=480,height=480,units="px")
## plot(mpg~disp,data=mtcars)
## dev.off()

## ----fig.show='hold',message=FALSE---------------------------------------
attach(mtcars)
opar <- par(no.readonly = TRUE)  #현재 상태를 opar에 저장한다 
par(mfrow = c(2, 2))             # 화면을 2*2로 나눈다 
plot(wt, mpg, main = "Scatterplot of wt vs. mpg")
plot(wt, disp, main = "Scatterplot of wt vs disp")
hist(wt, main = "Histogram of wt")
boxplot(wt, main = "Boxplot of wt")
par(opar)   #다시 opar 상태로 되돌린다.
detach(mtcars)

## ----fig.show='hold',message=FALSE---------------------------------------
attach(mtcars)
opar <- par(no.readonly = TRUE)
par(mfrow = c(3, 1))
hist(wt)
hist(mpg)
hist(disp)
par(opar)
detach(mtcars)

## ----message=FALSE,fig.show='hold'---------------------------------------
attach(mtcars)
layout(matrix(c(1, 1, 2, 3), 2, 2, byrow = TRUE))
hist(wt)
hist(mpg)
hist(disp)
detach(mtcars)

## ----message=FALSE,fig.show='hold',fig.height=7,fig.width=7--------------
attach(mtcars)
layout(matrix(c(1, 1, 2, 3), 2, 2, byrow = TRUE), 
    widths = c(3, 1), heights = c(1, 2))
hist(wt)
hist(mpg)
hist(disp)
detach(mtcars)

## ----fig.show='hold'-----------------------------------------------------
opar <- par(no.readonly = TRUE)
par(fig = c(0, 0.8, 0, 0.8))      # Set up scatter plot
plot(mtcars$wt, mtcars$mpg, xlab = "Miles Per Gallon", 
    ylab = "Car Weight")
par(fig = c(0, 0.8, 0.55, 1), new = TRUE)        # Add box plot above
boxplot(mtcars$wt, horizontal = TRUE, axes = FALSE)
par(fig = c(0.65, 1, 0, 0.8), new = TRUE)        # Add box plot to right
boxplot(mtcars$mpg, axes = FALSE)
mtext("Enhanced Scatterplot", side = 3, outer = TRUE, 
    line = -3)
par(opar)

## ----echo=FALSE,fig.show='hold',fig.height=4-----------------------------
opar<-par(no.readonly=TRUE)
par(mar=c(3,3,3,3))
plot(1:10,type="n",axes=FALSE,xlab="",ylab="")
box()
rect(6,1.5,10,5)         
text(6,1.5,"x1",pos=1)
text(10,1.5,"x2",pos=1)
text(6,1.5,"y1",pos=2)
text(6,5,"y2",pos=2)
arrows(1,1,10,10,code=3)
mtext("(0,0)",side=1,adj=-0.1)
mtext("(1,1)",side=3,adj=1.1)
par(opar)

## ----eval=FALSE,fig.show='hold'------------------------------------------
## opar<-par(no.readonly=TRUE)
## par(mar=c(3,3,3,3))
## plot(1:10,type="n",axes=FALSE,xlab="",ylab="")
## box()
## rect(6,1.5,10,5)
## text(6,1.5,"x1",pos=1)
## text(10,1.5,"x2",pos=1)
## text(6,1.5,"y1",pos=2)
## text(6,5,"y2",pos=2)
## arrows(1,1,10,10,code=3)
## mtext("(0,0)",side=1,adj=-0.1)
## mtext("(1,1)",side=3,adj=1.1)
## par(opar)

## ------------------------------------------------------------------------
year=c(2010,2011,2012,2013)
cost=c(27145,25455,20723,19054)
sale=c(41678,44980,57653,73286)

## ----eval=FALSE----------------------------------------------------------
## plot(cost~year,type="l")
## plot(sale~year,type="l",col="red")

## ----echo=FALSE,fig.height=4---------------------------------------------
plot(cost~year,type="l")
plot(sale~year,type="l",col="red")

## ------------------------------------------------------------------------
plot(cost~year,type="l")
lines(year,sale,col="red")

## ------------------------------------------------------------------------
plot(cost~year,type="l",ylim=c(20000,80000),xlab="year",ylab="")
lines(year,sale,col="red")

## ------------------------------------------------------------------------
plot(cost~year,type="l",ylim=c(20000,80000),axes=FALSE,xlab="year",ylab="")
lines(year,sale,col="red")
axis(side=1,at=2010:2013,labels=year,line=2)
axis(side=2,)

## ------------------------------------------------------------------------
plot(cost~year,type="l",axes=FALSE,xlab="year",ylab="cost")
axis(side=1,at=2010:2013,labels=year,line=2)
axis(side=2,)
par(new=TRUE)
plot(sale~year,type="l",axes=FALSE,xlab="",ylab="",col="red")
axis(side=4,col="red")             # 오른쪽에 축 그림
mtext("sale",side=4,col="red")

## ------------------------------------------------------------------------
# 그래프 오른쪽 에 margin을 줌 
par(mar=c(5,4,4,6)+0.1)
plot(cost~year,type="o",pch=1, col="black",axes=FALSE,xlab="",ylab="",
     main="Sale and Cost, 2010-2013")
axis(side=2,)
mtext("Cost",side=2,line=2.5)
box()
par(new=TRUE)
plot(sale~year,type="o",pch=2,col="red",axes=FALSE,xlab="",ylab="")
axis(side=1,at=2010:2013,labels=year)
mtext("Year",side=1,line=2)
axis(side=4,col="red",col.axis="red")
mtext("Sale",side=4,col="red",line=2.5)
legend("top",legend=c("cost","sale"),text.col=c("black","red"),
       pch=c(1,2),lty=1,col=c("black","red"))

## ------------------------------------------------------------------------
# 그래프 오른쪽 에 margin을 줌 
par(mar=c(5,4,4,6)+0.1)
plot(cost~year,type="o",pch=1, col="black",axes=FALSE,xlab="",ylab="",
     ylim=c(15000,65000),main="Sale and Cost, 2010-2013")
axis(side=2,at=c(20000,25000,30000))
mtext("Cost",side=2,line=2.5,adj=0.2)
box()
par(new=TRUE)
plot(sale~year,type="o",pch=2,col="red",axes=FALSE,xlab="",ylab="",
     ylim=c(20000,80000))
axis(side=1,at=2010:2013,labels=year)
mtext("Year",side=1,line=2)
axis(side=4,at=seq(40000,70000,10000),col="red",col.axis="red")
mtext("Sale",side=4,col="red",line=2.5,adj=0.6)
legend("top",legend=c("cost","sale"),text.col=c("black","red"),
       pch=c(1,2),lty=1,col=c("black","red"))

## ----fig.height=7,eval=FALSE---------------------------------------------
## # 그래프 오른쪽 에 margin을 줌
## par(mar=c(5,4,4,6)+0.1)
## plot(cost~year,type="n",axes=FALSE,xlab="",ylab="",
##      ylim=c(15000,65000),main="Sale and Cost, 2010-2013")
## rect(par("usr")[1],par("usr")[3],par("usr")[2],par("usr")[4], border=FALSE,
##          col = "gray88")
## abline(h=seq(15000,30000,5000),col="white")
## abline(v=2010:2013,col="white")
## par(new=TRUE)
## plot(cost~year,type="o",pch=1, col="black",axes=FALSE,xlab="",ylab="",
##      ylim=c(15000,65000))
## axis(side=2,at=c(20000,25000,30000))
## mtext("Cost",side=2,line=2.5,adj=0.2)
## box()
## par(new=TRUE)
## plot(sale~year,type="n",pch=2,col="red",axes=FALSE,xlab="",ylab="",
##      ylim=c(20000,75000))
## abline(h=seq(40000,70000,10000),col="white")
## lines(year,sale,type="o",pch=2,col="red")
## axis(side=1,at=2010:2013,labels=year)
## mtext("Year",side=1,line=2)
## axis(side=4,at=seq(40000,70000,10000),col="red",col.axis="red")
## mtext("Sale",side=4,col="red",line=2.5,adj=0.6)
## legend("top",legend=c("cost","sale"),text.col=c("black","red"),
##        pch=c(1,2),lty=1,col=c("black","red"))

## ----fig.height=7,echo=FALSE---------------------------------------------
# 그래프 오른쪽 에 margin을 줌 
par(mar=c(5,4,4,6)+0.1)
plot(cost~year,type="n",axes=FALSE,xlab="",ylab="",
     ylim=c(15000,65000),main="Sale and Cost, 2010-2013")
rect(par("usr")[1],par("usr")[3],par("usr")[2],par("usr")[4], border=FALSE,
         col = "gray88")
abline(h=seq(15000,30000,5000),col="white")
abline(v=2010:2013,col="white")
par(new=TRUE)
plot(cost~year,type="o",pch=1, col="black",axes=FALSE,xlab="",ylab="",
     ylim=c(15000,65000))
axis(side=2,at=c(20000,25000,30000))
mtext("Cost",side=2,line=2.5,adj=0.2)
box()
par(new=TRUE)
plot(sale~year,type="n",pch=2,col="red",axes=FALSE,xlab="",ylab="",
     ylim=c(20000,75000))
abline(h=seq(40000,70000,10000),col="white")
lines(year,sale,type="o",pch=2,col="red")
axis(side=1,at=2010:2013,labels=year)
mtext("Year",side=1,line=2)
axis(side=4,at=seq(40000,70000,10000),col="red",col.axis="red")
mtext("Sale",side=4,col="red",line=2.5,adj=0.6)
legend("top",legend=c("cost","sale"),text.col=c("black","red"),
       pch=c(1,2),lty=1,col=c("black","red"))

