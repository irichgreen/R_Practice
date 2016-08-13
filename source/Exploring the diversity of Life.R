# http://www.r-bloggers.com/exploring-the-diversity-of-life-using-rvest-and-the-catalog-of-life/
# load the packages
library(rvest)
library(ggplot2)
library(scales)#for comma separator in ggplot2 axis

#read the data
col<-read_html("http://www.catalogueoflife.org/col/info/totals")
col%>%
    html_table(header=TRUE)->sp_list  
sp_list<-sp_list[[1]]
#some minor data re-formatting
#re-format the data frame keeping only animals, plants and
#fungi
sp_list<-sp_list[c(3:37,90:94,98:105),-4]
#add a kingdom column
sp_list$kingdom<-rep(c("Animalia","Fungi","Plantae"),times=c(35,5,8))
#remove the nasty commas and turn into numeric
sp_list[,2]<-as.numeric(gsub(",","",sp_list[,2]))
sp_list[,3]<-as.numeric(gsub(",","",sp_list[,3]))
names(sp_list)[2:3]<-c("Nb_Species_Col","Nb_Species")

# Now we are read to make the first plot

ggplot(sp_list,aes(x=Taxon,y=Nb_Species,fill=kingdom))+
    geom_bar(stat="identity")+
    coord_flip()+
    scale_fill_discrete(name="Kingdom")+
    labs(y="Number of Species",x="",title="The diversity of life")

subs<-subset(sp_list,Nb_Species>1000)
subs$Taxon<-factor(subs$Taxon,levels=subs$Taxon[order(subs$Nb_Species)])
ggplot(subs,aes(x=Taxon,y=Nb_Species,fill=kingdom))+
    geom_bar(stat="identity")+
    theme(panel.border=element_rect(linetype="dashed",color="black",fill=NA),
          panel.background=element_rect(fill="white"),
          panel.grid.major.x=element_line(linetype="dotted",color="black"))+
    coord_flip()+
    scale_fill_discrete(name="Kingdom")+
    labs(y="Number of Species",x="",
         title="The diversity of multicellular organisms from the Catalog of Life")+
    scale_y_continuous(expand=c(0,0),limits=c(0,1250000),labels=comma)
