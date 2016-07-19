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
names=c("문건웅","나미녀","김대중")
sex=c("M","F","M")
data=data.frame(이름=names,성별=sex)
data

## ------------------------------------------------------------------------
write.csv(data,"test.csv")

## ------------------------------------------------------------------------
test=read.csv("test.csv")
test

## ------------------------------------------------------------------------
write.csv(data,"test.csv",row.names=FALSE)
test=read.csv("test.csv")
test

## ----error=TRUE----------------------------------------------------------
test1=read.csv("test.csv",fileEncoding="euc-kr")
test1
test2=read.csv("test.csv",fileEncoding="utf-8")
test2

## ----error=TRUE----------------------------------------------------------
colnames(data)=c("name","sex")
data
write.csv(data,"test.csv",row.names=FALSE)
test1=read.csv("test.csv",fileEncoding="euc-kr")
test1
test2=read.csv("test.csv",fileEncoding="utf-8")
test2

## ----eval=FALSE----------------------------------------------------------
## install.packages("xlsx")

## ------------------------------------------------------------------------
require(xlsx)
if (!file.exists("data")) {
    dir.create("data")
}

## ----eval=FALSE----------------------------------------------------------
## fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/
## rows.csv?accessType=DOWNLOAD"
## download.file(fileUrl, destfile = "./data/cameras.csv", method = "curl")
## dateDownloaded <- date()

## ------------------------------------------------------------------------
cameraData <- read.xlsx("./data/cameras.xlsx",sheetIndex=1,header=TRUE)
head(cameraData)

## ------------------------------------------------------------------------
colIndex <- 2:3
rowIndex <- 1:4
cameraDataSubset <- read.xlsx("./data/cameras.xlsx",sheetIndex=1,
                              colIndex=colIndex,rowIndex=rowIndex)
cameraDataSubset

## ------------------------------------------------------------------------
require(moonBook)
data(acs)
write.xlsx(acs,"./data/acs.xlsx",row.names=FALSE)
acs1=read.xlsx("./data/acs.xlsx",sheetIndex=1,header=TRUE)
head(acs1)

## ------------------------------------------------------------------------
a=system.time(write.xlsx(acs,"./data/acs.xlsx",row.names=FALSE));a
b=system.time(write.csv(acs,"./data/acs.csv",row.names=FALSE));b

## ------------------------------------------------------------------------
a=system.time(acs1<-read.xlsx("./data/acs.xlsx",sheetIndex=1,header=TRUE));a
b=system.time(acs2<-read.csv("./data/acs.csv"));b

## ----eval=FALSE----------------------------------------------------------
## install.packages("foreign")  # 패키지를 설치한 경우에는 생략한다
## require(foreign)
## read.spss("file_name")

## ----echo=FALSE----------------------------------------------------------
write.csv(acs,"./data/acs2.csv")
acs2<-read.csv("./data/acs2.csv")

## ------------------------------------------------------------------------
str(acs)
str(acs2)

## ------------------------------------------------------------------------
acs3=read.csv("./data/acs.csv",stringsAsFactors=FALSE)

## ------------------------------------------------------------------------
str(acs$Dx)
unique(acs$Dx)

## ------------------------------------------------------------------------
length(unique(acs$Dx))

## ------------------------------------------------------------------------
str(acs)
select=sapply(acs,function(x) length(unique(x))<=3)
select
acs[,select]<-lapply(acs[,select],factor)
str(acs)

## ------------------------------------------------------------------------
str(mtcars)
select=sapply(mtcars,function(x) length(unique(x))<=4)
mtcars[,select]<-lapply(mtcars[,select],factor)
str(mtcars)

## ------------------------------------------------------------------------
str(acs)
i=sapply(acs,is.factor)
acs[i]=lapply(acs[i],as.character)
str(acs)

## ------------------------------------------------------------------------
str(mtcars)
i=sapply(mtcars,is.factor)
mtcars[i]=lapply(mtcars[i],as.numeric)
str(mtcars)

