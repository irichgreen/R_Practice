install.packages("gtrendsR")
install.packages("outliers")
install.packages("highcharter")
library(gtrendsR)
library(rvest)
library(dplyr)
library(stringr)
library(forecast)
library(outliers)
library(highcharter)
library(ggplot2)
library(scales)

x="https://en.wikipedia.org/wiki/Companion_dog"
read_html(x) %>% 
    html_nodes("ul:nth-child(19)") %>% 
    html_text() %>% 
    strsplit(., "\n") %>% 
    unlist() -> breeds

breeds=iconv(breeds[breeds!= ""], "UTF-8")

usr <- "anvaksa@gmail.com"
psw <- "wlsgns2k"
gconnect(usr, psw)

#Reference
ref="King Charles Spaniel"

#New set
breeds=setdiff(breeds, ref)

#Subsets. Do not worry about warning message
sub.breeds=split(breeds, 1:ceiling(length(breeds)/4))

results=list()
for (i in 1:length(sub.breeds))
{
    res <- gtrends(unlist(union(ref, sub.breeds[i])), 
                   start_date = Sys.Date()-180,
                   cat="0-66",
                   geo="US")
    results[[i]]=res
}

trends=data.frame(name=character(0), level=numeric(0), trend=numeric(0))
for (i in 1:length(results))
{
    df=results[[i]]$trend
    lr=mean(results[[i]]$trend[,3]/results[[1]]$trend[,3])
    for (j in 3:ncol(df))
    {
        s=rm.outlier(df[,j], fill = TRUE)
        t=mean(diff(ma(s, order=2))/ma(s, order=2), na.rm = T)
        l=mean(results[[i]]$trend[,j]/lr)
        trends=rbind(data.frame(name=colnames(df)[j], level=l, trend=t), trends)
    }
}

trends %>% 
    group_by(name) %>% 
    summarize(level=mean(level), trend=mean(trend*100)) %>% 
    filter(level>0 & trend > -10 & level<500) %>% 
    na.omit() %>% 
    mutate(name=str_replace_all(name, ".US","")) %>% 
    mutate(name=str_replace_all(name ,"[[:punct:]]"," ")) %>% 
    rename(
        x = trend,
        y = level
    ) -> trends
trends$y=(trends$y/max(trends$y))*100

#Dinamic chart as The Economist
highchart() %>% 
    hc_title(text = "The Hype Bubble Map for Dog Breeds") %>%
    hc_subtitle(text = "According Last 6 Months of Google Searchings") %>% 
    hc_xAxis(title = list(text = "Trend"), labels = list(format = "{value}%")) %>% 
    hc_yAxis(title = list(text = "Level")) %>% 
    hc_add_theme(hc_theme_economist()) %>%
    hc_add_series(data = list.parse3(trends), type = "bubble", showInLegend=FALSE, maxSize=40) %>% 
    hc_tooltip(formatter = JS("function(){
                              return ('<b>Trend: </b>' + Highcharts.numberFormat(this.x, 2)+'%' + '<br><b>Level: </b>' + Highcharts.numberFormat(this.y, 2) + '<br><b>Breed: </b>' + this.point.name)
                              }"))
 
#Static chart
opts=theme(
    panel.background = element_rect(fill="gray98"),
    panel.border = element_rect(colour="black", fill=NA),
    axis.line = element_line(size = 0.5, colour = "black"),
    axis.ticks = element_line(colour="black"),
    panel.grid.major = element_line(colour="gray75", linetype = 2),
    panel.grid.minor = element_blank(),
    axis.text.y = element_text(colour="gray25", size=15),
    axis.text.x = element_text(colour="gray25", size=15),
    text = element_text(size=20),
    legend.key = element_blank(),
    legend.position = "none",
    legend.background = element_blank(),
    plot.title = element_text(size = 30))
ggplot(trends, aes(x=x/100, y=y, label=name), guide=FALSE)+
    geom_point(colour="white", fill="darkorchid2", shape=21, alpha=.3, size=9)+
    scale_size_continuous(range=c(2,40))+
    scale_x_continuous(limits=c(-.02,.02), labels = percent)+
    scale_y_continuous(limits=c(0,100))+
    labs(title="The Hype Bubble Map for Dog Breeds",
         x="Trend",
         y="Level")+
    geom_text(data=subset(trends, x> .2 & y > 50), size=4, colour="gray25")+
    geom_text(data=subset(trends, x > .7), size=4, colour="gray25")+opts
