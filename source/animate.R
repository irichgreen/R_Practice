library(ggraph)
library(gganimate)
library(igraph)
# Data from http://konect.uni-koblenz.de/networks/sociopatterns-infectious
infect <- read.table('out.sociopatterns-infectious', skip = 2, sep = ' ', stringsAsFactors = FALSE)
infect$V3 <- NULL
names(infect) <- c('from', 'to', 'time')
infect$timebins <- as.numeric(cut(infect$time, breaks = 100))

# We want that nice fading effect so we need to add extra data for the trailing
infectAnim <- lapply(1:10, function(i) {infect$timebins  <- infect$timebins + i; infect$delay <- i; infect})
infect$delay <- 0
infectAnim <- rbind(infect, do.call(rbind, infectAnim))

infectGraph <- graph_from_data_frame(infectAnim, directed = F)

# We use only original data for the layout
subGr <- subgraph.edges(infectGraph, which(E(infectGraph)$delay == 0))
V(subGr)$degree <- degree(subGr)
lay <- createLayout(subGr, 'igraph', algorithm = 'lgl')

# Then we reassign the full graph with edge trails
attr(lay, 'graph') <- infectGraph

# Now we create the graph with timebins as frame
p <- ggraph(data = lay) + 
    geom_node_point(aes(size = degree), colour = '#8b4836') + 
    geom_edge_link0(aes(frame = timebins, alpha = delay, width = delay), edge_colour = '#dccf9f') + 
    scale_edge_alpha(range = c(1, 0), guide = 'none') + 
    scale_edge_width(range = c(0.5, 1.5), trans = 'exp', guide = 'none') + 
    scale_size(guide = 'none') + 
    ggtitle('Human Interactions') +
    ggforce::theme_no_axes() + 
    theme(plot.background = element_rect(fill = '#1d243a'), 
          panel.background = element_blank(), 
          panel.border = element_blank(), 
          plot.title = element_text(color = '#cecece'))

# And then we animate
animation::ani.options(interval=0.1)
gg_animate(p, 'animation.gif', title_frame = FALSE)
