library(stringr)
library(stringi)


strings <- c(
    "apple", 
    "219 733 8965", 
    "329-293-8753", 
    "Work: 579-499-7527; Home: 543.355.3679"
)
phone <- "([2-9][0-9]{2})[- .]([0-9]{3})[- .]([0-9]{4})"


str_detect(strings, phone)
#> [1] FALSE  TRUE  TRUE  TRUE
str_subset(strings, phone)


(loc <- str_locate(strings, phone))
str_locate_all(strings, phone)


col2hex <- function(col) {
    rgb <- col2rgb(col)
    rgb(rgb["red", ], rgb["green", ], rgb["blue", ], max = 255)
}

# Goal replace colour names in a string with their hex equivalent
strings <- c("Roses are red, violets are blue", "My favourite colour is green")

colours <- str_c("\\b", colors(), "\\b", collapse="|")
# This gets us the colours, but we have no way of replacing them
str_extract_all(strings, colours)
#> [[1]]
#> [1] "red"  "blue"
#> 
#> [[2]]
#> [1] "green"

# Instead, let's work with locations
locs <- str_locate_all(strings, colours)
Map(function(string, loc) {
    hex <- col2hex(str_sub(string, loc))
    str_sub(string, loc) <- hex
    string
}, strings, locs)
#> $`Roses are red, violets are blue`
#> [1] "Roses are #FF0000, violets are blue"
#> [2] "Roses are red, violets are #0000FF" 
#> 
#> $`My favourite colour is green`
#> [1] "My favourite colour is #00FF00"


matches <- col2hex(colors())
names(matches) <- str_c("\\b", colors(), "\\b")

str_replace_all(strings, matches)
#> [1] "Roses are #FF0000, violets are #0000FF"
#> [2] "My favourite colour is #00FF00"

