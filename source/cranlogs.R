library(cranlogs)
library(plotly)
library(zoo)

# Get data
df <- cran_downloads(packages = c("plotly", "ggplot2"), 
                     from = "2015-10-01", to = "2016-08-01")

# Convert dates
df$date <- as.Date(df$date)

# Make data frame
df <- data.frame(date = unique(df$date),
                 count.plotly = subset(df, package == "plotly")$count,
                 count.ggplot = subset(df, package == "ggplot2")$count)

# Smooth data 
# 5 day moving averages
nWidth <- 5
df <- zoo(df[,-1], order.by = df[,1])
df.smooth <- rollapply(df, width = nWidth, FUN = mean)

df <- data.frame(date = index(df.smooth),
                 count.plotly = round(df.smooth[,1],0),
                 count.ggplot = round(df.smooth[,2],0))

plot_ly(df, x = ~date) %>% 
    add_lines(y = ~count.plotly, fill = "tozeroy", line = list(shape = "spline"), name = "Plotly") %>% 
    add_lines(y = ~count.ggplot, fill = "tozeroy", line = list(shape = "spline"), name = "ggplot2", 
              yaxis = "y2", xaxis = "x2") %>% 
    
    layout(yaxis = list(domain = c(0.55,1), title = "Count", anchor = "xaxis",
                        tickfont = list(color = "#595959", size = 12)),
           
           yaxis2 = list(domain = c(0, 0.45), title = "Count", anchor = "xaxis2",
                         tickfont = list(color = "#595959", size = 12)),
           
           xaxis = list(anchor = "yaxis", title = "Date"),
           
           xaxis2 = list(anchor = "free", title = "Date"),
           
           annotations = list(
               
               list(x = 0.05, y = 1, xref = "paper", yref = "paper",
                    showarrow = FALSE,
                    text = "<b>Plotly downloads</b>",
                    font = list(size = 17)),
               
               list(x = 0.05, y = 0.45, xref = "paper", yref = "paper",
                    showarrow = FALSE,
                    text = "<b>ggplot2 downloads</b>",
                    font = list(size = 17))))
