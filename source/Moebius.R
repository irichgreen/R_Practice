library(plotly)
library(geometry)

g <- expand.grid(
    u = seq(0, 2 * pi, length.out = 24),
    v = seq(-1, 1, length.out = 8)
)
tp <- 1 + 0.5 * g$v * cos(g$u / 2)
m <- matrix(
    c(tp * cos(g$u), tp * sin(g$u), 0.5 * g$v * sin(g$u / 2)), 
    ncol = 3, dimnames = list(NULL, c("x", "y", "z"))
)

# the key though is running delaunayn on g rather than m
d <- delaunayn(g)
td <- t(d)
#  but using m for plotting rather than the 2d g

# define layout options
axs <- list(
    backgroundcolor="rgb(230,230,230)",
    gridcolor="rgb(255,255,255)",
    showbackground=TRUE,
    zerolinecolor="rgb(255,255,255"
)

# now figure out the colormap
#  start by determining the mean of z for each row
#  of the Delaunay vertices
zmean <- apply(d, MARGIN=1, function(row){mean(m[row,3])})

library(scales)
# result will be slighlty different
#  since colour_ramp uses CIELAB instead of RGB
#  could use colorRamp for exact replication
facecolor = colour_ramp(
    brewer_pal(palette="RdBu")(9)
)(rescale(x=zmean))


plot_ly(
    x = m[, 1], y = m[, 2], z = m[, 3],
    # JavaScript is 0 based index so subtract 1
    i = d[, 1]-1, j = d[, 2]-1, k = d[, 3]-1,
    facecolor = facecolor,
    type = "mesh3d"
) %>%
    layout(
        title="Moebius band triangulation",
        scene=list(xaxis=axs,yaxis=axs,zaxis=axs),
        aspectratio=list(x=1,y=1,z=0.5)
    )
