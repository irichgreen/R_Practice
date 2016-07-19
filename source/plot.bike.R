install.packages("drat")
drat::addRepo("rcourses")
install.packages("nclRadvanced", type="source")

library(nclRadvanced)
vignette(package = "nclRadvanced")
vignette(package = "nclRadvanced", "practical2")

x <- 1:9
y <- x^2
m <- lm(y ~ x)
class(m)

# Create a class for bicycle data
wheelsize <- 559 # 26" wheel size, definited by 'bead seat diameter' (BSD)
size <- 21 * 25.4 # top tube length, inches converted to mm
top_tube_length <- 530 # top tobe length 
x <- list(ws = wheelsize, s = size, ttl = top_tube_length)
class(x) <- "bike"

library(plotrix)
plot.bike <- function(x, ...){
    centre_back <- c(0, x$ws / 2)
    centre_front <- c(x$ws + x$ttl + 100, x$ws / 2)
    xlim <- c(-x$ws, centre_front[1] + x$ws / 2)
    ylim <- c(0, x$ttl + x$ws/2 + 50)
    plot.new()
    plot.window(xlim, ylim)
    draw.circle(x = centre_back[1], y = centre_back[2], radius = x$ws/2)
    draw.circle(x = centre_front[1], y = centre_back[2], radius = x$ws/2)
    ttx <- c(0, x$ttl) + x$ws/2 + 100
    tty <- rep(x$ws / 2 + x$s, 2)
    stx <- rep(x$ws/2 + 100, 2)
    sty <- c(0, x$s) + x$ws/2
    lines(ttx, tty)
    lines(stx, sty)
    lines(c(0, ttx[1]), c(sty[1], sty[2]))
    lines(c(0, ttx[1]), c(sty[1], sty[1]))
    lines(c(ttx[1], ttx[2]), c(sty[1], sty[2]))
    lines(c(centre_front[1], ttx[2]), c(sty[1], sty[2]))
}

plot(x)

x$ws <- 1500 # a bike with large wheels
plot(x)

