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

## ---- eval=FALSE---------------------------------------------------------
## iris

## ------------------------------------------------------------------------
str(iris)

## ------------------------------------------------------------------------
?iris

## ------------------------------------------------------------------------
head(iris)

## ------------------------------------------------------------------------
tail(iris,10)

## ----echo=FALSE, fig.width=5---------------------------------------------
img=png::readPNG("figures/1-7.png")
grid::grid.raster(img)

## ----echo=FALSE, fig.width=3---------------------------------------------
img=png::readPNG("figures/1-8.png")
grid::grid.raster(img)

## ----eval=FALSE----------------------------------------------------------
## install.packages("devtools")

## ----eval=FALSE----------------------------------------------------------
## install.packages(c("moonBook","mycor"))

## ----eval=FALSE----------------------------------------------------------
## # CRAN을 통해 package를 설치한 경우에는 다시 설치할 필요가 없다.
## devtools::install_github("cardiomoon/moonBook")

## ----message=FALSE-------------------------------------------------------
require(moonBook)
require(mycor)

## ----fig.width=5,fig.height=5--------------------------------------------
plot(mycor(iris),type=2,groups=Species)

## ----echo=FALSE, fig.width=5---------------------------------------------
img=png::readPNG("figures/3-1.png")
grid::grid.raster(img)

## ----echo=FALSE, fig.width=5---------------------------------------------
img=png::readPNG("figures/3-2.png")
grid::grid.raster(img)

