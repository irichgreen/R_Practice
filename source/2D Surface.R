n <- 12
h <- 1/(n-1)
r = seq(h, 1, length.out=n)
theta = seq(0, 2*pi, length.out=36)

g <- expand.grid(r=r, theta=theta)

x <- c(g$r * cos(g$theta),0)
y <- c(g$r * sin(g$theta),0)
z <- sin(x*y)

m <- matrix(
    c(x,y,z), 
    ncol = 3,
    dimnames = list(NULL, c("x", "y", "z"))
)

tri <- delaunayn(m[,1:2])

# now figure out the colormap
zmean <- apply(tri,MARGIN=1,function(row){mean(m[row,3])})

library(scales)
library(rje)
facecolor = colour_ramp(
    cubeHelix(12)
)(rescale(x=zmean))

plot_ly(
    x=x, y=y, z=z,
    i=tri[,1]-1, j=tri[,2]-1, k=tri[,3]-1,
    facecolor=facecolor,
    type="mesh3d"
) %>%
    layout(
        title="Triangulated surface",
        scene=list(
            xaxis=axs,
            yaxis=axs,
            zaxis=axs,
            camera=list(
                eye=list(x=1.75,y=-0.7,z=0.75)
            )
        ),
        aspectratio=list(x=1,y=1,z=0.5)
    )
