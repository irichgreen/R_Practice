library(rbokeh)

clusters <- hclust(dist(iris[, 3:4]), method = 'average')
clusterCut <- cutree(clusters, 3)
p <- figure(title = 'Hierarchical Clustering of Iris Data') %>% 
    ly_points(Petal.Length, Petal.Width, data = iris, color = Species, hover = c(Sepal.Length, Sepal.Width)) %>%
    ly_points(iris$Petal.Length, iris$Petal.Width, glyph = clusterCut, size = 13)
p


aapl <- read.csv('AAPL.csv')
aapl$Date <- as.Date(aapl$Date)
p <- figure(title = 'Apple Stock Data') %>% 
    ly_points(Date, Volume / (10 ^ 6), data = aapl, hover = c(Date, High, Open, Close)) %>%
    ly_abline(v = with(aapl, Date[which.max(Volume)])) %>%
    y_axis(label = 'Volume in millions', number_formatter = 'numeral', format = '0.00')
p

SFData <- read.csv('SFPD_Incidents_-_Previous_Year__2015_.csv')
data <- subset(SFData, Category == 'BRIBERY' | Category == 'SUICIDE')
p <- gmap(lat = 37.78, lng = -122.42, zoom = 13) %>%
    ly_points(Y, X, data = data, hover = c(Category, PdDistrict), col = 'red') %>%
    x_axis(visible = FALSE) %>%
    y_axis(visible = FALSE)


diamonds <- ggplot2:: diamonds
l <- levels(diamonds$color)
plot_list <- vector(mode = 'list', 7)

for (i in 1:length(l)) {
    data <- subset(diamonds, color == l[i])
    plot_list[[i]] <- figure(width = 350, height = 350) %>%
        ly_points(carat, price, data = data, legend = l[i], hover = c(cut, clarity))
}

grid_plot(plot_list, nrow = 2)

