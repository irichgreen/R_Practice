if (!require(devtools)) install.packages("devtools")
devtools::install_github('rstudio/leaflet')
devtools::install_github("rstudio/d3heatmap")

library(d3heatmap)
d3heatmap(scale(mtcars), colors = "Blues", theme = "dark")
