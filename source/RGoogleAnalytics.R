require(RGoogleAnalytics)

# Authorize the Google Analytics account
# This need not be executed in every session once the token object is created 
# and saved
client.id <- "418069037655-hmr95ppc6gqu4ia10dqjscnu0h805u06.apps.googleusercontent.com"
client.secret <- "Osvd0gLAyaSqSqUrEfz93x8h"
token <- Auth(client.id,client.secret)

# Save the token object for future sessions
save(token,file="./token_file")

# Get the Sessions & Transactions for each Source/Medium sorted in 
# descending order by the Transactions

query.list <- Init(start.date = "2014-08-01",
                   end.date = "2014-09-01",
                   dimensions = "ga:sourceMedium",
                   metrics = "ga:sessions,ga:transactions",
                   max.results = 10000,
                   sort = "-ga:transactions",
                   table.id = "ga:123456")

# Create the Query Builder object so that the query parameters are validated
ga.query <- QueryBuilder(query.list)

# Extract the data and store it in a data-frame
ga.data <- GetReportData(ga.query, token)

# Sanity Check for column names
dimnames(ga.data)

# Check the size of the API Response
dim(ga.data)

load("./token_file")

# Validate and refresh the token
ValidateToken(token)
