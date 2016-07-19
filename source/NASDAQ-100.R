library("quantmod")
#install.packages("TSdist")
install.packages("wmtsa")
install.packages("ade4")



library("TSdist")
library("ade4")
library("ggplot2")
library("Hmisc")
library("zoo")
library("scales")
library("reshape2")
library("tseries")
library("RColorBrewer")
library("ape")
library("sqldf")
library("googleVis")
library("gridExtra")
setwd("YOUR-WORKING-DIRECTORY-HERE")
temp=tempfile()
download.file("http://www.nasdaq.com/quotes/nasdaq-100-stocks.aspx?render=download",temp)
data=read.csv(temp, header=TRUE)
for (i in 1:nrow(data)) getSymbols(as.character(data[i,1]))
results=t(apply(combn(sort(as.character(data[,1]), decreasing = TRUE), 2), 2,
                function(x) {
                    ts1=drop(Cl(eval(parse(text=x[1]))))
                    ts2=drop(Cl(eval(parse(text=x[2]))))
                    t.zoo=merge(ts1, ts2, all=FALSE)
                    t=as.data.frame(t.zoo)
                    m=lm(ts2 ~ ts1 + 0, data=t)
                    beta=coef(m)[1]
                    sprd=t$ts1 - beta*t$ts2
                    ht=adf.test(sprd, alternative="stationary", k=0)$p.value
                    c(symbol1=x[1], symbol2=x[2], (1-ht))}))
results=as.data.frame(results)
colnames(results)=c("Sym1", "Sym2", "TSdist")
results$TSdist=as.numeric(as.character(results$TSdist))
save(results, file="results.RData")
load("results.RData")
m=as.dist(acast(results, Sym1~Sym2, value.var="TSdist"))
hc = hclust(m)
# vector of colors
op = par(bg = "darkorchid4")
plot(as.phylo(hc), type = "fan", tip.color = "gold", edge.color ="gold", cex=.8)
# cutting dendrogram in 85 clusters
clusdf=data.frame(Symbol=names(cutree(hc, 85)), clus=cutree(hc, 85))
clusdf2=merge(clusdf, data[,c(1,2)], by="Symbol")
sizes=sqldf("SELECT * FROM (SELECT clus, count(*) as size FROM clusdf GROUP BY 1) as T00 WHERE size>=2")
sizes2=merge(subset(sizes, size==2), clusdf2, by="clus")
sizes2$id=sequence(rle(sizes2$clus)$lengths)
couples=merge(subset(sizes2, id==1)[,c(1,3,4)], subset(sizes2, id==2)[,c(1,3,4)], by="clus")
couples$"Company 1"=apply(couples[ , c(2,3) ] , 1 , paste , collapse = " -" )
couples$"Company 2"=apply(couples[ , c(4,5) ] , 1 , paste , collapse = " -" )
CouplesTable=gvisTable(couples[,c(6,7)])
plot(CouplesTable)
# Plots
opts2=theme(
    panel.background = element_rect(fill="gray98"),
    panel.border = element_rect(colour="black", fill=NA),
    axis.line = element_line(size = 0.5, colour = "black"),
    axis.ticks = element_line(colour="black"),
    panel.grid.major = element_line(colour="gray75", linetype = 2),
    panel.grid.minor = element_blank(),
    axis.text = element_text(colour="gray25", size=12),
    axis.title = element_text(size=18, colour="gray10"),
    legend.key = element_rect(fill = "white"),
    legend.text = element_text(size = 14),
    legend.background = element_rect(),
    plot.title = element_text(size = 35, colour="gray10"))
plotPair = function(Symbol1, Symbol2)
{
    getSymbols(Symbol1)
    getSymbols(Symbol2)
    close1=Cl(eval(parse(text=Symbol1)))
    close2=Cl(eval(parse(text=Symbol2)))
    cls=merge(close1, close2, all = FALSE)
    df=data.frame(date = time(cls), coredata(cls))
    names(df)[-1]=c(Symbol1, Symbol2)
    df1=melt(df, id.vars = "date", measure.vars = c(Symbol1, Symbol2))
    ggplot(df1, aes(x = date, y = value, color = variable))+
        geom_line(size = I(1.2))+
        scale_color_discrete(name = "")+
        scale_x_date(labels = date_format("%Y-%m-%d"))+
        labs(x="Date", y="Closing Price")+
        opts2
}
p1=plotPair("ADI", "DISCA")
p2=plotPair("PCAR", "PAYX")
p3=plotPair("CA", "BBBY")
p4=plotPair("FOX", "EBAY")
grid.arrange(p1, p2, p3, p4, ncol=2)
