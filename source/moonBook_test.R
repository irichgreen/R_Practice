devtools::install_github("cardiomoon/moonBook")
devtools::install_github("cardiomoon/moonBook2")

require(moonBook)
require(ggplot2)
require(ggiraph)
require(plyr)
require(reshape2)
require(scales)
require(moonBook2)

ggSpine(data=acs,"Dx","smoking",interactive=TRUE)

ggSpine(data=acs,"Dx","smoking",addlabel=TRUE,position="stack",interactive=TRUE)

ggSpine(data=acs,"Dx","smoking",addlabel=TRUE,position="dodge",interactive=TRUE)

ggSpine(data=acs,Dx,age,addlabel=TRUE,interactive=TRUE)

head(rose,10)

ggSpine(rose,"group","Month",yvar="value",stat="identity",width=1,interactive=TRUE)

