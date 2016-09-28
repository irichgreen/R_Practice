library(ggplot2)
theme_set(theme_bw(base_family = "NotoSansKR-Thin"))

d <- data.frame(종속=1:10, 독립=1:10)
ggplot(d, aes(x=종속, y=독립)) + geom_point()

