install.packages("sparklyr")

library(sparklyr)
spark_install(version = "1.6.2")
sc <- spark_connect(master = "local")

library(dplyr)
install.packages("nycflights13")

iris_tbl <- copy_to(sc, iris)
flights_tbl <- copy_to(sc, nycflights13::flights, "flights")
batting_tbl <- copy_to(sc, Lahman::Batting, "batting")

# filter by departure delay
flights_tbl %>% filter(dep_delay == 2)

#Introduction to dplyr provides additional dplyr examples you can try. For example, consider the last example from the tutorial which plots data on flight delays:

delay <- flights_tbl %>% 
    group_by(tailnum) %>%
    summarise(count = n(), dist = mean(distance), delay = mean(arr_delay)) %>%
    filter(count > 20, dist < 2000, !is.na(delay)) %>%
    collect()

# plot delays
library(ggplot2)
ggplot(delay, aes(dist, delay)) +
    geom_point(aes(size = count), alpha = 1/2) +
    geom_smooth() +
    scale_size_area(max_size = 2)


batting_tbl %>%
    select(playerID, yearID, teamID, G, AB:H) %>%
    arrange(playerID, yearID, teamID) %>%
    group_by(playerID) %>%
    filter(min_rank(desc(H)) <= 2 & H > 0)

library(DBI)
iris_preview <- dbGetQuery(sc, "SELECT * FROM iris LIMIT 10")


# copy mtcars into spark
mtcars_tbl <- copy_to(sc, mtcars)

# transform our data set, and then partition into 'training', 'test'
partitions <- mtcars_tbl %>%
    filter(hp >= 100) %>%
    mutate(cyl8 = cyl == 8) %>%
    sdf_partition(training = 0.5, test = 0.5, seed = 1099)

# fit a linear model to the training dataset
fit <- partitions$training %>%
    ml_linear_regression(response = "mpg", features = c("wt", "cyl"))

summary(fit)

library(sparklyr)
library(rsparkling)
library(h2o)
library(dplyr)

# connect to spark
sc <- spark_connect("local", version = "1.6.2")

# copy mtcars dataset into spark
mtcars_tbl <- copy_to(sc, mtcars, "mtcars", overwrite = TRUE)

# transform our data set, and then partition into 'training', 'test'
partitions <- mtcars_tbl %>%
    filter(hp >= 100) %>%
    mutate(cyl8 = cyl == 8) %>%
    sdf_partition(training = 0.5, test = 0.5, seed = 1099)

training <- as_h2o_frame(partitions$training)
test <- as_h2o_frame(partitions$test)

# fit a linear model to the training dataset
fit <- h2o.glm(x = c("wt", "cyl"), 
               y = "mpg", 
               training_frame = training,
               lambda_search = TRUE)
