library(ggraph)
library(ggforce)

# Dendrogram
# Let's use iris as we all love the iris dataset
## Perform hierarchical clustering on the iris data
irisDen <- as.dendrogram(hclust(dist(iris[1:4], method='euclidean'), 
                                method='ward.D2'))
## Add the species information to the leafs
irisDen <- dendrapply(irisDen, function(d) {
    if(is.leaf(d)) 
        attr(d, 'nodePar') <- list(species=iris[as.integer(attr(d, 'label')),5])
    d
})

# Plotting this looks very much like ggplot2 except for the new geoms
ggraph(graph = irisDen, layout = 'dendrogram', repel = TRUE, circular = TRUE, 
       ratio = 0.5) + 
    geom_edge_elbow() + 
    geom_node_text(aes(x = x*1.05, y=y*1.05, filter=leaf, 
                       angle = nAngle(x, y), label = label), 
                   size=3, hjust='outward') + 
    geom_node_point(aes(filter=leaf, color=species)) + 
    coord_fixed() + 
    ggforce::theme_no_axes()


# igraph
install.packages("igraph")
library(igraph)

# We use a friendship network
friendGraph <- graph_from_data_frame(highschool)
V(friendGraph)$degree <- degree(friendGraph, mode = 'in')
graph1957 <- subgraph.edges(friendGraph, which(E(friendGraph)$year ==1957), F)
graph1958 <- subgraph.edges(friendGraph, which(E(friendGraph)$year ==1958), F)
V(friendGraph)$pop.increase <- degree(graph1958, mode = 'in') > 
    degree(graph1957, mode = 'in')

ggraph(friendGraph, 'igraph', algorithm = 'kk') + 
    geom_edge_fan(aes(alpha = ..index..)) + 
    geom_node_point(aes(size = degree, colour = pop.increase)) + 
    scale_edge_alpha('Friends with', guide = 'edge_direction') + 
    scale_colour_manual('Improved', values = c('firebrick', 'forestgreen')) + 
    scale_size('# Friends') + 
    facet_wrap(~year) + 
    ggforce::theme_no_axes()


# Hierarchical Edge Bundles

flareGraph <- graph_from_data_frame(flare$edges, vertices = flare$vertices)
importFrom <- match(flare$imports$from, flare$vertices$name)
importTo <- match(flare$imports$to, flare$vertices$name)
flareGraph <- treeApply(flareGraph, function(node, parent, depth, tree) {
    tree <- set_vertex_attr(tree, 'depth', node, depth)
    if (depth == 1) {
        tree <- set_vertex_attr(tree, 'class', node, V(tree)$shortName[node])
    } else if (depth > 1) {
        tree <- set_vertex_attr(tree, 'class', node, V(tree)$class[parent])
    }
    tree
})
V(flareGraph)$leaf <- degree(flareGraph, mode = 'out') == 0

ggraph(flareGraph, 'dendrogram', circular = TRUE) + 
    geom_edge_bundle(aes(colour = ..index..), data = gCon(importFrom, importTo), 
                     edge_alpha = 0.25) +
    geom_node_point(aes(filter = leaf, colour = class)) +
    scale_edge_colour_distiller('', direction = 1, guide = 'edge_direction') + 
    coord_fixed() +
    ggforce::theme_no_axes()


# Treemaps

# We continue with our flareGraph
ggraph(flareGraph, 'treemap', weight = 'size') + 
    geom_treemap(aes(filter = leaf, fill = class, alpha = depth), colour = NA) + 
    geom_treemap(aes(filter = depth != 0, size = depth), fill = NA) + 
    scale_alpha(range = c(1, 0.7), guide = 'none') + 
    scale_size(range = c(2.5, 0.4), guide = 'none') + 
    ggforce::theme_no_axes()

