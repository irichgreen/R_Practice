download.file(destfile = "fargoTemps2014.csv", url="https://raw.githubusercontent.com/smach/Rin5lines/master/data/fargoTemps2014.csv") 

fargo <- read.csv("fargoTemps2014.csv", colClasses = c("Date", "integer", "integer"))

library("googleVis")
mychart <- gvisLineChart(fargo, options=list(gvis.editor="Edit this chart", width=1000, height=600))
plot(mychart)

vignette("googleVis_examples", package="googleVis") .

?vignette

## ------------------------------------------------

install.packages("googleVis")
library(googleVis)
data(Fruits)
M1 <- gvisMotionChart(Fruits, idvar="Fruit", timevar="Year")
plot(M1)

# googleVis
data(Exports)
*#Global,
G1 <- gvisGeoChart(Exports, locationvar = 'Country', colorvar='Profit')
plot(G1)

*#Plot, only Europe
G2 <- gvisGeoChart(Exports, "Country", "Profit", options=list(region="150"))
plot(G2)

*#Example, showing US data by state
states <- data.frame(state.name, state.x77)
G3 <- gvisGeoChart(states, "state.name", "Illiteracy", options=list(region="US", displayMode="regions", resolution = "provinces", width=600, height=400))
plot(G3)
G4 <- gvisGeoChart(CityPopularity, locationvar='City', colorvar='Popularity', options = list(region='US', height=350, displayMode = 'markers', colorAxis="{values:[200,400,600,800], colors:[\'red', \'pink\', \'orange', \'green']}"))
plot(G4)
G5 <- gvisGeoChart(Andrew, "LatLong", colorvar = 'Speed_kt', options=list(region="US"))
plot(G5)
G6 <- gvisGeoChart(Andrew, "LatLong", sizevar = 'Speed_kt', colorvar = "Pressure_mb", options=list(region="US"))
plot(G6)

require(stats)
data(quakes)
head(quakes)
quakes$latlong <- paste(quakes$lat, quakes$long, sep=":")
G7 <- gvisGeoChart(quakes, "latlong", "depth", "mag", options = list(displayMode = "Markers", region="009", colorAxis ="{colors : ['red', 'grey']}", backgroundColor="lightblue"))
plot(G7)

install.packages("XML")
library(XML)
url <- "http://en.wikipedia.org/…/List_of_countries_by_credit_rating"
x <- readHTMLTable(readLines(url), which=3)
levels(x$Rating) <- substring(levels(x$Rating), 4, nchar(levels(x$Rating)))
x$Ranking <- x$Rating
levels(x$Ranking) <- nlevels(x$Rating) : 1
x$Ranking <- as.character(x$Ranking)
x$Rating <- paste(x$Country, x$Rating, sep=":")
# Create a geo chart
G8 <- gvisGeoChart(x, "Country", "Ranking", hovervar="Rating", options=list(gvis.editor="S&P", colorAxis="{colors:['*#91BFDB,', '*#FC8D59,']}"))
plot(G8)



Anno <- gvisAnnotationChart(Stock, datevar="Date", numvar="Value", idvar="Device", titlevar="Title", annotationvar="Annotation", options=list(width=600, height=350, fill=10, displayExactValues=TRUE, colors="['#0000ff','#00ff00']"))
plot(Anno)


datSK <- data.frame(From=c(rep("A",3), rep("B", 3)),
                    To=c(rep(c("X", "Y", "Z"),2)),
                    Weight=c(5,7,6,2,9,4))

Sankey <- gvisSankey(datSK, from="From", to="To", weight="Weight",
                     options=list(
                         sankey="{link: {color: { fill: '#d799ae' } },
                         node: { color: { fill: '#a61d4c' },
                         label: { color: '#871b47' } }}"))
plot(Sankey)


# Calendar Chart
Cal <- gvisCalendar(Cairo, datevar="Date", numvar="Temp", options=list(title="Daily temperature in Cairo", height=320, calendar="{yearLabel: { fontName: 'Times-Roman', fontSize: 32, color: '#1A8763', bold: true}, cellSize: 10, cellColor: { stroke: 'red', strokeOpacity: 0.2 }, focusedCellColor: {stroke:'red'}}"))
plot(Cal)
