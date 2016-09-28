library(cranlogs)
library(forecast)

# To look at temporal patterns in the past 3 years’ download statistics from RStudio CRAN mirror for individual R packages. I quantified past trend based on fitting a log-linear glm model to counts vs. dates. Then I used the forecast package by Rob Hyndman to make short-term forecast based on an additive non-seasonal exponential smoothing model. Here is the plot_pkg_trend function:
    
plot_pkg_trend <-
    function(pkg)
    {
        op <- par(mar = c(3, 3, 1, 1) + 0.1, las = 1)
        on.exit(par(op))
        ## grab the data
        x <- cran_downloads(pkg, from = "2013-08-21", to = "2016-08-19")
        x$date <- as.Date(x$date)
        x$std_days <- 1:nrow(x) / 365
        ## past trend
        m <- glm(count ~ std_days, x, family = poisson)
        tr_past <- round(100 * (exp(coef(m)[2L]) - 1), 2)
        ## future trend
        s <- ts(x$count)
        z <- ets(s, model = "AAN")
        f <- forecast(z, h=365)
        f$date <- seq(as.Date("2016-08-20"), as.Date("2017-08-19"), 1)
        tr_future <- round(100 * (f$mean[length(f$mean)] / f$mean[1L] - 1), 2)
        ## plot
        plot(count ~ date, x, type = "l", col = "darkgrey",
             ylab = "", xlab = "",
             ylim = c(0, quantile(x$count, 0.999)),
             xlim = c(x$date[1L], as.Date("2017-08-19")))
        lines(lowess(x$date, x$count), col = 2, lwd = 2)
        polygon(c(f$date, rev(f$date)),
                c(f$upper[,2L], rev(f$lower[,2L])),
                border = NA, col = "lightblue")
        lines(f$date, f$mean, col = 4, lwd = 2)
        legend("topleft", title = paste("Package:", pkg), bty = "n",
               col = c(2, 4), lwd = 2, cex = 1,
               legend = c(paste0("past: ", tr_past, "%"),
                          paste0("future: ", tr_future, "%")))
        ## return the data
        invisible(x)
    }

# Next, we list the top 10 R packages from the last month:
cran_top_downloads("last-month")

# The top package was Rcpp by Dirk Eddelbuettel et al. and
# here is the daily trend plot with percent annual trend estimates:
plot_pkg_trend("Rcpp")

# The increase is clear with increasing day-to-day variation suggesting that the log-linear model might be appropriate. Steady increase is predicted (the blue line starts at the last observed data point, whereas the red line is a locally weighted lowess smoothing curve on past data). The light blue 95% prediction intervals nicely follow the bulk of the zig-zagging in the observed trend. Now for my packages, here are the ones I use most often

op <- par(mfrow = c(2, 2))
plot_pkg_trend("pbapply")
plot_pkg_trend("ResourceSelection")
plot_pkg_trend("dclone")
plot_pkg_trend("mefa4")
par(op)

# Two of them increasing nicely, the other two are showing some leveling-off. And finally, results for some packages that I am contributing to:
    
op <- par(mfrow = c(2, 2))
x <- plot_pkg_trend("vegan")
x <- plot_pkg_trend("epiR")
x <- plot_pkg_trend("adegenet")
x <- plot_pkg_trend("plotrix")
par(op)


