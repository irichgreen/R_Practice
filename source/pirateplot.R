# Theme 3
pirateplot(formula = weight ~ Diet,
           data = ChickWeight,
           main = "Theme 3nbasel palette",
           theme.o = 3,
           pal = "basel")

# Theme 0
pirateplot(formula = weight ~ Diet,
           data = ChickWeight,
           main = "Theme 0ngoogle palette",
           pal = "google",
           point.o = .2,
           line.o = 1,
           theme.o = 0,
           line.lwd = 10,
           point.pch = 16,
           point.cex = 1.5,
           jitter.val = .1)

pirateplot(formula = weight ~ Diet,
           data = ChickWeight,
           main = "Theme 3nlight color with black background",
           pal = "white",
           theme.o = 3,
           point.pch = 16,
           back.col = gray(.2))

#Gridlines
pirateplot(formula = weight ~ Diet + Time,
           data = subset(ChickWeight, Time < 10),
           theme.o = 2,
           pal = "basel",
           point.pch = 16,
           gl.col = gray(.8),
           main = "Two IVsnWith gridlines")
