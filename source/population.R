require(XML)
require(reshape2)
require(ggplot2)
require(plyr)

get_popdata <- function(country, year) {
    c1 <- "http://www.census.gov/population/international/data/idb/region.php?N=%20Results%20&T=10&A=separate&RT=0&Y="  
    c2 <- "&R=-1&C="
    url <- paste0(c1, year, c2, country)
    df <- data.frame(readHTMLTable(url))
    keep <- c(2, 4, 5)
    df <- df[,keep]  
    names(df) <- c("Age", "Male", "Female")
    cols <- 2:3
    df[,cols] <- apply(df[,cols], 2, function(x) as.numeric(as.character(gsub(",", "", x))))
    df <- df[df$Age != 'Total', ]  
    df
}

KS2016 <- get_popdata("KS",2016)
KS2016

KS2016$Male <- -1 * KS2016$Male
KS2016$Age <- factor(KS2016$Age,levels=KS2016$Age)
longdf <- melt(KS2016,id.vars="Age",value.name="Population",variable.name="Gender")
head(longdf)

p <- ggplot(data=longdf,aes(x=Age,y=Population,fill=Gender))+
    geom_bar(data=subset(longdf, Gender == "Male"), stat = "identity") +
    geom_bar(data=subset(longdf, Gender == "Female"), stat = "identity")  
p

p<- p+coord_flip()
p

require(scales)

human_numbers <- function(x = NULL, smbl =""){
    humanity <- function(y){             
        
        if (!is.na(y)){
            
            b <- round_any(abs(y) / 1e9, 0.1)
            m <- round_any(abs(y) / 1e6, 0.1)
            k <- round_any(abs(y) / 1e3, 0.1)
            
            if ( y >= 0 ){ 
                y_is_positive <- ""
            } else {
                y_is_positive <- "-"
            }
            
            if ( k < 1 ) {
                paste0(y_is_positive, smbl, y )
            } else if ( m < 1){
                paste0 (y_is_positive, smbl,  k , "k")
            } else if (b < 1){
                paste0 (y_is_positive, smbl, m ,"m")
            } else {
                paste0 (y_is_positive, smbl,  comma(b), "b")     
            }
        }
    }
    
    sapply(x,humanity)
}

#' Human versions of large currency numbers - extensible via smbl

human_gbp   <- function(x){human_numbers(x, smbl = "£")}
human_usd   <- function(x){human_numbers(x, smbl = "$")}
human_euro  <- function(x){human_numbers(x, smbl = "€")} 
human_num   <- function(x){human_numbers(x, smbl = "")} 

ggBidirectionalBar=function(data,left=NULL,right=NULL,label=NULL){
    
    data[[left]] <- -1 * data[[left]]
    data[[label]] <- factor(data[[label]],levels=data[[label]])
    longdf <- melt(data,id.vars=label )
    ggplot(longdf, aes_string(y = "value", x = label, fill = "variable")) + 
        geom_bar(data=subset(longdf, variable == left), stat = "identity",alpha=0.7) + 
        geom_bar(data=subset(longdf, variable == right), stat = "identity",alpha=0.7)+  
        coord_flip() + 
        scale_fill_brewer(palette = "Set1") + 
        theme_bw()+theme(legend.position=c(0.15,0.92))+
        guides(fill=guide_legend(title=NULL,reverse=TRUE))+
        scale_y_continuous(labels=human_num)+ylab("")
}

JA2016=get_popdata("JA",2016)
ggBidirectionalBar(data=JA2016,left="Male",right="Female",label="Age")

PopPyramid=function(country,year){
    popdata=get_popdata(country,year)
    ggBidirectionalBar(data=popdata,left="Male",right="Female",label="Age")+
        ggtitle(paste("Population",country,year))+ylab("Population")
}

PopPyramid("KN",2016)

PopPyramid("NI",2016)

PopPyramid("VQ",2016)
