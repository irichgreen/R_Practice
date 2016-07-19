library(knitr)
taco.results <- read.csv('taco_results.csv')
kable(head(taco.results))

library(dplyr)
beef.ratings <- filter(taco.results, Filling == "Beef")
kable(head(beef.ratings))

mean(beef.ratings$Rating)

library(ggplot2)
ggplot(beef.ratings, aes(x = AgeGroup, y = Rating, fill = ShellType)) + 
    geom_bar(stat = "identity", position = "dodge")

ggplot(taco.results, aes(x = Rating)) + geom_histogram(binwidth=0.01)

ggplot(taco.results, aes(x = AgeGroup, y = Rating, fill = ShellType)) + 
    geom_bar(stat = "identity", position = "dodge") +
    facet_wrap( ~ Filling, ncol = 3, scales = "free_x")

filling.results <- taco.results %>%
    group_by(Filling) %>%
    summarise(Rating = mean(Rating))

ggplot(filling.results, aes(x = Filling, y = Rating, fill = Filling)) + 
    geom_bar(stat = "identity", position = "dodge", alpha = 0.7) + 
    coord_flip(ylim=c(0.8,0.875)) +
    theme_bw(base_size = 18)  + guides(fill=FALSE) 

theme_set(theme_bw(base_size = 18))

ggplot(taco.results, aes(x = Filling, y = Rating, fill = Filling)) + 
    geom_boxplot(alpha = 0.5) + guides(fill=FALSE) + coord_flip()


ggplot(taco.results, aes(x = Filling, y = Rating, fill = Filling)) + 
    geom_boxplot(alpha = 0.5) + guides(fill=FALSE) +
    facet_grid(. ~ ShellType) + coord_flip()

ggplot(taco.results, aes(x = AgeGroup, y = Rating,  color = ShellType)) + 
    geom_jitter(size=2)

ggplot(taco.results, aes(x = Rating, fill=AgeGroup)) + geom_density(alpha=0.3)

ggplot(taco.results, aes(x = AgeGroup, y = Rating, fill = AgeGroup)) + 
    geom_violin(color = "black", alpha = 0.3)


ggplot(taco.results, aes(x = AgeGroup, y = Rating, group=ShellType, color=ShellType)) + 
    geom_line(size=1) + geom_point(size=3) + theme(axis.text.x  = element_text(size=12)) + 
    facet_wrap( ~ Filling, ncol = 3,scales = "free_x")

ggplot(taco.results, aes(AgeGroup, Filling)) + 
    geom_tile(aes(fill = Rating), color = "white") + 
    scale_fill_gradient(low = "white", high = "steelblue") +
    facet_grid(. ~ ShellType)

#install.packages("agricolae")
library(agricolae)
taco.anova <- aov(Rating~ShellType*AgeGroup,data = taco.results)
summary(taco.anova)
HSD.test(taco.anova, "AgeGroup", alpha = 0.5, console = TRUE)


taco.hsd <- data.frame(TukeyHSD(taco.anova,"AgeGroup", conf.level=.95)$AgeGroup)
taco.hsd$Comparison <- row.names(taco.hsd)

ggplot(taco.hsd, aes(x = Comparison, y = diff, ymin = lwr, ymax = upr, color=Comparison)) +
    geom_pointrange(size=1.2) + coord_flip() + guides(color=FALSE) +
    ylab("Difference in Mean Rating by Age Groups")

pdf("taco_hsd.pdf", height=6, width=10)
ggplot(taco.hsd, aes(x = Comparison, y = diff, ymin = lwr, ymax = upr, color=Comparison)) +
    geom_pointrange(size=1.2) + coord_flip() + guides(color=FALSE) +
    ylab("Difference in Mean Rating by Age Groups")
dev.off()

