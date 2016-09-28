
#devtools::install_github("ropensci/plotly")

library(plotly)
library(zoo)
library(data.table)

# Load Airpassengers data set
data("AirPassengers")

# Create data frame with year and month
AirPassengers <- zoo(coredata(AirPassengers), order.by = as.yearmon(index(AirPassengers)))
df <- data.frame(month = format(index(AirPassengers), "%b"),
                 year =  format(index(AirPassengers), "%Y"),
                 value = coredata(AirPassengers))

# Get coordinates for plotting
#Angles for each month
nMonths <- length(unique(df$month))
theta <- seq(0, 2*pi, by = (2*pi)/nMonths)[-(nMonths+1)]

# Append these angles to the data frame
df$theta <- rep(theta, nMonths)

# Cumulatively sum number of passgengers
dt <- as.data.table(df)
dt[,cumvalue := cumsum(value), by = month]
df <- as.data.frame(dt)

# Cartesian coordinates (x, y) space will be value*cos(theta) and value*sin(theta)
df$x <- df$cumvalue * cos(df$theta)
df$y <- df$cumvalue * sin(df$theta)

# Create hovertext
df$hovertext <- paste("Year:", df$year, "<br>",
                      "Month:", df$month, "<br>",
                      "Passegers:", df$value)

# Repeat January values
ddf <- data.frame()
for(i in unique(df$year)){
    temp <- subset(df, year == i)
    temp <- rbind(temp, temp[1,])
    ddf <- rbind(ddf, temp)
}

df <- ddf

# Plot
colorramp <- colorRampPalette(c("#bfbfbf", "#f2f2f2"))
cols <- colorramp(12)

cols <- rep(c("#e6e6e6", "#f2f2f2"), 6)

linecolor <- "#737373"

p <- plot_ly(subset(df, year == 1949), x = ~x, y = ~y, hoverinfo = "text", text = ~hovertext,
             type = "scatter", mode = "lines",
             line = list(shape = "spline", color = linecolor))

k <- 2
for(i in unique(df$year)[-1]){
    p <- add_trace(p, data = subset(df, year == i), 
                   x = ~x, y = ~y, hoverinfo = "text", text = ~hovertext,
                   type = "scatter", mode = "lines",
                   line = list(shape = "spline", color = linecolor),
                   fillcolor = cols[k], fill = "tonexty")
    
    k <- k + 1
}

start <- 100
end <- 4350
axisdf <- data.frame(x = start*cos(theta), y = start*sin(theta),
                     xend = end*cos(theta), yend = end*sin(theta))

p <- add_segments(p = p, data = axisdf, x = ~x, y = ~y, xend = ~xend, yend = ~yend, inherit = F,
                  line = list(dash = "8px", color = "#737373", width = 4),
                  opacity = 0.7)

p <- add_text(p, x = (end + 200)*cos(theta), y = (end + 200)*sin(theta), text = unique(df$month), inherit = F,
              textfont = list(color = "black", size = 18))

p <- layout(p, showlegend = F,
            title = "Radial Stacked Area Chart",
            xaxis = list(showgrid = F, zeroline = F, showticklabels = F, domain = c(0.25, 0.80)),
            yaxis = list(showgrid = F, zeroline = F, showticklabels = F),
            length = 1024,
            height = 600)

p
