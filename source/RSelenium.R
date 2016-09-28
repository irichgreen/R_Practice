library("RSelenium")
startServer()
mybrowser <- remoteDriver()
mybrowser$open()
mybrowser$navigate("http://www.weather.gov")
mybrowser$findElement(using = 'css selector', "#inputstring")
wxbox <- mybrowser$findElement(using = 'css selector', "#inputstring")
wxbox$sendKeysToElement(list("01701"))
wxbutton <- mybrowser$findElement(using = 'css selector', "#btnSearch")
wxbutton$clickElement()
mybrowser$goBack()
wxbox <- mybrowser$findElement(using = 'css selector', "#inputstring")
wxbox$sendKeysToElement(list("01701", "\uE007"))

require(shiny)
runApp(paste0(find.package("RSelenium"), "/apps/shinytestapp"), port = 6012)


user <- "rselenium0"
pass <- "***************************"
port <- 80
ip <- paste0(user, ':', pass, "@ondemand.saucelabs.com")
browser <- "firefox"
version <- "26"
platform <- "Windows 8.1"
extraCapabilities <- list(name = "shinytestapp screenshot", username = user, accessKey = pass)

remDr <- remoteDriver$new(remoteServerAddr = ip, port = port, browserName = browser
                          , version = version, platform = platform
                          , extraCapabilities = extraCapabilities)
remDr$open()
remDr$navigate("http://spark.rstudio.com/johnharrison/shinytestapp/")
webElems <- remDr$findElements("css selector", "#ctrlSelect input")
lapply(webElems, function(x){x$clickElement()})
scr <- remDr$screenshot(display = TRUE)
