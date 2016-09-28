profvis({
    data1 <- data
    means <- vapply(data1[, names(data1) != "id"], mean, numeric(1))
    
    for (i in seq_along(means)) {
        data1[, names(data1) != "id"][, i] <- data1[, names(data1) != "id"][, i] - means[i]
    }
})
