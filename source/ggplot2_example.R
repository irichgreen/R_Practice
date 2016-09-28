anscombe 

library(ggplot2)
library(dplyr)
library(reshape2)

setA=select(anscombe, x=x1,y=y1)
setB=select(anscombe, x=x2,y=y2)
setC=select(anscombe, x=x3,y=y3)
setD=select(anscombe, x=x4,y=y4)

setA$group ='SetA'
setB$group ='SetB'
setC$group ='SetC'
setD$group ='SetD'

head(setA,4)  # showing sample data points from setA
all_data=rbind(setA,setB,setC,setD)  # merging all the four data sets
all_data[c(1,13,23,43),]  # showing sample

summary_stats =all_data%>%group_by(group)%>%summarize("mean x"=mean(x),
"Sample variance x"=var(x), "mean y"=round(mean(y),2), "Sample variance y"=round(var(y),1), 'Correlation between x and y '=round(cor(x,y),2))

models = all_data %>% 
    group_by(group) %>%
    do(mod = lm(y ~ x, data = .)) %>%
    do(data.frame(var = names(coef(.$mod)),
                  coef = round(coef(.$mod),2),
                  group = .$group)) %>%
    dcast(., group~var, value.var = "coef")

summary_stats_and_linear_fit = cbind(summary_stats, data_frame("Linear regression" =
                                                                   paste0("y = ",models$"(Intercept)"," + ",models$x,"x")))

summary_stats_and_linear_fit

ggplot(all_data, aes(x=x,y=y)) +geom_point(shape = 21, colour = "red", fill = "orange", size = 3)+
    ggtitle("Anscombe's data sets")+geom_smooth(method = "lm",se = FALSE,color='blue') + 
    facet_wrap(~group, scales="free")


library(dplyr)
library(ggplot2)

create_file_and_plot = function(name){
    path = paste(getwd(),"/",name,".png",sep = '') %>% 
        file.path() %>% 
        png(,width=960,height=480)
    eval(parse(text=paste0("print(ggplot(data=diamonds, aes(carat,price ))+ geom_point(aes(colour=  color))+", name,"())")))
    dev.off()
}

sapply(c("theme_bw", "theme_dark"), create_file_and_plot)


