# Remove previous versions of h2o R package
if ("package:h2o" %in% search()) detach("package:h2o", unload=TRUE)
if ("h2o" %in% rownames(installed.packages())) remove.packages("h2o")

# Next, we download R package dependencies
pkgs <- c("methods","statmod","stats","graphics",
          "RCurl","jsonlite","tools","utils")
for (pkg in pkgs) {
    if (!(pkg %in% rownames(installed.packages()))) install.packages(pkg)
}

# Download h2o package version 3.10.0.6
install.packages("h2o", type = "source", 
                 repos = "http://h2o-release.s3.amazonaws.com/h2o/rel-turing/6/R")

library(devtools)
devtools::install_github("h2oai/sparkling-water", subdir = "/r/rsparkling")

library(sparklyr)
library(rsparkling)
library(dplyr)

sc <- spark_connect("local", version = "1.6.2")
mtcars_tbl <- copy_to(sc, mtcars, "mtcars", overwrite = TRUE)

# transform our data set, and then partition into 'training', 'test'
partitions <- mtcars_tbl %>%
    filter(hp >= 100) %>%
    mutate(cyl8 = cyl == 8) %>%
    sdf_partition(training = 0.5, test = 0.5, seed = 1099)

training <- as_h2o_frame(sc, partitions$training)
test <- as_h2o_frame(sc, partitions$test)
