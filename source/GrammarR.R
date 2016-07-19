

library(ggplot2)
library(dplyr)
data(diamonds)
diamonds %>% 
    ggplot(aes(x=carat,y=price)) + 
    geom_point(alpha=0.5) +
    facet_grid(~ cut) + 
    stat_smooth(method = lm, formula = y ~ poly(x,2)) + 
    theme_bw()

#install.packages("GGally")
library(GGally)

diamonds %>% 
    mutate(volume = x*y*z) %>%
    select(cut, carat, price, volume) %>%
    sample_frac(0.5, replace=TRUE) %>% 
    ggpairs(axisLabels="none") + 
    theme_bw()


