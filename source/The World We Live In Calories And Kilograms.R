library(xlsx)
library(dplyr)
library(ggplot2)
library(scales)
#setwd("YOUR WORKING DIRECTORY HERE")
url_calories = "http://www.fao.org/fileadmin/templates/ess/documents/food_security_statistics/FoodConsumptionNutrients_en.xls"
download.file(url_calories, method="internal", destfile = "FoodConsumptionNutrients_en.xls", mode = "ab")
calories = read.xlsx(file="FoodConsumptionNutrients_en.xls", startRow = 4, colIndex = c(2,6), colClasses = c("character", "numeric"), sheetName="Dietary Energy Cons. Countries", stringsAsFactors=FALSE) 
colnames(calories)=c("Country", "Kcal")
url_population = "http://esa.un.org/unpd/wpp/DVD/Files/1_Excel%20(Standard)/EXCEL_FILES/1_Population/WPP2015_POP_F01_1_TOTAL_POPULATION_BOTH_SEXES.XLS"
download.file(url_population, method="internal", destfile = "Population.xls", mode = "ab")
population = read.xlsx(file="Population.xls", startRow = 17, colIndex = c(3,71), colClasses = c("character", "numeric"), sheetName="ESTIMATES", stringsAsFactors=FALSE) 
colnames(population)=c("Country", "Population")
# http://apps.who.int/gho/data/node.main.A900A?lang=en
url_obesity = "http://apps.who.int/gho/athena/data/xmart.csv?target=GHO/NCD_BMI_30A&profile=crosstable&filter=AGEGROUP:*;COUNTRY:*;SEX:*&x-sideaxis=COUNTRY&x-topaxis=GHO;YEAR;AGEGROUP;SEX&x-collapse=true"
obesity = read.csv(file=url_obesity, stringsAsFactors=FALSE)
obesity %>% select(matches("Country|2014.*Both")) -> obesity
colnames(obesity)=c("Country", "Obesity")
obesity %>% filter(Obesity!="No data") -> obesity
obesity %>% mutate(Obesity=as.numeric(substr(Obesity, 1, regexpr(pattern = "[[]", obesity$Obesity)-1))) -> obesity
population %>% inner_join(calories,by = "Country") %>% inner_join(obesity,by = "Country") -> data
opts=theme(
    panel.background = element_rect(fill="gray98"),
    panel.border = element_rect(colour="black", fill=NA),
    axis.line = element_line(size = 0.5, colour = "black"),
    axis.ticks = element_line(colour="black"),
    panel.grid.major = element_line(colour="gray75", linetype = 2),
    panel.grid.minor = element_blank(),
    axis.text = element_text(colour="gray25", size=15),
    axis.title = element_text(size=18, colour="gray10"),
    legend.key = element_blank(),
    legend.position = "none",
    legend.background = element_blank(),
    plot.title = element_text(size = 40, colour="gray10"))
ggplot(data, aes(x=Kcal, y=Obesity/100, size=log(Population), label=Country), guide=FALSE)+
    geom_point(colour="white", fill="sandybrown", shape=21, alpha=.55)+
    scale_size_continuous(range=c(2,40))+
    scale_x_continuous(limits=c(1500,4100))+
    scale_y_continuous(labels = percent)+
    labs(title="The World We Live In #5: Calories And Kilograms",
         x="Dietary Energy Consumption (kcal/person/day)",
         y="% population with body mass index >= 30 kg/m2")+
    geom_text(data=subset(data, Obesity>35|Kcal>3700), size=5.5, colour="gray25", hjust=0, vjust=0)+
    geom_text(data=subset(data, Kcal<2000), size=5.5, colour="gray25", hjust=0, vjust=0)+
    geom_text(data=subset(data, Obesity<10 & Kcal>2600), size=5.5, colour="gray25", hjust=0, vjust=0)+
    geom_text(aes(3100, .01), colour="gray25", hjust=0, label="Source: United Nations (size of bubble depending on population)", size=4.5)+opts

