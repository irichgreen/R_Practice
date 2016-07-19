library("leaflet")

# Step 1: Create a basic map object and add tiles

mymap <- leaflet()
mymap <- addTiles(mymap)

mymap    # View the empty map by typing the object name:

# Step 2: Set where you want the map to be centered and its zoom level

mymap <- setView(mymap, -84.3847, 33.7613, zoom = 17)
mymap

# Add a pop-up

addPopups(-84.3847, 33.7616, 'Data journalists at work, <b>NICAR 2015</b>')

# And now I’d like to introduce you to a somewhat new chaining function in R: %>%. This takes the results of one function and sends it to the next one, so you don’t have to keep repeating the variable name you’re storing things, similar to the one-character Unix pipe command. We could compact the code above to:
    
mymap <- leaflet() %>% 
    addTiles() %>%
    setView(-84.3847, 33.7613, zoom = 17) %>%
    addPopups(-84.3847, 33.7616, 'Data journalists at work, <b>NICAR 2015</b>')
    
# View the finished product:
        
mymap
    
# Or if you didn’t want to store the results in a variable for now but just work interactively:
        
leaflet() %>% 
    addTiles() %>%
    setView(-84.3847, 33.7613, zoom = 16) %>%
    addPopups(-84.3847, 33.7616, 'Data journalists at work, <b>NICAR 2015</b>'
)

download.file("https://opendata.socrata.com/api/views/ddym-zvjk/rows.csv?accessType=DOWNLOAD", destfile="starbucks.csv")

starbucks <- read.csv("https://opendata.socrata.com/api/views/ddym-zvjk/rows.csv?accessType=DOWNLOAD", stringsAsFactors = FALSE)
str(starbucks)
atlanta <- subset(starbucks, City == "Atlanta" & State == "GA")
leaflet() %>% addTiles() %>% setView(-84.3847, 33.7613, zoom = 16) %>%
    addMarkers(data = atlanta, lat = ~ Latitude, lng = ~ Longitude,popup = atlanta$Name) %>%
    addPopups(-84.3847, 33.7616, 'Data journalists at work, <b>NICAR 2015</b>')
