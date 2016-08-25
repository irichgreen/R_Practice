install.packages('blscrapeR')

library(blscrapeR)
# Median Usual Weekly Earnings by Occupation, Unadjusted Second Quartile.
# In current dollars
df <- bls_api(c("LEU0254530800", "LEU0254530600"),
              startyear = 2000, endyear = 2015)
# Plot
library(ggplot2)
ggplot(df, aes(x=date, y=value, color=seriesID)) +
    geom_line() +
    labs(title = "Median Weekly Earnings by Occupation") +
    theme(legend.position="top") +
    scale_color_discrete(name="Occupation",
                         breaks=c("LEU0254530800", "LEU0254530600"),
                         labels=c("Database Admins.", "Software Devs."))
