rm(list=ls())

#package check & install
package.list = c("readxl")
for(i in package.list){
    package.path <- find.package(i,quiet=TRUE)
    if(length(package.path) == 0){
        install.packages(i)
    }
}

#load library
library("readxl")

#read excel file
data = read_excel(path="인풋.xlsx", sheet="테스트", col_names=TRUE)
data[1]
data[2]
