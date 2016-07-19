library(dplyr)
library(tidyr)
library(ggplot2)
library(showtext) # for fonts

font.add.google("Poppins", "myfont")
showtext.auto()
theme_set(theme_light(base_family = "myfont"))

bb1 <- function(n = 1000){
    # ARIMA(2, 1, 1) with drift
    cumsum(arima.sim(model = list(ar = c(0.5, -0.2), ma = 0.3), n = n) + 0.10)
}

bb2 <- function(n = 1000){
    # ARIMA(1, 1, 2) with drift
    cumsum(arima.sim(model = list(ar = c(0.5), ma = c(0.3, -0.1)), n = n) + 0.04)
}

# one example each from both of my black boxes
set.seed(134)
par(mfrow = c(2, 1), family = "myfont", mar = c(4, 5, 1, 1))
plot.ts(bb1(), bty = "l", main = "One instance from blackbox 1")
plot.ts(bb2(), bty = "l", main = "One instance from blackbox 2")

# create skeleton of dataframe to hold data:
the_data <- data_frame(blackbox1 = numeric(), blackbox2 = numeric(), trial = numeric(), time = numeric())

# populate with simulated versions:
reps <- 100
n <- 500
set.seed(123) # for reproducibility
for(i in 1:reps){
    tmp <- data_frame(blackbox1 = bb1(n), blackbox2 = bb2(n), trial = i, time = 1:n)
    the_data <- rbind(the_data, tmp)
}

# gather into long tidy format
the_data_m <- the_data %>%
    gather(source, value, -trial, -time)

# show the data from the two black boxes:
the_data_m %>%
    ggplot(aes(x = time, y = value, colour = as.character(trial))) +
    facet_wrap(~source) +
    geom_line(alpha = 0.3) +
    geom_smooth(se = FALSE, method = "loess") +
    theme(legend.position = "none")


difference <- the_data_m %>%
    left_join(
        the_data %>%
            group_by(time) %>%
            summarise(centre_1 = mean(blackbox1),
                      sd_1 = sd(blackbox1)),
        by = "time"
    ) %>%
    # bias correction because the centres are defined from blackbox1's data,
    # hence on average they will always be a little closer to them
    mutate(correction = ifelse(source == "blackbox1", max(trial) / (max(trial) - 1), 1)) %>%
    group_by(trial, source)%>%
    summarise(
        meandiff = mean(abs(value - centre_1) / sd_1 * correction))

ggplot(difference, aes(x=meandiff, colour = source)) +
    geom_density() +
    ggtitle("Mean absolute standardise differencenat each time point from the average ofnblackbox1 at that point")



model1 <- lm(meandiff ~ source, data = difference)

par(mfrow=c(2, 2), family = "myfont")
plot(model1) # definitely normality assumption violated, so let's try something a bit more robust
There are various possible solutions but I go with using Venables and Ripley’s implementation of an M estimator in rlm(), in combination with bootstrapping. This minimises any assumptions I need to make about distributions, and controls for awkward outliers.
library(MASS)
library(boot)

R <- 2000
booted_robust <- boot(difference, 
                      statistic = function(data, w){
                          model <- rlm(meandiff ~ source, data = data[w, ])   
                          return(model$coefficients["sourceblackbox2"])
                      }, R = R)

# p-value for one sided test of H-null no difference v. H-alt blackbox2 
# is more different from blackbox1 centresthan blackbox1:
1 - sum(booted_robust$t > 0) / R
