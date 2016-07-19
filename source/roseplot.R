data=read.csv("roseplot.csv")
data

require(reshape2)

data=data[1:12,]
data1=data.frame(t(data))
data2=data1[2:8,]
colnames(data2)=month.name
data2$group=row.names(data2)
data3=melt(data2,id="group")
data3$value=as.numeric(data3$value)
head(data3)

require(ggplot2)
ggplot(data=data3,aes(x=variable,y=value,fill=group))+
    geom_bar(stat="identity")

ggplot(data=data3,aes(x=variable,y=value,fill=group))+
    geom_bar(stat="identity")+
    scale_fill_brewer(palette="Greens")+xlab("")+ylab("")

ggplot(data=data3,aes(x=variable,y=value,fill=group))+
    geom_bar(stat="identity")+
    coord_polar()+
    scale_fill_brewer(palette="Greens")+xlab("")+ylab("")

ggplot(data=data3,aes(x=variable,y=group,fill=value))+
    geom_tile(colour="black",size=0.1)+
    scale_fill_gradientn(colours=c("white","steelblue"))+
    coord_polar()+xlab("")+ylab("")

