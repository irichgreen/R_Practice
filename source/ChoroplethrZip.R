#install.packages("devtools")
#library(devtools)
#install_github('arilamstein/choroplethrZip@v1.3.0')

library(choroplethrZip)
data(df_zip_demographics)

?df_zip_demographics
colnames(df_zip_demographics)
summary(df_zip_demographics[, "total_population"])

# for each column in the data.frame
for (i in 2:ncol(df_zip_demographics))
{
    # set the value and title
    df_zip_demographics$value = df_zip_demographics[,i]
    title = paste0("2013 ZCTA Demographics:n",
                   colnames(df_zip_demographics[i]))
    
    # print the map
    choro = zip_choropleth(df_zip_demographics, title=title)
    print(choro)
}
