library(sqldf)

load("data/stock.rdata")
summary(stock)
colnames(stock)
colnames(stock) <- tolower(colnames(stock))

sqldf("select date,code,count(*) from stock group by date,code having count(*) > 1")
?unique
?duplicated
dim(stock)
stock1<-unique(stock)
# stock1 <- stock[!duplicated(stock)==TRUE,]
# duplicated(stock1)
# dim(stock1)
sqldf("select date,code,count(*) from stock1 group by date,code having count(*) > 1")

sqldf("select min(date),max(date) from stock")

target_date <- sqldf("select code, (high - open)/open top_rate from stock where date='2014-09-02'")
summary(target_date)
ind <- which(target_date$top_rate > 0.07)
ind
target_date$top <-0
target_date[ind,"top"]<-1
table(target_date$top)
input1 <- sqldf("select code,volume from stock where date='2014-09-01'")
dim(input1)
mart1 <- sqldf("select a.*, b.* from target_date a, input1 b where a.code=b.code")
colnames(mart1)
mart1 <- mart1[,c(1,3,5)]
input2 <- sqldf("select code, avg(close) M1 from stock where date between '2014-08-01' and '2014-09-01' group by code")
dim(input2)

input3 <- sqldf("select code, avg(close) M2 from stock where date between '2014-07-01' and '2014-08-01' group by code")
dim(input3)
input4 <- cbind(input2,input3)
colnames(input4)

input4<-input4[,c(1,2,4)]
colnames(mart1)
colnames(input4)
mart2<- sqldf("select a.code,a.top,a.volume, b.M1,b.M2 from mart1 a, input4 b where a.code=b.code")
colnames(mart2)
str(mart2)
mart2$top <- factor(mart2$top)
prop.table(table(mart2$top))

library(party)
mymodel.party <- ctree(top~.,data=mart2[,-1])
plot(mymodel.party)
table(predict(mymodel.party))

library(rpart)
mymodel.rpart <- rpart(top~.,data=mart2[,-1])
table(predict(mymodel.rpart,type="class"),mart2$top)
14/(3+14)
(1868+14)/(1868+14+3+83)

#install.packages("partykit")
library(partykit)
mymodel <- as.party(mymodel.rpart)
plot(mymodel)
