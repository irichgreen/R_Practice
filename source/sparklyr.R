# sparklyR
# devtools::install_github("rstudio/sparklyr")

library(sparklyr)
spark_install(version = "1.6.2")

sc <- spark_connect(master = "local")

# Reading Data
# You can copy R data frames into Spark using the dplyr copy_to function (more typically though you’ll read data within the Spark cluster using the spark_read family of functions). For the examples below we’ll copy some datasets from R into Spark (note that you may need to install the nycflights13 and Lahman packages in order to execute this code):
    
iris_tbl <- copy_to(sc, iris)
flights_tbl <- copy_to(sc, nycflights13::flights, "flights")
batting_tbl <- copy_to(sc, Lahman::Batting, "batting")
