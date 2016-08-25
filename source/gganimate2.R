devtools::install_github("dgrtwo/gganimate")
library(gapminder)
library(ggplot2)
theme_set(theme_bw())

p <- ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop, color = continent, frame = year)) + geom_point() + scale_x_log10()

library(gganimate)
gg_animate(p)

p2 <- ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop)) +
    geom_point() +
    geom_point(aes(frame = year), color = "red") +
    scale_x_log10()

gg_animate(p2)

p3 <- ggplot(gapminder, aes(gdpPercap, lifeExp, frame = year)) +
    geom_path(aes(cumulative = TRUE, group = country)) +
    scale_x_log10() +
    facet_wrap(~continent)

gg_animate(p3)


p4 <- ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop, frame = continent)) +
    geom_point() +
    scale_x_log10()

gg_animate(p4)

p5 <- ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop, frame = year)) +
    geom_point() +
    geom_smooth(aes(group = year), method = "lm", show.legend = FALSE) +
    facet_wrap(~continent, scales = "free") +
    scale_x_log10()

gg_animate(p5)

gg_animate(p, interval = .2)
