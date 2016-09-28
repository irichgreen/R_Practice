# devtools::install_github("ndphillips/yarrr", build_vignettes = TRUE)
library("yarrr") # Load the yarrr package
yarrr::pirateplot(formula = weight ~ Time, data = ChickWeight)

pirateplot(formula = weight ~ Diet, # dv is weight, iv is Diet
           data = ChickWeight,
           main = "My first pirate plot!",
           xlab = "Diet",
           ylab = "Weight")

pirateplot(formula = weight ~ Time, # dv is weight, iv is Diet
           data = ChickWeight,
           line.fun = median, # median heights
           bean.o = 0, # No bean
           point.pch = 16, # Solid points
           point.o = .2,
           point.cex = 1.2, # Larger points
           pal = "basel", # Basel palette
           back.col = gray(.97), # gray background
           bar.o = .2, # Lighter bar
           main = "My second pirate plot!",
           xlab = "Time",
           ylab = "Weight")

# Plotting data from two IVs in pirateplot
pirateplot(formula = len ~ dose + supp, # Two IVs
           data = ToothGrowth,
           xlab = "Dose",
           ylab = "Tooth Length",
           main = "ToothGrowth Data")

require("RColorBrewer")
display.brewer.all()


pirateplot(formula = time ~ cleaner + type,
           data = poopdeck,
           main = "Poopdeck Cleaning Time")

pirateplot(formula = weight ~ Time,
           data = ChickWeight,
           pal = "southpark")

pirateplot(formula = weight ~ Diet,
           data = ChickWeight,
           pal = "black")

pirateplot(formula = weight ~ Time,
           data = ChickWeight,
           pal = "southpark",
           point.col = "gray", 
           bar.col = "gray")

pirateplot(formula = weight ~ Diet,
           data = ChickWeight,
           theme.o = 2,
           main = "Opacity themes with theme.o")

pirateplot(formula = weight ~ Diet,
           data = ChickWeight,
           theme.o = 0,
           point.o = .1)
           
pirateplot(formula = weight ~ Diet,
           data = ChickWeight,
           theme.o = 0, 
           point.o = .1,
           bean.o = .5)

pirateplot(formula = weight ~ Time,
           data = ChickWeight,
           theme.o = 0, 
           bar.o = .5,
           inf.o = .8,
           pal = gray(.1))

pirateplot(formula = weight ~ Diet,
           data = ChickWeight,
           pal = "basel",
           theme.o = 0,
           point.o = c(.1, .05, .2, .05),
           inf.o = c(.9, .1, .9, .1), 
           bean.o = c(1, .1, 1, .1),
           main = "Adjusting opacities between groups")

pirateplot(formula = weight ~ Diet + Time,
           data = ChickWeight,
           pal = "google",
           theme.o = 1,
           back.col = gray(.96),
           gl.col = "white",
           main = "back.col, gl.col")
