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

## ----echo=FALSE,comment=NA-----------------------------------------------
cat("```{r}  # 코드의 시작부분")

## ----echo=FALSE,comment=NA-----------------------------------------------
cat("```   # 코드의 끝 부분")

## ----echo=FALSE,comment=NA-----------------------------------------------
cat("```{r}
이 부분에 코드를 입력한다. 
```")

## ----eval=FALSE----------------------------------------------------------
## require(moonBook)
## data(acs)
## mytable(Dx~age+sex,data=acs)

## ----eval=FALSE----------------------------------------------------------
## require(mycor)
## out=mycor(iris)
## plot(out,type=2,groups=Species)

## ----echo=FALSE,comment=NA-----------------------------------------------
cat("```{r cache=FALSE,echo=TRUE}
require(knitr)
opts_chunk$set(comment=NA)
```")

