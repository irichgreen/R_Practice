install.packages("rgdal")
install.packages("classInt")
install.packages("fields")
library("rgdal")
library("RColorBrewer")
library("classInt")
#library("SmarterPoland")
library(fields)

# create a new empty object called 'temp' in which to store a zip file
# containing boundary data
# temp <- tempfile(fileext = ".zip")
# now download the zip file from its location on the Eurostat website and
# put it into the temp object
# new Eurostat website
# old: http://epp.eurostat.ec.europa.eu
# new: http://ec.europa.eu/eurostat
# 
# download.file(
# "http://ec.europa.eu/eurostat/cache/GISCO/geodatafiles/NUTS_2010_60M_SH.zip",temp)
# now unzip the boundary data
# unzip(temp)

EU_NUTS <- readOGR(dsn = "./NUTS_2010_60M_SH/data", layer = "NUTS_RG_60M_2010")
ToRemove <- EU_NUTS@data$STAT_LEVL!=2 | grepl('FR9',EU_NUTS@data$NUTS_ID)
EUN <- EU_NUTS[!ToRemove,]

## OGR data source with driver: ESRI Shapefile 
## Source: "./NUTS_2010_60M_SH/data", layer: "NUTS_RG_60M_2010"
## with 1920 features and 4 fields
## Feature type: wkbPolygon with 2 dimensions
#plot(EU_NUTS)

myunempl <- read.csv('lfst_r_lfu3rt.csv',na=':',skip=10)

#EU_NUTS <- spTransform(EU_NUTS, CRS("+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs"))

EUN@data = data.frame(EUN@data[,1:4], myunempl[
        match(EUN@data[, "NUTS_ID"],myunempl[, "GEO.TIME"]),   ])

EUN <- EUN[!is.na(EUN@data$X2014),]

plot <- plot(EUN, col = rgb(colorRamp(
            c('darkGreen','springgreen','Yellow','Orange',
                'Dark Blue','Light Blue','Purple','Red'))
 ((EUN@data$X2014-min(EUN@data$X2014))/
     (max(EUN@data$X2014)-min(EUN@data$X2014)))/255), 
 axes = FALSE, border = NA)    

image.plot(add=TRUE,
    zlim=c(min(EUN@data$X2014),max(EUN@data$X2014)),
    col=rgb(colorRamp(
        c('darkGreen','springgreen','Yellow','Orange',
            'Dark Blue','Light Blue','Purple','Red'))(seq(0,1,length.out=50))/255),
    legend.only=TRUE,
    smallplot=c(.02,.06,.15,.85))