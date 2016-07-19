## 3차원 interactive 그래프 소개
## =============================
    
# 그래프는 단순히 멋있어 보이는 그림이 아니라 분석을 할때 쓰여지는 유용한 도구이다.
# 보통 3차원 그래프를 사용하는것을 권장하지는 않지만, 요즘은 그래프가 (그래프의 정확도나 관련성과는 무관하게) 프레젠테이션등에서 비쥬얼적인 효과를 높혀주는데 많이 사용되므로, 이 추세를 무시하기는 힘들다. R이 요즘 점점더 data visualisation쪽으로 발전되고 있는것도 이러한 추세와 무관하지 않을것이다.

# R에서 3차원 그래프를 그리는 방법은 몇가지가 있는데 그 중 시각적으로 보기도 좋고 쉽게 사용할수있는 3차원 interactive 그래프를 소개해 보겠다.

#여기서 쓰여지는 팩키지들은 아래와 같으며 scatter3d()를 사용하여 그래프를 실행한다.

library(MASS)
library(nnet)
library(car)
library(rgl)    
library(mgcv)

scatter3d(iris[,1],iris[,2],iris[,3],bg.col="black",axis.col=c("white","white","white"),xlab=colnames(iris)[1],ylab=colnames(iris)[2],zlab=colnames(iris)[3],revolutions=0,grid=FALSE,groups=factor(iris$Species),ellipsoid=TRUE,surface=FALSE)
library(plyr)
library(dplyr)
library(ggplot2)
library(locfit)
library(plotrix)
r1 <- read.csv('data/KNMI_20141130.edited.txt')
Sys.setlocale(category = "LC_TIME", locale = "C")
r2 <- mutate(r1,
             date = as.Date(format(YYYYMMDD),'%Y%m%d'),
             month =factor(months(date,abbreviate=TRUE),
                           levels=months(as.Date(
                               paste('2014',
                                     formatC(1:12,digits=2,width=2,flag='0'),
                                     '01',sep='-')),
                               abbreviate=TRUE)), 
             yearf=factor(format(date,'%Y')),
             yearn=as.numeric(substr(YYYYMMDD,1,4)),
             day=format(date,'%e'))

days <- filter(r2,yearn==1901) %>%
    mutate(.,dayno=format(date,'%j') ) %>%
    select(.,month,day,dayno) 

r3 <- merge(r2,days,all=TRUE) %>%
    filter(.,!grepl('0229',YYYYMMDD)) %>%
    mutate(.,daynon=as.numeric(dayno))

mylegend <- filter(days,day==' 1') %>%
    mutate(.,daynon=as.numeric(dayno))

r4 <- group_by(r3,yearf) %>%
    mutate(.,cmtemp = cummean(TG/10)) 

g1 <- ggplot(r4,aes(x=daynon,y=cmtemp,
                    col=yearf))
g1 + geom_line(alpha=.4,show_guide=FALSE)  +
    scale_x_continuous('Day',
                       breaks=mylegend$daynon,
                       labels=mylegend$month,
                       expand=c(0,0)) +
    scale_y_continuous('Temperature (C)')  +
    geom_line(data=r4[r4$yearf=='2014',],
              aes(x=daynon,y=cmtemp),
              col='black',
              size=2)

r3$Period <- cut(r3$yearn,c(seq(1900,2013,30),2013,2014),
                 labels=c('1901-1930','1931-1960',
                          '1961-1990','1991-2013','2014'))
g1 <- ggplot(r3[r3$yearn<2014,],aes(x=daynon,y=TG/10,col=Period))
g1 + geom_smooth(span=.15,method='loess',size=1.5)  +
    scale_x_continuous('Day',
                       breaks=mylegend$daynon,
                       labels=mylegend$month,
                       expand=c(0,0)) +
    geom_line(#aes(x=daynon,y=TG/10),
        data=r3[r3$yearn==2014,]) +
    scale_y_continuous('Temperature (C)')

myyears <- r3[r3$yearn<1925,]
m13 <- filter(myyears,daynon<30) %>%
    mutate(.,daynon=daynon+365) 
m0 <- filter(myyears,daynon>335) %>%
    mutate(.,daynon=daynon-365)
myyears <- rbind_list(m0,myyears,m13)

nn <- .2
mymod <- locfit(TG ~ lp(daynon,nn=nn),
                data=myyears) 
topred <- data.frame(daynon=1:365)
topred$pp <- predict(mymod,topred)
#plot(pp~ daynon,data=topred)

r5 <- merge(r3,topred) %>%
    mutate(.,tdiff=(TG-pp)/10) %>%
    select(.,tdiff,daynon,yearn)
m13 <- filter(r5,daynon<30) %>%
    mutate(.,daynon=daynon+365,
           yearn=yearn-1) 
m0 <- filter(r5,daynon>335) %>%
    mutate(.,daynon=daynon-365,
           yearn=yearn+1)
r6 <- rbind_list(m0,r5,m13) 

topred <- expand.grid(
    daynon=seq(1:365),
    yearn=1901:2014)
topred$pp2 <- locfit(
    tdiff ~ lp(yearn,daynon,nn=nn),
    data=r6) %>% 
    predict(.,topred) 
#topred <- arrange(topred,daynon,yearn)

myz <- matrix(topred$pp2,ncol=365)
zmin <- floor(min(topred$pp2)*10)/10
zmax <- ceiling(max(topred$pp2)*10)/10
myseq <- seq(zmin,zmax,.1)
par(mar=c(5,4,4,6))
image(myz,useRaster=TRUE,
      axes=FALSE,frame.plot=TRUE,
      col=colorRampPalette(c('blue','red'))(length(myseq)-1),
      breaks=myseq)
axis((seq(10,114,by=10)-1)/113,labels=seq(1910,2010,by=10),side=1)
axis((mylegend$daynon-1)/365,labels=mylegend$month,side=2)
color.legend(1.1,0,1.2,1,legend=c(zmin,zmax),gradient='y',
             rect.col=colorRampPalette(c('blue','red'))(length(myseq)-1)) 


# 위의 명령어를 실행하면 그래픽 디바이스가 새창으로 뜨는데, 마우스를 이용하여 그래프를 움직이고 zoom-in/out등을 할수도있다. scatter3d() 함수내에있는 여러가지 컨트럴 매개변수들을 이용해 색상과 사이즈등등을 바꿀수도있고 그래프회전이나 grouping 등을 정할수도있다. 
