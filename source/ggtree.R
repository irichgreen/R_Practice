## try http:// if https:// URLs are not supported
source("https://bioconductor.org/biocLite.R")
## biocLite("BiocUpgrade") ## you may need this
biocLite("ggtree")

library(ggplot2)
library(ggtree)
ggtree(rtree(15)) %<% rtree(30)
ggtree(rtree(15), layout="unrooted", ladderize=FALSE) %<% rtree(45)
ggtree(rtree(15), layout="cladogram", ladderize=FALSE) %<% 
    rtree(30) %<% 
    rtree(45)
(ggtree(rtree(15), layout="fan") + 
        geom_point(aes(shape=isTip, color=isTip))) %<% 
    rtree(40)

rstfile <- system.file("extdata/PAML_Baseml", "rst", package="ggtree")
tipfas <- system.file("extdata", "pa.fas", package="ggtree")
rst <- read.paml_rst(rstfile, tipfas)

p <- plot(rst, annotation="marginal_AA_subs", annotation.color="steelblue")
print(p)

rstfile <- system.file("extdata/PAML_Codeml", "rst", package="ggtree")
rst <- read.paml_rst(rstfile, tipfas)
p %<% rst


require(ggplot2)
require(ggtree)
x <- read.beast("/Applications/FigTree/influenza.tree")
cols <- scale_color(x, by="height")
ggtree(x, right=TRUE, mrsd="2005-04-02", color=cols) + theme_tree2() +
    geom_text(aes(x=max(x), label=label), size=1, color=cols, hjust=-.3) +
    scale_x_continuous(breaks=c(1992, 1995, 1997, 2000, 2002, 2005), minor_breaks=seq(1992, 2005, 1)) +
    geom_segment(aes(xend=max(x)+.20, yend=y), linetype="dotted", size=.1, color=cols) +
    theme(panel.grid.major   = element_line(color="black", size=.2),
          panel.grid.minor   = element_line(color="grey", size=.2),
          panel.grid.major.y = element_blank(),
          panel.grid.minor.y = element_blank()) 
