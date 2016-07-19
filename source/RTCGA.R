library(ggplot2)
library(dplyr)

v_get_random_betas = Vectorize(rbeta)

ALPHAS = c(1, 2, 5, 1)
BETAS =  c(5, 5, 5, 1)
DISTS = c("Floor", "Left of center", "Normalish", "Uniform")
NS = seq(10, 70, by = 5)
ITERS = 1e4

#Tests
if (length(ALPHAS) != length(BETAS)) {
    stop("alphas and betas must be equal length")
}
if (length(ALPHAS) != length(DISTS)) {
    stop("every Distributio needs a name")
}

#Create a data frame
df = data.frame(
    iter = rep(1:ITERS, each = length(ALPHAS) * length(NS)),
    n = rep(NS, each = length(ALPHAS)),
    alpha = ALPHAS,
    beta =  BETAS,
    Distribution = DISTS
)


system.time({
    #Compute the true and approximate SD
    df = df %>% mutate(
        beta_values = v_get_random_betas(n, alpha, beta),
        sd = unlist(lapply(beta_values, sd)),
        min = unlist(lapply(beta_values, min)),
        max = unlist(lapply(beta_values, max)),
        heuristic_sd = abs(min - max) / 4,
        ape = abs(sd - heuristic_sd) / sd * 100 #average percentage error
    )
})

#Summarize to get mean average percentage error
sdf = df %>%
    group_by(n, Distribution) %>%
    summarise(mape = mean(ape),
              ape_se = sqrt(var(ape) / length(ape)))
View(sdf)
#Hallo Herr Schulte!
p = ggplot(sdf,
           aes(
               x = n,
               y = mape,
               group = Distribution,
               color = Distribution,
               shape = Distribution
           )) +
    geom_line() +
    geom_point() +
    labs(x = "Sample size",
         y = "Mean Absolute Percent Error",
         title = "Range / 4 Heuristic") +
    scale_y_continuous(limits = c(0, 50)) +
    scale_x_continuous(breaks = seq(10, 70, by = 10)) +
    theme(legend.position = "bottom")
p
#ggsave(plot=p,file="range.heuristic.png",width=4.5,height=5)

ITER2 = 1000

df2 = data.frame(
    Distribution = c(
        rep("Floor", ITER2 * 50),
        rep("Left of center", ITER2 * 50),
        rep("Normalish", ITER2 * 50),
        rep("Uniform", ITER2 * 50)
    ),
    values = c(
        unlist(
            subset(df, n == 50 &
                       Distribution == "Floor" & iter <= ITER2)$beta_values
        ),
        unlist(
            subset(df, n == 50 &
                       Distribution == "Left of center" & iter <= ITER2)$beta_values
        ),
        unlist(
            subset(df, n == 50 &
                       Distribution == "Normalish" & iter <= ITER2)$beta_values
        ),
        unlist(
            subset(df, n == 50 &
                       Distribution == "Uniform" & iter <= ITER2)$beta_values
        )
    )
)

p = ggplot(df2, aes(x = values, fill = Distribution)) +
    geom_density(alpha = .3, bw = .0025) +
    facet_grid(Distribution ~ .) +
    theme(legend.position = "bottom")
p
#ggsave(plot=p,file="range.heuristic.dists.png",width=4.5,height=5)