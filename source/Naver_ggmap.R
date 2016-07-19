eq <- read.table(url("http://dl.dropbox.com/u/8686172/eq.csv", encoding = "euc-kr"), 
                 sep = "\t", header = T, stringsAsFactors = F)

eq$latitude <- unlist(strsplit(eq$latitude, " "))[seq(from = 1, to = nrow(eq), 
                                                      by = 2)]
eq$longitude <- unlist(strsplit(eq$longitude, " "))[seq(from = 1, to = nrow(eq), 
                                                        by = 2)]

library(lubridate)
eq$longitude <- as.double(eq$longitude)
eq$latitude <- as.double(eq$latitude)
eq$year <- as.factor(substr(eq$date, 1, 4))
eq$date <- ymd_hm(eq$date)

cent <- c(126.96136, 37.52962)

install.packages("ggmap")
library(ggmap)
library(devtools)
install_github("ggmap", "haven-jeon")

bmap <- ggmap(get_navermap(center = cent, level = 4, baselayer = "default", 
                           overlayers = c("anno_satellite", "traffic"), marker = data.frame(cent[1], 
                                                                                            cent[2]), key = "c75a09166a38196955adee04d3a51bf8", uri = "www.r-project.org"), 
              extent = "device", base_layer = ggplot(eq, aes(x = longitude, y = latitude)))

bmap + geom_point(aes(size = power, colour = date), data = eq, alpha = 0.7) + 
    geom_density2d()
