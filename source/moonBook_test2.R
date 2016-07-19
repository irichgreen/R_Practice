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

ggSpine(rose,"group","Month",yvar="value",stat="identity",position="stack",width=1,
        polar=TRUE,interactive=TRUE,palette="Reds")

ggRadar(acs,groupvar="sex",interactive=TRUE)

ggRadar(acs,groupvar="sex",interactive=TRUE,rescale=TRUE)

ggRadar(mtcars,groupvar="am",rescale=TRUE,interactive=TRUE)

ggRadar(mtcars,groupvar="cyl",rescale=TRUE,interactive=TRUE)

mtcars$model=rownames(mtcars)
p<-ggRadar(mtcars[1:9,],rescale=TRUE,groupvar="model",legend.position="none")+
    ylim(0,1)+facet_wrap(~model)
ggiraph(code=print(p))

str(browsers)

ggPieDonut(browsers,pies="browser",donuts="version",count="share",interactive=TRUE)

ggPieDonut(acs,"Dx","smoking",interactive=TRUE)

ggPieDonut(mtcars,"cyl","carb",labelposition=0,interactive=TRUE)

ggDonut(browsers,donuts="version",count="share",interactive=TRUE)

ggDonut(browsers,version,count="share",labelposition=0,interactive=TRUE)
