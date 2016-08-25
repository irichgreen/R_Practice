## Plot all Starbucks locations using OpenStreetMap
## Credit: http://www.computerworld.com/article/2893271/business-intelligence/5-data-visualizations-in-5-minutes-each-in-5-lines-or-less-of-r.html
install.packages("checkpoint")
library(checkpoint)
checkpoint("2016-08-22")

file <- "https://opendata.socrata.com/api/views/ddym-zvjk/rows.csv"
starbucks <- read.csv(file)
library(leaflet); library(magrittr)
leaflet() %>% addTiles() %>% setView(-84.3847, 33.7613, zoom = 16) %>% 
    addMarkers(data = starbucks, lat = ~ Latitude, lng = ~ Longitude, popup = starbucks$Name)

## Plot last 6 months of ANTM share price
## Credit: http://www.computerworld.com/article/2893271/business-intelligence/5-data-visualizations-in-5-minutes-each-in-5-lines-or-less-of-r.html
library(checkpoint)
checkpoint("2016-08-22")

library(quantmod)
getSymbols("ANTM", auto.assign=TRUE)
barChart(ANTM, subset = 'last 6 months')
view raw

## Plot Atlanta area unemployment
## Credit: http://www.computerworld.com/article/2893271/business-intelligence/5-data-visualizations-in-5-minutes-each-in-5-lines-or-less-of-r.html
library(checkpoint)
checkpoint("2016-08-22")

library(quantmod)
getSymbols("ATLA013URN", src = "FRED")
names(ATLA013URN) = "rate"
library(dygraphs)
dygraph(ATLA013URN, main = "Atlanta area unemployment")

## Credit: http://www.computerworld.com/article/2893271/business-intelligence/5-data-visualizations-in-5-minutes-each-in-5-lines-or-less-of-r.html
library(checkpoint)
checkpoint("2016-08-22")

## Correlation plot
file <- "https://github.com/smach/NICAR15data/raw/master/testscores.csv"
testdata <- read.csv(file, stringsAsFactors = FALSE)
library(ggvis)
ggvis(testdata, ~ pctpoor, ~ score) %>%
    layer_points(size := input_slider(10, 310, label = "Point size"), opacity := input_slider(0, 1, label = "Point opacity")) %>%
    layer_model_predictions(model = "lm", stroke := "red", fill := "red")

# and for a correlation matrix 
mycorr <- cor(na.omit(testdata[3:6]))
library(corrplot)
col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
corrplot(mycorr, method = "shade", shade.col = NA, tl.col = "black", tl.srt = 45, col = col(200), addCoef.col = "black")

