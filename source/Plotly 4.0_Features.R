library(plotly)
plot_ly(mtcars, x = ~mpg, y = ~sqrt(wt))

myPlot <- function(x, y, ...) {
    plot_ly(mtcars, x = x, y = y, color = ~factor(cyl), ...)
}
myPlot(~mpg, ~disp, colors = "Dark2")

subplot(
    plot_ly(diamonds, y = ~cut, color = ~clarity),
    plot_ly(diamonds, x = ~cut, color = ~clarity),
    margin = 0.07
) %>% hide_legend()


plot_ly(diamonds, x = ~cut, y = ~clarity)

library(dplyr)
# order the clarity levels by their median price
d <- diamonds %>%
    group_by(clarity) %>%
    summarise(m = median(price)) %>%
    arrange(m)
diamonds$clarity <- factor(diamonds$clarity, levels = d[["clarity"]])
plot_ly(diamonds, x = ~price, y = ~clarity, type = "box")


subplot(
    plot_ly(economics, x = ~date, y = ~psavert, type = "scatter") %>% 
        add_trace(y = ~uempmed) %>%
        layout(yaxis = list(title = "Two Traces")),
    plot_ly(economics, x = ~date, y = ~psavert) %>% 
        add_trace(y = ~uempmed) %>% 
        layout(yaxis = list(title = "One Trace")),
    titleY = TRUE, shareX = TRUE, nrows = 2
) %>% hide_legend()


map_data("world", "canada") %>%
    group_by(group) %>%
    plot_ly(x = ~long, y = ~lat, alpha = 0.1) %>%
    add_polygons(color = I("black"), hoverinfo = "none") %>%
    add_markers(color = I("red"), symbol = I(17),
                text = ~paste(name, "<br />", pop),
                hoverinfo = "text", data = maps::canada.cities) %>%
    hide_legend()


txhousing %>%
    group_by(city) %>%
    plot_ly(x = ~date, y = ~median) %>%
    add_lines(alpha = 0.3)


txhousing %>%
    plot_ly(x = ~date, y = ~median) %>%
    add_lines(split = ~city, color = I("steelblue"), alpha = 0.3)


library(dplyr)
economics %>%
    plot_ly(x = ~date, y = ~unemploy / pop, showlegend = F) %>%
    add_lines(linetype = I(22)) %>%
    mutate(rate = unemploy / pop) %>% 
    slice(which.max(rate)) %>%
    add_markers(symbol = I(10), size = I(50)) %>%
    add_annotations("peak")


diamonds %>%
    group_by(cut) %>%
    plot_ly(x = ~price) %>%
    plotly_data()


# the style() function provides a more elegant way to do this sort of thing,
# but I know some people like to work with the list object directly...
pl <- plotly_build(qplot(1:10))[["x"]]
pl$data[[1]]$hoverinfo <- "none"
as_widget(pl)


