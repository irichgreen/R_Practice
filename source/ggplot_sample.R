pkg <- c("ggplot2","reshape2","RColorBrewer")
inst <- pkg %in% installed.packages()
if(length(pkg[!inst]) > 0) install.packages(pkg[!inst],repos="http://cran.rstudio.com/")
lapply(pkg,require,character.only=TRUE)
rm(list=c("pkg","inst"))

n <- 50
m1 <- data.frame(x=c(rep(0,n),seq(n,1,-1)),
                 y=c(seq(1,n,1),rep(0,n)),
                 group=rep(seq(1,n,1),2))

p1 <- ggplot(data=m1,aes(x=x,y=y,group=group,color=factor(group))) + 
    scale_color_manual(values=rep(brewer.pal(8,"Dark2"),times=n*2)) + 
    geom_line(size=1.0) + 
    theme(legend.position="none",
          axis.title=element_blank(),
          panel.grid=element_blank(),
          axis.text=element_blank(),
          axis.ticks=element_blank())
p1
