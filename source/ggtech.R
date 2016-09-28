# Example from https://github.com/ricardo-bion/ggtech
#devtools::install_github("ricardo-bion/ggtech", dependencies=TRUE)
library(ggplot2)
library(ggtech)

# Make sure to install the required fonts 
# (instructions at the end of this file).
extrafont::font_import(pattern = 'Guardian-EgypTT-Text-Regular.ttf', prompt=FALSE)

d <- qplot(carat, data = diamonds[diamonds$color %in%LETTERS[4:7], ], geom = "histogram", bins=30, fill = color)

