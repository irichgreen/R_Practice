library(plotly)

set_credentials_file("irichgreen", "fpm0x00yva")

# Basic example
py <- plotly()

trace0 <- list(
    x = c(1, 2, 3, 4),
    y = c(10, 15, 13, 17)
)
trace1 <- list(
    x = c(1, 2, 3, 4),
    y = c(16, 5, 11, 9)
)
response <- py$plotly(trace0, trace1, kwargs=list(filename="basic-line", fileopt="overwrite"))
response$url

browseURL(response$url)

# Publish my ggplot2 figures to the web with one line!

dsamp <- diamonds[sample(nrow(diamonds), 1000), ]
qplot(carat, price, data=dsamp, colour=clarity)

py <- plotly()
py$ggplotly()


local({r <- getOption("repos")  # You'll want to select the CRAN mirror you like.
r["CRAN"] <- "http://cran.r-project.org" 
options(repos=r)
})

#install.packages("WDI")
library(WDI)  # Now we’ll make the plot from the blog post

py <- plotly("ggplot2examples", "3gazttckd7")  # Open Plotly connection

dat = WDI(indicator='NY.GNP.PCAP.CD', country=c('CL','HU','UY'), start=1960, end=2012)
# Grab GNI per capita data for Chile, Hungary and Uruguay

wb <- ggplot(dat, aes(year, NY.GNP.PCAP.CD, color=country)) + geom_line() 
+     xlab('Year') + ylab('GDI per capita (Atlas Method USD)') 
+     labs(title <- "GNI Per Capita ($USD Atlas Method)")

py$ggplotly(wb)  # Call the ggplotly conversion function

