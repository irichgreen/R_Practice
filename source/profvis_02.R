profvis({
    data1 <- data
    # Four different ways of getting column means
    means <- apply(data1[, names(data1) != "id"], 2, mean)
    means <- colMeans(data1[, names(data1) != "id"])
    means <- lapply(data1[, names(data1) != "id"], mean)
    means <- vapply(data1[, names(data1) != "id"], mean, numeric(1))
})
