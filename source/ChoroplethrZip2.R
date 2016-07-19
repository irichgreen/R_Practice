library(choroplethr)

?df_state_demographics


data(df_state_demographics)
boxplot(df_state_demographics$percent_hispanic)


library(choroplethrZip)

?zip.regions
data(zip.regions)
head(zip.regions)


library(choroplethr)
library(choroplethrZip)

?df_pop_zip
data(df_pop_zip)

?zip_choropleth
zip_choropleth(df_pop_zip, 
               state_zoom="new york", 
               title="2012 New York State ZCTA Population Estimates",
               legend="Population")


#New York City is comprised of 5 counties: Bronx, Kings (Brooklyn), New York (Manhattan), 
# Queens, Richmond (Staten Island). Their numeric FIPS codes are:
nyc_fips = c(36005, 36047, 36061, 36081, 36085)
zip_choropleth(df_pop_zip,
               county_zoom=nyc_fips,
               title="2012 New York City ZCTA Population Estimates",
               legend="Population")


manhattan_les = c("10002", "10003", "10009")
manhattan_ues = c("10021", "10028", "10044", "10128")
zip_choropleth(df_pop_zip,
               zip_zoom=c(manhattan_les, manhattan_ues),
               title="2012 Lower and Upper East Side ZCTA Population Estimates",
               legend="Population")


zip_choropleth(df_pop_zip,
               msa_zoom="New York-Newark-Jersey City, NY-NJ-PA",
               title="2012 NY-Newark-Jersey City MSA\nZCTA Population Estimates",
               legend="Population")


library(ggplot2)

choro = ZipChoropleth$new(df_pop_zip)
choro$title = "2012 ZCTA Population Estimates"
choro$ggplot_scale = scale_fill_brewer(name="Population", palette=2, drop=FALSE)
choro$set_zoom_zip(state_zoom="new york", county_zoom=NULL, msa_zoom=NULL, zip_zoom=NULL)
choro$render()

