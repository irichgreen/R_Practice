## 주요 R 패키지 신규 설치


rm(list=ls())

#package check & install
package.list = c("readxl")
for(i in package.list){
    package.path <- find.package(i,quiet=TRUE)
    if(length(package.path) == 0){
        install.packages(i)
    }
}

library(devtools)

#— 기본 패키지
#install.packages("base")
#install.packages("utils")
#install.packages("stats")
#install.packages("graphics")
install.packages("plotly")

#— ETL
install.packages("foreach")             #— foreach 반복문
install.packages("XLConnect")           #— Excel 입출력

#— ETL : 데이터 변환용 패키지
install.packages("data.table")          #— data.frame에 key를 추가한 데이터 구조
install.packages("sqldf")               #— Query 문으로 데이터 처리
install.packages("plyr")
install.packages("dplyr")
install.packages("reshape")
install.packages("reshape2")
install.packages("Amelia")              #— 결측값 보정
install.packages("DMwR")                #— 이상값 추출

#— ETL : 샘플링용 패키지
install.packages("cvTools")             #— 계통추출법 (Systematic sampling)
install.packages("doBy")                #— 분류별 샘플 추출
install.packages("sampling")            #— 층화추출법 (Stratified random sampling)
install.packages("caret")
install.packages("DMwR")

#— Description
install.packages("Hmisc")               #— 상관계수
install.packages("caret")               #— 변수 선택
install.packages("FSelector")           #— 변수 선택
install.packages("rpart")               #— 변수 선택

#— Classification
install.packages("MASS")                #— 베이즈 분류 (Bayes Classification) 모형
install.packages("party")               #— ctree 분류
install.packages("rparty")              #— 의사결정 나무 모형
install.packages("randomForest")        #— randomForest 분류
install.packages("ROCR")
install.packages("caret")
install.packages("lattice")

#— Estimation : 회귀분석, 시계열 분석을 위한 패키지
install.packages("TTR")                 #— 평활
install.packages("forecast")            #— ARIMA
install.packages("mgcv")                #— gam, bam modelling

#— Clustering
install.packages("cluster")
install.packages("fpc")                 #— Density-based Clustering
#install.packages("class")

#— Association : 연관성 분석
install.packages("arules")              #— 연관 분석
install.packages("arulesViz")           #— 연관 분석 시각화
install.packages("pmml")                #— 연관 규칙을 XML 파일로 저장

#— Optimization : 최적화
install.packages("lpSolve", dependencies = TRUE)
install.packages("lpSolveAPI")

#— Text_Mining : 비정형 데이터 마이닝 패키지
install.packages("tm")                  #— Text Mining
install.packages("wordcloud")           #— 워드 클라우드

#— Social Network Analysis
install.packages("igraph")

#— Visualization : 시각화용 패키지
install.packages("ggplot2")
install.packages("aplpack")             #— 줄기잎 그림, 체르노프 안형 그림, Start Chart
install.packages("vcd")                 #— Mosaic plot
install.packages("googleVis")           #— 모션 챠트, GEO 챠트
install.packages("shiny")               #— Shiny
install.packages("caret")               #— 산점도 행렬
install_github("ropensci/plotly")       # Plotly Visualization


#— 한글 패키지
install.packages("KoNLP")               #— 한글 자연어 처리 (NLP)

#— 병렬 처리용 패키지
install.packages("doParallel")          #— Windows 용
install.packages("doMC")                #— Mac 용

#— 기타 미분류 패키지
install.packages("knitr")               #— R 문서화
install.packages("RWordPress")          #— knitr로 문서화한후 WordPress로 배포
install.packages("twitteR")             #— Twitter 접속
install.packages("ROAuth")              #— Twitter 접속
install.packages("Rfacebook")           #— Facebook 접속
install.packages("Rook")                #— Facebook 접속

library(devtools)

# Interactive time series with dygraphs
install.packages("dygraphs")
install.packages("readr")
install.packages("readxl")
install.packages("roxygen2")
install_github("hadley/bookdown")
install.packages("gridExtra")
install.packages("logging")
install.packages("installr")            #— R 버전 업그레이드
install.packages("RGoogleAnalytics")
install.packages("extrafont")
install.packages("episensr")

# 웹에서 하는 통계 (web-r.org)  
install.packages("moonBook")
install.packages("ztable")
install.packages("mycor")

# Useful new R packages for data visualization and analysis
library(devtools)
install_github("rstudio/leaflet")
install_github("ramnathv/rCharts")
install_github("ramnathv/slidify")
install_github("ramnathv/slidifyLibraries")
install.packages("RTextTools", type="source")
install.packages("rvest")
install.packages("plotrix")


install.packages("drat", repos="http://cran.rstudio.com")
library(drat)
drat::addRepo(c("eddelbuettel", "RcppCore", "ghrr"))
insertPackage("drat_0.0.3.tar.gz")

install_github("ramnathv/htmlwidgets")
install_github("rich-iannone/DiagrammeR")

# Radiant : A shiny interface for R package
install.packages("radiant", repos = "http://vnijs.github.io/radiant_miniCRAN/")

# Geomorph beta package
install_github("EmSherratt/geomorph",ref = "Develop")

library(devtools)
install.packages("choroplethr")
install_github('arilamstein/choroplethrZip')

#stringr packages
install.packages("stringr")
install_github('Rexamine/stringi')

# MongoDB
install.packages("mongolite")

# random package
install.packages("random")

# RInside package
install.packages("RInside")

# RQDA
install.packages("RQDA")

# sjPlot package
install.packages("sjPlot")

# d3heatmap package
if (!require(devtools)) install.packages("devtools")
devtools::install_github('rstudio/leaflet')
devtools::install_github("rstudio/d3heatmap")

# New package for image processing in R
library(devtools)
install_github("dahtah/imager")

# ggtree package install
source("http://bioconductor.org/biocLite.R")
biocLite("ggtree")

source("http://bioconductor.org/biocLite.R")
biocLite("zlibbioc")


install.packages("ggExtra")
install.packages("geomorph")
devtools::install_github("EmSherratt/geomorph",ref = "Develop")

devtools::install_github("armstrtw/Rblpapi")

install.packages("dygraphs")


library(devtools)
install_github("treemap", username="mtennekes", subdir="pkg")

devtools::install_github("hrbrmstr/streamgraph")
install.packages("testthat")
devtools::install_github("jcheng5/bubbles")
devtools::install_github("tollpatsch/rzeit")
install.packages("networkD3")
install.packages("gbm")

install.packages('AzureML')
install.packages('distcomp')
install.packages('rotationForest')
install.packages('rpca')
install.packages('SwarmSVM')
install.packages('servr')

devtools::install_github("WinVector/WVPlots")
devtools::install_github("muschellij2/papayar")
devtools::install_github("muschellij2/itsnapr")

install.packages('vtreat', repos='http://cran.r-project.org/')
install.packages("rvest")
install.packages("purrr")

library(devtools)
devtools::install_bitbucket("kayontoga/rattle")
library(rattle)
rattle()

install.packages("IsingFit")
library(IsingFit)

devtools::install_github("dgrtwo/gganimate")
devtools::install_github("rstudio/addinexamples", type = "source")

devtools::install_github("ndphillips/yarrr")

install.packages("githubinstall")
library(githubinstall)

## CRAN Packages
install.packages(c("ggplot2", "stringr", "reshape2", "dichromat"))

## EBImage
source("http://bioconductor.org/biocLite.R")
biocLite("EBImage")

## Packages on GitHub
library(devtools)
install_github("ramnathv/rblocks")

## And finally ...
install_github("woobe/rPlotter")


