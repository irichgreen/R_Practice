library(rPlotter)

## Using the R Logo
pal_r <- extract_colours("http://developer.r-project.org/Logo/Rlogo-1.png")
par(mfrow = c(1,2))
pie(rep(1, 5), col = pal_r, main = "Palette based on R Logo")
hist(Nile, breaks = 5, col = pal_r, main = "Palette based on R Logo")

## Using a poster from the movie "Kill Bill"
pal_kb <- extract_colours("http://www.moviegoods.com/Assets/product_images/1010/477803.1010.A.jpg")
par(mfrow = c(1,2))
pie(rep(1, 5), col = pal_kb, main = "Palette based on Kill Bill")
hist(Nile, breaks = 5, col = pal_kb, main = "Palette based on Kill Bill")

## Using Homer Simpson
pal_s <- extract_colours("http://haphappy.com/wp-content/uploads/2011/03/homerbeer2.png")
par(mfrow = c(1,2))
pie(rep(1, 5), col = pal_s, main = "Palette based on Simpsons")
hist(Nile, breaks = 5, col = pal_s, main = "Palette based on Simpsons")

set.seed(1234)
pal_pf <- extract_colours("http://www.scoutlondon.com/blog/wp-content/uploads/2012/05/Pulp-Fiction.jpg")
display_colours(pal_pf)

set.seed(1234)
pal_pf <- extract_colours("http://www.scoutlondon.com/blog/wp-content/uploads/2012/05/Pulp-Fiction.jpg")
simulate_colours(pal_pf)


