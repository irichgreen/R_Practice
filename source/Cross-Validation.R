# Generate the training and test samples
seed <- 1809
set.seed(seed)

gen_data <- function(n, beta, sigma_eps) {
    eps <- rnorm(n, 0, sigma_eps)
    x <- sort(runif(n, 0, 100))
    X <- cbind(1, poly(x, degree = (length(beta) - 1), raw = TRUE))
    y <- as.numeric(X %*% beta + eps)
    
    return(data.frame(x = x, y = y))
}

# Fit the models
require(splines)

n_rep <- 100
n_df <- 30
df <- 1:n_df
beta <- c(5, -0.1, 0.004, -3e-05)
n_train <- 50
n_test <- 10000
sigma_eps <- 0.5

xy <- res <- list()
xy_test <- gen_data(n_test, beta, sigma_eps)
for (i in 1:n_rep) {
    xy[[i]] <- gen_data(n_train, beta, sigma_eps)
    x <- xy[[i]][, "x"]
    y <- xy[[i]][, "y"]
    res[[i]] <- apply(t(df), 2, function(degf) lm(y ~ ns(x, df = degf)))
}



# Plot the data
x <- xy[[1]]$x
X <- cbind(1, poly(x, degree = (length(beta) - 1), raw = TRUE))
y <- xy[[1]]$y
plot(y ~ x, col = "gray", lwd = 2)
lines(x, X %*% beta, lwd = 3, col = "black")
lines(x, fitted(res[[1]][[1]]), lwd = 3, col = "palegreen3")
lines(x, fitted(res[[1]][[4]]), lwd = 3, col = "darkorange")
lines(x, fitted(res[[1]][[25]]), lwd = 3, col = "steelblue")
legend(x = "topleft", legend = c("True function", "Linear fit (df = 1)", "Best model (df = 4)", 
                                 "Overfitted model (df = 25)"), lwd = rep(3, 4), col = c("black", "palegreen3", 
                                                                                         "darkorange", "steelblue"), text.width = 32, cex = 0.85)




# Compute the training and test errors for each model
pred <- list()
mse <- te <- matrix(NA, nrow = n_df, ncol = n_rep)
for (i in 1:n_rep) {
    mse[, i] <- sapply(res[[i]], function(obj) deviance(obj)/nobs(obj))
    pred[[i]] <- mapply(function(obj, degf) predict(obj, data.frame(x = xy_test$x)), 
                        res[[i]], df)
    te[, i] <- sapply(as.list(data.frame(pred[[i]])), function(y_hat) mean((xy_test$y - 
                                                                                y_hat)^2))
}

# Compute the average training and test errors
av_mse <- rowMeans(mse)
av_te <- rowMeans(te)

# Plot the errors
plot(df, av_mse, type = "l", lwd = 2, col = gray(0.4), ylab = "Prediction error", 
     xlab = "Flexibilty (spline's degrees of freedom [log scaled])", ylim = c(0, 
                                                                              1), log = "x")
abline(h = sigma_eps, lty = 2, lwd = 0.5)
for (i in 1:n_rep) {
    lines(df, te[, i], col = "lightpink")
}
for (i in 1:n_rep) {
    lines(df, mse[, i], col = gray(0.8))
}
lines(df, av_mse, lwd = 2, col = gray(0.4))
lines(df, av_te, lwd = 2, col = "darkred")
points(df[1], av_mse[1], col = "palegreen3", pch = 17, cex = 1.5)
points(df[1], av_te[1], col = "palegreen3", pch = 17, cex = 1.5)
points(df[which.min(av_te)], av_mse[which.min(av_te)], col = "darkorange", pch = 16, 
       cex = 1.5)
points(df[which.min(av_te)], av_te[which.min(av_te)], col = "darkorange", pch = 16, 
       cex = 1.5)
points(df[25], av_mse[25], col = "steelblue", pch = 15, cex = 1.5)
points(df[25], av_te[25], col = "steelblue", pch = 15, cex = 1.5)
legend(x = "top", legend = c("Training error", "Test error"), lwd = rep(2, 2), 
       col = c(gray(0.4), "darkred"), text.width = 0.3, cex = 0.85)

