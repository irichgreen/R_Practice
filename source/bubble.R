library(bubbles)

bubbles(value = runif(26), label = LETTERS,
        color = rainbow(26, alpha=NULL)[sample(26)]
)
