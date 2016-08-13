# install.packages("Quandl")
library(Quandl)
library(plotly)

df <- Quandl("WIKI/AAPL")
df <- df[,c(1, 9:12)]

names(df) <- c("Date", "Open", "High", "Low", "Close")
df$Date <- as.Date(df$Date)

df <- df[1:1000,]

hovertxt <- Map(function(x, y)paste0(x, ":", y), names(df), df)
hovertxt <- Reduce(function(x, y)paste0(x, "<br&gt;", y), hovertxt)

plot_ly(df, x = ~Date, xend = ~Date, hoverinfo = "none",
        color = ~Close > Open, colors = c("#00b386","#ff6666")) %>%
    
    add_segments(y = ~Low, yend = ~High, line = list(width = 1, color = "black")) %>%
    
    add_segments(y = ~Open, yend = ~Close, line = list(width = 3)) %>%
    
    add_markers(y = ~(Low + High)/2, hoverinfo = "text",
                text = hovertxt, marker = list(color = "transparent")) %>% 
    
    layout(showlegend = FALSE, 
           color = "white",
           yaxis = list(title = "Price", domain = c(0, 0.9)),
           annotations = list(
               list(xref = "paper", yref = "paper", 
                    x = 0, y = 1, showarrow = F, 
                    xanchor = "left", yanchor = "top",
                    align = "left",
                    text = paste0("<b>AAPL</b>")),
               
               list(xref = "paper", yref = "paper", 
                    x = 0.75, y = 1, showarrow = F, 
                    xanchor = "left", yanchor = "top",
                    align = "left",
                    text = paste(range(df$Date), collapse = " : "),
                    font = list(size = 8))),
           plot_bgcolor = "#f2f2f2") 

