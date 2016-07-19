library(ggplot2)
spoke_df = expand.grid(x_axis = 1:10, y_axis = 1:10)
spoke_df[, "angle_1"] = seq(0, 2, length.out = nrow(spoke_df))*pi
spoke_df[, "angle_2"] = seq(0, 2, length.out = nrow(spoke_df))*pi - 0.5*pi
spoke_df[, "angle_1_cos"] = cos(spoke_df$angle_1)
spoke_df[, "angle_1_sin"] = sin(spoke_df$angle_1)

spoke_size = 0.4

ggplot() +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank(),
          panel.border = element_rect(fill = NA),
          panel.background = element_blank(),
          plot.background = element_blank(),
          legend.position = "none") + 
    geom_spoke(data = spoke_df,
               aes(x = x_axis, y = y_axis,
                   angle = angle_1),
               radius = spoke_size,
               size = 1.1) + 
    geom_point(data = spoke_df,
               aes(x = x_axis, y = y_axis),
               shape = 1, size = 4) +
    geom_point(data = spoke_df,
               aes(x = x_axis, y = y_axis),
               size = 3.7, colour = "white") + 
    geom_spoke(data = spoke_df,
               aes(x = x_axis + angle_1_cos * spoke_size, 
                   y = y_axis + angle_1_sin * spoke_size,
                   angle = angle_2),
               radius = spoke_size * 0.8, 
               size = 0.9,
               colour = "red") + 
    geom_spoke(data = spoke_df,
               aes(x = x_axis + angle_1_cos * spoke_size * 0.7, 
                   y = y_axis + angle_1_sin * spoke_size * 0.7,
                   angle = angle_2),
               radius = spoke_size * 0.6, 
               size = 0.9,
               colour = "blue") + 
    scale_x_continuous(name = "long",
                       breaks = 1:10,
                       labels = 1:10,
                       limits = c(0.3, 10.7),
                       expand = c(0.01, 0.01)) + 
    scale_y_continuous(name = "lat",
                       breaks = 1:10,
                       labels = 1:10,
                       limits = c(0.3, 10.7),
                       expand = c(0.01, 0.01)) + 
    geom_vline(xintercept = 0.5:10.5, size = 0.6, linetype = 3) + 
    geom_hline(yintercept = 0.5:10.5, size = 0.6, linetype = 3)