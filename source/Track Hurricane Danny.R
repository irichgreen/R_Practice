library(leaflet)
library(stringi)
library(htmltools)
library(RColorBrewer)


danny <- readLines("http://weather.unisys.com/hurricane/atlantic/2015/DANNY/track.dat")


danny_dat <- read.table(textConnection(gsub("TROPICAL ", "TROPICAL_", danny[3:length(danny)])), header=TRUE, stringsAsFactors=FALSE)

# make storm type names prettier
danny_dat$STAT <- stri_trans_totitle(gsub("_", " ", danny_dat$STAT))

# make column names prettier
colnames(danny_dat) <- c("advisory", "lat", "lon", "time", "wind_speed", "pressure", "status")

danny_dat$color <- as.character(factor(danny_dat$status, 
                                       levels=c("Tropical Depression", "Tropical Storm",
                                                "Hurricane-1", "Hurricane-2", "Hurricane-3",
                                                "Hurricane-4", "Hurricane-5"),
                                       labels=rev(brewer.pal(7, "YlOrBr"))))

leaflet() %>% 
    addTiles() %>% 
    addPolylines(data=danny_dat[danny_dat$advisory<=9,], ~lon, ~lat, color=~color) %>% 
    addCircles(data=danny_dat[danny_dat$advisory>9,], ~lon, ~lat, color=~color, fill=~color, radius=25000,
               popup=~sprintf("<b>Advisory forecast for +%dh (%s)</b><hr noshade size='1'/>
                           Position: %3.2f, %3.2f<br/>
                           Expected strength: <span style='color:%s'><strong>%s</strong></span><br/>
                           Forecast wind: %s (knots)<br/>Forecast pressure: %s",
                              htmlEscape(advisory), htmlEscape(time), htmlEscape(lon),
                              htmlEscape(lat), htmlEscape(color), htmlEscape(status), 
                              htmlEscape(wind_speed), htmlEscape(pressure)))

# The entire source code is in this gist and, provided you have the proper packages installed, you can run this at any time with:
devtools::source_gist("e3253ddd353f1a489bb4", sha1="b3e1f13e368d178804405ab6d0bf98a185126a9a")

