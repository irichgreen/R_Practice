set.seed(10) #make predictable random data
baseline <- rlnorm(100, 0, 1)
post <- 0.8*baseline + rnorm(100, 0, 0.10*baseline)
plot(baseline,post)
abline(lm(post ~ baseline))
abline(0, 1, col="red", lty = 2)

library(ggplot2)
my.data <- data.frame(baseline, post)
ggplot(my.data, aes(x=baseline, y=post)) +
    theme_bw() + 
    geom_point(shape=1) +    # Use hollow circles
    geom_smooth(method=lm) +  # Add linear regression line 
    geom_abline(slope = 1, intercept = 0, linetype = 2, colour = "red")

diff <- (post - baseline)
diffp <- (post - baseline)/baseline*100
sd.diff <- sd(diff)
sd.diffp <- sd(diffp)
my.data <- data.frame(baseline, post, diff, diffp)

#In standard Bland Altman plots, one plots the difference between methods against #the average of the methods, but in this case, the x-axis should be the baseline #result, because that is the closest thing we have to the truth.

library(ggExtra)
diffplot <- ggplot(my.data, aes(baseline, diff)) + 
    geom_point(size=2, colour = rgb(0,0,0, alpha = 0.5)) + 
    theme_bw() + 
    geom_hline(yintercept = 0, linetype = 3) +
    geom_hline(yintercept = mean(my.data$diff)) +
    geom_hline(yintercept = mean(my.data$diff) + 2*sd.diff, linetype = 2) +
    geom_hline(yintercept = mean(my.data$diff) - 2*sd.diff, linetype = 2) +
    ylab("Difference pre and post Storage (mg/L)") +
    xlab("Baseline Concentration (mg/L)")

#And now for the magic - we'll use 25 bins
ggMarginal(diffplot, type="histogram", bins = 25)

diffplotp <- ggplot(my.data, aes(baseline, diffp)) + 
    geom_point(size=2, colour = rgb(0,0,0, alpha = 0.5)) + 
    theme_bw() + 
    geom_hline(yintercept = 0, linetype = 3) +
    geom_hline(yintercept = mean(my.data$diffp)) +
    geom_hline(yintercept = mean(my.data$diffp) + 2*sd.diffp, linetype = 2) +
    geom_hline(yintercept = mean(my.data$diffp) - 2*sd.diffp, linetype = 2) +
    ylab("Difference pre and post Storage (%)") +
    xlab("Baseline Concentration (mg/L)")


ggMarginal(diffplotp, type="histogram", bins = 25)
