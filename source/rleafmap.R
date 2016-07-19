devtools::install_github("fkeck/rleafmap")
devtools::install_github("Hackout2/epimap")
library(rleafmap)
library(epimap)

data(cholera)
n.chol <- ifelse(cholera$deaths$Count > 4, 6, cholera$deaths$Count) + 2

# Basemap layer
cdbpos.bm <- basemap("cartodb.positron.nolab")

# Legends
death.leg <- layerLegend(style = "points", title = "Deaths",
                         labels = c("1", "2", "3", "4", "> 4"), size = c(3, 4, 5, 6, 8),
                         fill.col = "red", fill.alpha = 0.9)
pumps.leg <- layerLegend(style = "icons", title = NA, labels = "Water pump",
                         png = "/home/francois/water.png", png.width = 31, png.height = 31)

# Data layers
death.points <- spLayer(cholera$deaths, legend = death.leg,
                        size = n.chol, fill.col =  "red", fill.alpha = 0.9)
pumps.points <- spLayer(cholera$pumps, legend = pumps.leg,
                        png = "/home/francois/water.png",
                        png.width=31, png.height=31)

my.ui <- ui(layers = "topright")

writeMap(cdbpos.bm, pumps.points, death.points, interface = my.ui,
         setView = c(51.5135, -0.137), setZoom = 17)

