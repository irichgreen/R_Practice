library(ggplot2)
ggplot(iris, aes(x = Sepal.Width)) +
    geom_histogram()

ggplot(iris, aes(x = Sepal.Width, fill = Species)) +
    geom_histogram()

ggplot(iris, aes(x = Sepal.Width)) +
    geom_histogram() +
    facet_wrap(~ Species)

d <- iris        # Full data set
d_bg <- d[, -5]  # Background Data - full without the 5th column (Species)

ggplot(d, aes(x = Sepal.Width, fill = Species)) +
    geom_histogram(data = d_bg, fill = "grey", alpha = .5) +
    geom_histogram(colour = "black") +
    facet_wrap(~ Species) +
    guides(fill = FALSE) +  # to remove the legend
    theme_bw()              # for clean look overall

ggplot(d, aes(x = Sepal.Width, y = Sepal.Length)) +
    geom_point(data = d_bg, colour = "grey") +
    geom_point() + 
    facet_wrap(~ Species)

ggplot(d, aes(x = Sepal.Width, y = Sepal.Length, colour = Species)) +
    geom_point(data = d_bg, colour = "grey", alpha = .2) +
    geom_point() + 
    facet_wrap(~ Species) +
    guides(colour = FALSE) +
    theme_bw()

# install.packages("nycflights13")
library(nycflights13)
library(dplyr)

usa_map <- map_data("usa")

airports <- read.csv("https://raw.githubusercontent.com/jpatokal/openflights/master/data/airports.dat", stringsAsFactors = FALSE, header = FALSE)
airports <- airports[, c(5, 7, 8)]
names(airports) <- c("code", "lat", "long")
orig <- airports %>% dplyr::rename(origin = code, long_o = long, lat_o = lat)
dest <- airports %>% dplyr::rename(dest = code, long_d = long, lat_d = lat)

d <- flights %>%
    left_join(orig) %>% 
    left_join(dest) %>% 
    filter(carrier %in% c("AS", "F9", "OO", "YV", "VX", "FL"))

d_bg <- d %>% select(-carrier)

ggplot(d) +
    geom_polygon(data = usa_map, aes(long, lat, group = region)) +
    geom_segment(data = d_bg, colour = "grey", alpha = .7,
                 aes(x = long_o, y = lat_o,
                     xend = long_d, yend = lat_d)) +
    geom_segment(aes(x = long_o, y = lat_o,
                     xend = long_d, yend = lat_d,
                     colour = carrier)) +
    facet_wrap(~ carrier) +
    guides(colour = FALSE) +
    theme_bw()
