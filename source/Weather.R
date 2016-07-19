library(ggplot2)  # FYI you need v2.0
library(dplyr)    # yes, i could have not done this and just used 'subset' instead of 'filter'
#devtools::install_github("hrbrmstr/ggalt")
library(ggalt)    # devtools::install_github("hrbrmstr/ggalt")
library(ggthemes) # theme_map and tableau colors
world <- map_data("world")
world <- world[world$region != "Antarctica",] # intercourse antarctica

dat <- read.csv("CLIWOC15.csv")        # having factors here by default isn't a bad thing
dat <- filter(dat, Nation != "Sweden") # I kinda feel bad for Sweden but 4 panels look better than 5 and it doesn't have much data

gg <- ggplot()
gg <- gg + geom_map(data=world, map=world,
                    aes(x=long, y=lat, map_id=region),
                    color="white", fill="#7f7f7f", size=0.05, alpha=1/4)
gg <- gg + geom_point(data=dat, 
                      aes(x=Lon3, y=Lat3, color=Nation), 
                      size=0.15, alpha=1/100)
gg <- gg + scale_color_tableau()
gg <- gg + coord_proj("+proj=wintri")
gg <- gg + facet_wrap(~Nation)
gg <- gg + theme_map()
gg <- gg + theme(strip.background=element_blank())
gg <- gg + theme(legend.position="none")
gg
