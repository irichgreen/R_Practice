library(leaflet)

download.file("http://carte-gps-gratuite.fr/radars/zones-de-danger-destinator.zip","radar.zip")
unzip("radar.zip")

ext_radar=function(nf){
    radar=read.table(file=paste("destinator/",nf,sep=""), sep = ",", header = FALSE, stringsAsFactors = FALSE)
    radar$type <- sapply(radar$V3, function(x) {z=as.numeric(unlist(strsplit(x, " ")[[1]])); return(z[!is.na(z)])})
    radar <- radar[,c(1,2,4)]
    names(radar) <- c("lon", "lat", "type")
    return(radar)}

L=list.files("./destinator/")
nl=nchar(L)
id=which(substr(L,4,8)=="Radar" & substr(L,nl-2,nl)=="csv")

radar_E=NULL
for(i in id) radar_E=rbind(radar_E,ext_radar(L[i]))

fileUrl <- "http://evadeo.typepad.fr/.a/6a00d8341c87ef53ef01310f9238e6970c-800wi"
download.file(fileUrl,"radar.png", mode = 'wb')
RadarICON <- makeIcon(  iconUrl = fileUrl,   iconWidth = 20, iconHeight = 20)

m <- leaflet(data = radar_E) 
m <- m %>% addTiles() 
m <- m %>% addMarkers(~lon, ~lat, icon = RadarICON, popup = ~as.character(type))
m
