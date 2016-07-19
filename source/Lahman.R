library(dplyr)
library(tidyr)
# install.packages("Lahman")
library(Lahman)
library(ggplot2)
theme_set(theme_bw())

# Grab career batting average of non-pitchers
# (allow players that have pitched <= 3 games, like Ty Cobb)
pitchers <- Pitching %>%
    group_by(playerID) %>%
    summarize(gamesPitched = sum(G)) %>%
    filter(gamesPitched > 3)

career <- Batting %>%
    filter(AB > 0) %>%
    anti_join(pitchers, by = "playerID") %>%
    group_by(playerID) %>%
    summarize(H = sum(H), AB = sum(AB)) %>%
    mutate(average = H / AB)

# Add player names
career <- Master %>%
    tbl_df() %>%
    dplyr::select(playerID, nameFirst, nameLast) %>%
    unite(name, nameFirst, nameLast, sep = " ") %>%
    inner_join(career, by = "playerID")

# Estimate hyperparameters alpha0 and beta0 for empirical Bayes
career_filtered <- career %>% filter(AB >= 500)
m <- MASS::fitdistr(career_filtered$average, dbeta,
                    start = list(shape1 = 1, shape2 = 10))

alpha0 <- m$estimate[1]
beta0 <- m$estimate[2]
prior_mu <- alpha0 / (alpha0 + beta0)

# For each player, update the beta prior based on the evidence
# to get posterior parameters alpha1 and beta1
career_eb <- career %>%
    mutate(eb_estimate = (H + alpha0) / (AB + alpha0 + beta0)) %>%
    mutate(alpha1 = H + alpha0,
           beta1 = AB - H + beta0) %>%
    arrange(desc(eb_estimate))

career %>%
    filter(AB >= 20) %>%
    ggplot(aes(AB, average)) +
    geom_point() +
    geom_smooth(method = "lm", se = FALSE) +
    scale_x_log10()

