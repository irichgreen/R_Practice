# load and clean data that appears in the figures

library(reshape2)
library(plyr)
library(maps)
library(ggplot2)
library(ggsubplot)

install.packages("ggsubplot")

# getbox by Heike Hoffman, trims map polygons for figure backgrounds
# https://github.com/ggobi/paper-climate/blob/master/code/maps.r
getbox <- function (map, xlim, ylim) {
    # identify all regions involved
    small <- subset(map, (long > xlim[1]) & (long < xlim[2]) & (lat > ylim[1]) & (lat < ylim[2]))
    regions <- unique(small$region)
    small <- subset(map, region %in% regions)  
    
    # now shrink all nodes back to the bounding box
    small$long <- pmax(small$long, xlim[1])
    small$long <- pmin(small$long, xlim[2])
    small$lat <- pmax(small$lat, ylim[1])
    small$lat <- pmin(small$lat, ylim[2])
    
    # Remove slivvers
    small <- ddply(small, "group", function(df) {
        if (diff(range(df$long)) < 1e-6) return(NULL)
        if (diff(range(df$lat)) < 1e-6) return(NULL)
        df
    })
    
    small
}


## Afghanistan for Figures 2 and 3
afghanistan <- getbox(world, c(60,75), c(28, 39))
map_afghan <- list(
    geom_polygon(aes(long, lat, group = group), data = afghanistan, 
                 fill = "grey80", colour = "white", inherit.aes = FALSE, 
                 show_guide = FALSE),
    scale_x_continuous("", breaks = NULL, expand = c(0.02, 0)),
    scale_y_continuous("", breaks = NULL, expand = c(0.02, 0)))

## Mexico and lower US for Figure 4
north_america <- getbox(both, xlim = c(-107.5, -80), ylim = c(11, 37.5))
map_north <- list(
    geom_polygon(aes(long, lat, group = group), data = north_america, fill = "grey80", 
                 colour = "grey70", inherit.aes = FALSE, show_guide = FALSE),
    scale_x_continuous("", breaks = NULL, expand = c(0.02, 0)),
    scale_y_continuous("", breaks = NULL, expand = c(0.02, 0))) 

###############################################################
###                wikileaks Afghan War Diary               ###
###############################################################

# casualties data set loaded with ggsubplot and used as is in figure 2
# regional casualty data included as a supplemental file to paper
# how about casualties over time in different parts of the country?
load("casualties-by-region.RData")

###############################################################
###                       Figure 2                          ###
###############################################################

# Figure 2.a. raw Afghanistan casualty data
ggplot(casualties) + 
    map_afghan +
    geom_point(aes(lon, lat, color = victim), size = 1.75) +
    ggtitle("location of casualties by type") + 
    coord_map() +
    scale_colour_manual(values = rev(brewer.pal(5,"Blues"))[1:4])
ggsave("afgpoints.pdf", width = 7, height = 7)



# Figure 2.b. Afghanistan casualty heat map
ggplot(casualties) + 
    map_afghan +
    geom_bin2d(aes(lon, lat), bins = 15) +
    ggtitle("number of casualties by location") +
    scale_fill_continuous(guide = guide_legend()) +
    coord_map()
ggsave("afgtile.pdf", width = 7, height = 7)



# Figure 2.c. Afghanistan casualty embedded bar graphs (marginal distributions)
ggplot(casualties) + 
    map_afghan +
    geom_subplot2d(aes(lon, lat, 
                       subplot = geom_bar(aes(victim, ..count.., fill = victim), 
                                          color = rev(brewer.pal(5,"Blues"))[1], size = 1/4)), bins = c(15,12), 
                   ref = NULL, width = rel(0.8), height = rel(1)) + 
    ggtitle("casualty type by locationn(Marginal distribution)") + 
    coord_map() +
    scale_fill_manual(values = rev(brewer.pal(5,"Blues"))[c(1,4,2,3)]) 
ggsave("casualties.pdf", width = 7, height = 7)



# Figure 2.d. Afghanistan casualty embedded bar graphs (conditional distributions)
ggplot(casualties) + 
    map_afghan +
    geom_subplot2d(aes(lon, lat,
                       subplot = geom_bar(aes(victim, ..count.., fill = victim), 
                                          color = rev(brewer.pal(5,"Blues"))[1], size = 1/4)), bins = c(15,12), 
                   ref = ref_box(fill = NA, color = rev(brewer.pal(5,"Blues"))[1]), width = rel(0.7), height = rel(0.6), y_scale = free) + 
    ggtitle("casualty type by locationn(Conditional distribution)") +
    coord_map() +
    scale_fill_manual(values = rev(brewer.pal(5,"Blues"))[c(1,4,2,3)]) 

ggsave("casualties2.pdf", width = 7, height = 7)