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
data(iris)
str(iris)
head(iris)
table(iris$Species)

## ------------------------------------------------------------------------
require(tree)
set.seed(2)
train=sample(1:nrow(iris),nrow(iris)*0.7)
training=iris[train,]
testing=iris[-train,]
itree =tree(Species~.,training)
itree

## ----fig.height=6,fig.width=6--------------------------------------------
plot(itree)
text(itree,pretty=0)

## ------------------------------------------------------------------------
ipredict=predict(itree,testing,type="class")
table(ipredict,testing$Species)

## ----message=FALSE-------------------------------------------------------
require(caret)
confusionMatrix(ipredict, testing$Species)

## ----message=FALSE-------------------------------------------------------

inTrain=createDataPartition(y=iris$Species,p=0.7,list=FALSE)
training=iris[inTrain,]
testing=iris[-inTrain,]
dim(training);dim(testing)

## ----message=FALSE-------------------------------------------------------
modFit=train(Species~.,method="rpart",data=training)
print(modFit$finalModel)

## ------------------------------------------------------------------------
plot(modFit$finalModel,uniform=TRUE, main="Classification Tree")
text(modFit$finalModel, use.n=TRUE, all=TRUE,cex=0.8)

## ----message=FALSE-------------------------------------------------------
require(rattle)
fancyRpartPlot(modFit$finalModel)

## ----message=FALSE,comment=NA--------------------------------------------
predict(modFit,newdata=testing)

## ------------------------------------------------------------------------
confusionMatrix(predict(modFit,newdata=testing), testing$Species)

## ----comment=NA,message=FALSE--------------------------------------------
require(party)
gtree <- ctree(Species ~ ., data = iris)
plot(gtree)

## ------------------------------------------------------------------------
plot(gtree, inner_panel = node_barplot,
     edge_panel = function(...) invisible(), tnex = 1)

## ------------------------------------------------------------------------
confusionMatrix(Predict(gtree), iris$Species)

## ----fig.width=6.6,fig.height=6.5----------------------------------------
plot(Petal.Length~Petal.Width,col="black",bg=Species,pch=21,data=iris)
abline(h=1.9,lwd=2,lty="dotted")
abline(v=1.7,lwd=2,col="red",lty="dotted")
abline(h=4.8,lwd=2,col="blue",lty="dotted")
legend(0.2,6.7,legend=levels(iris$Species),pt.bg=1:3,pch=21)
text(1, 2.05, "Petal.Length > 1.9")
text(2.05,4,"Petal.Width>1.7",col="red")
text(0.7, 4.95, "Petal.Length > 4.8",col="blue")

## ------------------------------------------------------------------------
tail(mtcars)
str(mtcars)

## ----fig.height=7--------------------------------------------------------
cartree=ctree(mpg~.,data=mtcars)
plot(cartree)

## ------------------------------------------------------------------------
Node2=mtcars[mtcars$wt<=2.32,]
Node2
summary(Node2$mpg)

## ------------------------------------------------------------------------
Node4=mtcars[(mtcars$wt>2.32) & (mtcars$disp<=258),]
nrow(Node4)
summary(Node4$mpg)
Node5=mtcars[mtcars$disp>258,]
nrow(Node5)
summary(Node5$mpg)

## ----message=FALSE,fig.height=6------------------------------------------
require(mycor)
res=mycor(mtcars[,c(3,1,4,6)])
plot(res,type=4)

## ----fig.height=6--------------------------------------------------------
plot(res,type=2)

## ------------------------------------------------------------------------
data("GBSG2", package = "TH.data")
head(GBSG2)

## ----message=FALSE,fig.height=6------------------------------------------
require(survival)
stree <- ctree(Surv(time, cens) ~ ., data = GBSG2)
plot(stree)

## ------------------------------------------------------------------------
GBSG2[c(1,2,6,8),c(1,6,7)]

## ------------------------------------------------------------------------
treeresponse(stree, newdata = GBSG2[c(1,2,6,8),])

