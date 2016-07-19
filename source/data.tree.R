library(data.tree)

data(acme)
print(acme, "p", "cost", expectedCost = function(node) node$p * node$cost)



acme <- Node$new("Acme Inc.")
accounting <- acme$AddChild("Accounting")
software <- accounting$AddChild("New Software")
standards <- accounting$AddChild("New Accounting Standards")
research <- acme$AddChild("Research")
newProductLine <- research$AddChild("New Product Line")
newLabs <- research$AddChild("New Labs")
it <- acme$AddChild("IT")
outsource <- it$AddChild("Outsource")
agile <- it$AddChild("Go agile")
goToR <- it$AddChild("Switch to R")

print(acme)


install.packages("treemap")
library(treemap)
data(GNI2010)
head(GNI2010)
GNI2010$pathString <- paste("world", 
                            GNI2010$continent, 
                            GNI2010$country, 
                            sep = "/")
population <- as.Node(GNI2010)
print(population, "iso3", "population", "GNI", limit = 20)

plot(acme)
