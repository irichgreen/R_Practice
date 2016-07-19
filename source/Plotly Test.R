library(plotly)
library(jsonlite)

URL <- "https://gist.githubusercontent.com/davenquinn/988167471993bc2ece29/raw/f38d9cb3dd86e315e237fde5d65e185c39c931c2/data.json"
ds <- fromJSON(txt = URL)

colors = c('#8dd3c7','#ffffb3','#bebada',
           '#fb8072','#80b1d3','#fdb462',
           '#b3de69','#fccde5','#d9d9d9',
           '#bc80bd','#ccebc5','#ffed6f')

p <- plot_ly()
for(i in 1:length(ds)){
    p <- add_trace(p, data = ds[[i]], a = clay, b = sand, c = silt,
                   type = "scatterternary",
                   mode = "markers",
                   evaluate = T,
                   line = list(color = "black"))
}

p <- layout(p, title ="", showlegend = F,
            xaxis = list(title = "", showgrid = F, zeroline = F, showticklabels = F),
            yaxis = list(title = "", showgrid = F, zeroline = F, showticklabels = F),
            sum = 100,
            ternary = list(
                aaxis = list(title = "Clay", tickformat = ".0%", tickfont = list(size = 10)),
                baxis = list(title = "Sand", tickformat = ".0%", tickfont = list(size = 10)),
                caxis = list(title = "Silt", tickformat = ".0%", tickfont = list(size = 10))),
            annotations = list(
                list(xref = "paper", yref = "paper", align = "center",
                     x = 0.1, y = 1, text = "Ternary Plot in R
                     (Markers)", ax = 0, ay = 0,
                     font = list(family = "serif", size = 15, color = "white"),
                     bgcolor = "#b3b3b3", bordercolor = "black", borderwidth = 2)))
p


p <- plot_ly()
for(i in 1:length(ds)){
    p <- add_trace(p, data = ds[[i]], a = clay, b = sand, c = silt,
                   type = "scatterternary",
                   mode = "lines",
                   evaluate = T,
                   line = list(color = "black"))
}

p <- layout(p, title ="", showlegend = F,
            xaxis = list(title = "", showgrid = F, zeroline = F, showticklabels = F),
            yaxis = list(title = "", showgrid = F, zeroline = F, showticklabels = F),
            sum = 100,
            ternary = list(
                aaxis = list(title = "Clay", tickformat = ".0%", tickfont = list(size = 10)),
                baxis = list(title = "Sand", tickformat = ".0%", tickfont = list(size = 10)),
                caxis = list(title = "Silt", tickformat = ".0%", tickfont = list(size = 10))),
            annotations = list(
                list(xref = "paper", yref = "paper", align = "center",
                     x = 0.1, y = 1, text = "Ternary Plot in R
                     (Lines)", ax = 0, ay = 0,
                     font = list(family = "serif", size = 15, color = "white"),
                     bgcolor = "#b3b3b3", bordercolor = "black", borderwidth = 2)))
p


p <- plot_ly()
for(i in 1:length(ds)){
    p <- add_trace(p, data = ds[[i]], a = clay, b = sand, c = silt,
                   type = "scatterternary",
                   mode = "lines",
                   fill = "toself",
                   fillcolor = colors[i],
                   evaluate = T,
                   line = list(color = "black"))
}

p <- layout(p, title ="", showlegend = F,
            xaxis = list(title = "", showgrid = F, zeroline = F, showticklabels = F),
            yaxis = list(title = "", showgrid = F, zeroline = F, showticklabels = F),
            sum = 100,
            ternary = list(
                aaxis = list(title = "Clay", tickformat = ".0%", tickfont = list(size = 10)),
                baxis = list(title = "Sand", tickformat = ".0%", tickfont = list(size = 10)),
                caxis = list(title = "Silt", tickformat = ".0%", tickfont = list(size = 10))),
            annotations = list(
                list(xref = "paper", yref = "paper", align = "center",
                     x = 0.1, y = 1, text = "Ternary Plot in R
                     (Contour)", ax = 0, ay = 0,
                     font = list(family = "serif", size = 15, color = "white"),
                     bgcolor = "#b3b3b3", bordercolor = "black", borderwidth = 2)))
p

