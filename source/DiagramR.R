#install.packages('DiagrammeR')
library(DiagrammeR)
library(dplyr)


grViz("
digraph boxes_and_circles {
      
      # a 'graph' statement
      graph [overlap = true]
      
      # several 'node' statements
      node [shape = box,
      fontname = Helvetica]
      Air; Bolt; C; D; E; F
      
      node [shape = circle,
      fixedsize = true,
      width = 0.9] // sets as circles
      1; 2; 3; 4; 5; 6; 7; 8
      
      # several 'edge' statements
      Air->1; Bolt->2; Bolt->3; Bolt->4; C->Air
      1->D; E->Air; 2->4; 1->5; 1->F
      E->6; 4->6; 5->7; 6->7; 3->8
      }
      ")

grViz("
      digraph boxes_and_circles {
      
      # a 'graph' statement
      graph [overlap = true]
      
      # several 'node' statements
      node [shape = box,
      fontname = Helvetica,
      color = blue] // for the letter nodes, use box shapes
      A; B; C; D; E
      F [color = black]
      
      node [shape = circle,
      fixedsize = true,
      width = 0.9] // sets as circles
      1; 2; 3; 4; 5; 6; 7; 8
      
      # several 'edge' statements
      edge [color = gray] // this sets all edges to be gray (unless overridden)
      A->1; B->2                   // gray
      B->3 [color = red]           // red
      B->4                         // gray
      C->A [color = green]         // green
      1->D; E->A; 2->4; 1->5; 1->F // gray
      E->6; 4->6; 5->7; 6->7       // gray
      3->8 [color = blue]          // blue
      }
      ")


# Setting a seed to make the example reproducible
set.seed(23)

# Create an edge data frame and also include a column of 'random' data
many_edges <-
    create_edges(edge_from = sample(seq(1:100), 100, replace = TRUE),
                 edge_to = sample(seq(1:100), 100, replace = TRUE),
                 random_data = sample(seq(1:5000), 100, replace = TRUE))

# Create the node data frame, using the nodes that are available in
# the 'many_edges' data frame; provide 'shape' and 'fillcolor' attributes
many_nodes <-
    create_nodes(node = get_nodes(many_edges),
                 random_data = sample(seq(1:5000),
                                      length(get_nodes(many_edges))),
                 label = FALSE,
                 shape = "circle",
                 fillcolor = "red")


create_graph(nodes_df = many_nodes, edges_df = many_edges,
             node_attrs = "style = filled",
             graph_attrs = c("layout = twopi", "overlap = false")) %>>% 
    render_graph

many_nodes <- scale_nodes(nodes_df = many_nodes,
                          to_scale = many_nodes$random_data,
                          node_attr = "penwidth",
                          range = c(2, 10))

many_nodes <- scale_nodes(nodes_df = many_nodes,
                          to_scale = many_nodes$random_data,
                          node_attr = "alpha:fillcolor",
                          range = c(5, 90))


install.packages("V8")
library("V8")
many_edges <- scale_edges(edges_df = many_edges,
                          to_scale = many_edges$penwidth,
                          edge_attr = "color",
                          range = c("red", "green"))

