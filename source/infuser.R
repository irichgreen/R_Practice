install.packages("infuser")
library(infuser)

my_sql<-"SELECT * FROM Customers
WHERE Year = {{year}}
AND Month = {{month|3}};"

library(infuser)
variables_requested(my_sql, verbose = TRUE)

## Variables requested by template:
## >> year
## >> month (default = 3)

infused_sql<-
    infuse(my_sql, year=2016, month=8)

cat(infused_sql)

infused_sql<-
    infuse(my_sql, year=2016)

cat(infused_sql)

example_file<-
    system.file("extdata", "sql1.sql", package="infuser")

example_file

variables_requested(example_file, verbose = TRUE)

infused_template<-
    infuse(example_file, year = 2016, month = 12)

cat(infused_template)

