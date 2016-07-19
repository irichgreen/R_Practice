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

## ----results='asis',message=FALSE----------------------------------------
require(xtable)
print(xtable(head(mtcars[c(1:6)]),caption="xtable: Caption size discrepancy
             and misplacement"),size="large",latex.environment="flushright",
      caption.placement="top")

## ----message=FALSE-------------------------------------------------------
require(ztable)
options(ztable.type="latex")  #레이텍 형식으로 출력
options(ztable.zebra=1)  
options(ztable.zebra.color="platinum")

## ----results='asis'------------------------------------------------------
ztable(head(mtcars[c(1:6)]),size=6,zebra=NULL,position="r",caption="ztable: Caption
       size matching and within the table position")

## ----results='asis'------------------------------------------------------
ztable(head(mtcars[1:5]),zebra=1)


## ----results='asis'------------------------------------------------------
z=ztable(head(mtcars[1:5]),zebra=2,zebra.color="peach")
z

## ----eval=FALSE----------------------------------------------------------
## print(z,type="html")

## ------------------------------------------------------------------------
head(zcolors)

## ----results='asis'------------------------------------------------------
ztable(head(iris,12),zebra=0,zebra.color=NULL)

## ----results='asis'------------------------------------------------------
ztable(head(iris,12),zebra=0,zebra.color=c("peach","platinum","snow"))

## ----results='asis'------------------------------------------------------
ztable(head(mtcars[1:8]),
       caption="Table 18-1. Caption with default placement and position")
ztable(head(mtcars[1:8]),
       caption="Table 18-2. Right-sided caption with default placement",
       caption.position="r")

## ----results='asis'------------------------------------------------------
ztable(head(mtcars[1:8]),
       caption="Table 18-3. Left-sided caption with bottom placement",
       caption.placement="bottom",
       caption.position="l")

## ----results='asis'------------------------------------------------------
ztable(head(mtcars[1:8]),
       caption="Table 18-4. Caption with bold font",
       caption.bold=TRUE)

## ----results='asis'------------------------------------------------------
ztable(head(mtcars[1:9]),size=3,
       caption="Table 18-5. size=3")
ztable(head(mtcars[1:5]),size=7,
       caption="Table 18-6. size=7")

## ----results='asis'------------------------------------------------------
ztable(head(mtcars[1:3]),caption="Default position")
ztable(head(mtcars[1:3]),caption="Left-sided table",position="l")
ztable(head(mtcars[1:3]),caption="Right-sided table",position="r")

## ----results='asis'------------------------------------------------------
ztable(head(mtcars[1:5],3),caption="include.rownames=FALSE",
       include.rownames=FALSE)
ztable(head(mtcars[1:5],3),caption="include.colnames=FALSE",
       include.colnames=FALSE)

## ----results='asis'------------------------------------------------------
ztable(head(mtcars[1:5]),caption="digits : default")
ztable(head(mtcars[1:5]),caption="digits=c(0,1,2,3,0,1)",
       digits=c(0,1,2,3,0,1))

## ----results='asis'------------------------------------------------------
ztable(head(iris))
ztable(head(iris),caption="align=\"llccrr\"",align="llccrr")

## ----results='asis'------------------------------------------------------
ztable(head(iris),caption="align=\"|r|rrrrr|\"",align="|r|rrrrr|")
ztable(head(iris),caption="align=\"||r|rrrr|r||\"",align="||r|rrrr|r||")

## ----results='asis'------------------------------------------------------
ztable(head(mtcars[1:5],3),caption="booktabs=TRUE",
       booktabs=TRUE)

## ----results='asis'------------------------------------------------------
ztable(head(mtcars[1:3]),caption="wraptable=TRUE",
       wraptable=TRUE,wraptablewidth=7,position="l")

## ----results='asis'------------------------------------------------------
ztable(head(mtcars[1:3]),caption="turn=TRUE,angle=30",
       turn=TRUE,angle=30)

## ----results='asis'------------------------------------------------------
ztable(head(mtcars,15),caption="sidewaystable==TRUE",
       sidewaystable=TRUE)

## ----results='asis'------------------------------------------------------
ztable(head(iris,50),caption="Example of longtable",
       longtable=TRUE)

## ----eval=FALSE----------------------------------------------------------
## options(ztable.include.rownames=TRUE)
## options(ztable.include.colnames=TRUE)
## options(ztable.type="latex")
## options(ztable.show.heading=TRUE)
## options(ztable.show.footer=TRUE)
## options(ztable.caption.placement="top")
## options(ztable.caption.position="c")
## options(ztable.caption.bold=FALSE)
## options(ztable.booktabs=FALSE)
## options(ztable.zebra=NULL)
## options(ztable.zebra.color=NULL)
## options(ztable.colnames.bold=FALSE)

## ------------------------------------------------------------------------
getOption("ztable.booktabs")

## ------------------------------------------------------------------------
options(ztable.booktabs=TRUE)
getOption("ztable.booktabs")

## ----results="asis"------------------------------------------------------
out <- aov(mpg ~ ., data=mtcars)
ztable(out)

## ----results='asis'------------------------------------------------------
fit <- lm(mpg ~ cyl + disp + wt + drat + am, data=mtcars)
ztable(fit)

## ----results='asis'------------------------------------------------------
a=anova(fit)
ztable(a)

## ----results='asis'------------------------------------------------------
fit2 <- lm(mpg ~ cyl+wt, data=mtcars)
b=anova(fit2,fit)
ztable(b)
ztable(b,show.heading=FALSE)

## ----results='asis',warning=FALSE,message=FALSE--------------------------
require(survival)
data(colon)
attach(colon)
out <- glm(status ~ rx+obstruct+adhere+nodes, 
           data=colon, family=binomial)
ztable(out)

## ----results='asis'------------------------------------------------------
ztable(anova(out))

## ----results='asis'------------------------------------------------------
op <- options(contrasts = c("contr.helmert", "contr.poly"))
npk.aov <- aov(yield ~ block + N*P*K, npk) 
ztable(npk.aov,zebra=1)

## ----results='asis'------------------------------------------------------
ctl <- c(4.17,5.58,5.18,6.11,4.50,4.61,5.17,4.53,5.33,5.14)
trt <- c(4.81,4.17,4.41,3.59,5.87,3.83,6.03,4.89,4.32,4.69)
group <- gl(2, 10, 20, labels = c("Ctl","Trt"))
weight <- c(ctl, trt)
lm.D9 <- lm(weight ~ group)
ztable(lm.D9)

## ----results='asis'------------------------------------------------------
ztable(anova(lm.D9),booktabs=FALSE,align="|c|rrrr|r|")

## ----results='asis'------------------------------------------------------
counts <- c(18,17,15,20,10,20,25,13,12)
outcome <- gl(3,1,9)
treatment <- gl(3,3)
d.AD <- data.frame(treatment, outcome, counts)
glm.D93 <- glm(counts ~ outcome + treatment, family = poisson())
ztable(glm.D93)

## ----results='asis',message=FALSE----------------------------------------
data(USArrests)
pr1 <- prcomp(USArrests) 
ztable(pr1)
ztable(summary(pr1))

## ----results='asis',message=FALSE----------------------------------------
colon$TS = Surv(time,status==1) 
out=coxph(TS~rx+obstruct+adhere+differ+extent,data=colon)
ztable(out)

## ----results='asis'------------------------------------------------------
z=ztable(head(mtcars[1:2]),tabular=TRUE,zebra.color="peach-orange")
z1=ztable(tail(mtcars[1:2]),tabular=TRUE,zebra=2)

parallelTables(width=c(0.5,0.5),list(z,z1))

## ----results='asis'------------------------------------------------------
z=ztable(head(mtcars[1:2]),turn=TRUE,angle=15,zebra=2)
z1=ztable(head(mtcars[1:2]),turn=TRUE,angle=-15,zebra=2)

parallelTables(width=c(0.5,0.5),list(z,z1))

