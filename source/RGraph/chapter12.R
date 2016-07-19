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
## install.packages("UsingR")

## ----message=FALSE-------------------------------------------------------
require(UsingR)
data(galton)
table(galton$child,galton$parent)

## ------------------------------------------------------------------------
out=lm(child~parent,data=galton)
summary(out)

## ----fig.height=6, fig.width=6-------------------------------------------
plot(child~parent,data=galton)
abline(out,col="red")

## ----fig.height=6,fig.width=6--------------------------------------------
plot(jitter(child,5) ~ jitter(parent,5),galton)

## ----fig.height=6,fig.width=6--------------------------------------------
sunflowerplot(galton)

## ---- fig.height=6,fig.width=6-------------------------------------------
freqData <- as.data.frame(table(galton$child, galton$parent))
names(freqData) <- c("child", "parent", "freq")
plot(as.numeric(as.vector(freqData$parent)), 
     as.numeric(as.vector(freqData$child)),
     pch = 21, col = "black", bg = "lightblue",
     cex = .15 * freqData$freq, 
     xlab = "parent", ylab = "child")
lm1 <- lm(galton$child ~ galton$parent)
lines(galton$parent,lm1$fitted,col="red",lwd=3)

## ------------------------------------------------------------------------
table(galton$child,galton$parent)

## ------------------------------------------------------------------------
freqData=data.frame(table(galton$child,galton$parent))
names(freqData) <- c("child", "parent", "freq")
tail(freqData)

## ------------------------------------------------------------------------
plot(freqData$child~freqData$parent,pch=21,col="black",bg="lightblue",
     cex=0.15*freqData$freq)

## ------------------------------------------------------------------------
str(freqData)

## ------------------------------------------------------------------------
as.numeric(freqData$parent)

## ------------------------------------------------------------------------
as.numeric(levels(freqData$parent)[freqData$parent])

## ------------------------------------------------------------------------
as.numeric(as.vector(freqData$parent))

## ----fig.width=6, fig.height=6-------------------------------------------
plot(as.numeric(as.vector(freqData$parent)), 
     as.numeric(as.vector(freqData$child)),
     pch = 21, col = "black", bg = "lightblue",
     cex = .15 * freqData$freq, 
     xlab = "parent", ylab = "child")
lm1 <- lm(galton$child ~ galton$parent)
lines(galton$parent,lm1$fitted,col="red",lwd=3)

