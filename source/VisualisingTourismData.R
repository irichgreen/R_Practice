# ---------------------------------------------
# 월드뱅크 관광객 데이터 활용
# 모션 차트로 출력하는 샘플 분석예
# 이 파일을 실행시키려면, R의 공개 패키지 중에 
# googleVis 및 RJSONIO를 설치해야 합니다.
# ---------------------------------------------
#install.packages(c("googleVis", "RJSONIO"))
getWorldBankData <- function(id='SP.POP.TOTL', date='1960:2010',
                             value="value", per.page=12000){
    library(RJSONIO)
    url <- paste("http://api.worldbank.org/countries/all/indicators/", id,
                 "?date=", date, "&format=json&per_page=", per.page,
                 sep="")
    
    wbData <- fromJSON(url)[[2]]
    
    wbData = data.frame(
        year = as.numeric(sapply(wbData, "[[", "date")),
        value = as.numeric(sapply(wbData, function(x)
            ifelse(is.null(x[["value"]]),NA, x[["value"]]))),
        country.name = sapply(wbData, function(x) x[["country"]]['value']),
        country.id = sapply(wbData, function(x) x[["country"]]['id'])
    )
    
    names(wbData)[2] <- value
    
    return(wbData)
}

getWorldBankCountries <- function(){
    library(RJSONIO)
    wbCountries <-
        fromJSON("http://api.worldbank.org/countries?per_page=12000&format=json")
    wbCountries <- data.frame(t(sapply(wbCountries[[2]], unlist)))
    wbCountries$longitude <- as.numeric(wbCountries$longitude)
    wbCountries$latitude <- as.numeric(wbCountries$latitude)
    levels(wbCountries$region.value) <- gsub(" \\(all income levels\\)",
                                             "", levels(wbCountries$region.value))
    return(wbCountries)
}

## Create a string 1960:this year, e.g. 1960:2011
years <- paste("1960:", format(Sys.Date(), "%Y"), sep="")

## International Tourism Arrivals
inter.tourist.arrivals<- getWorldBankData(id='ST.INT.ARVL',
                                          date=years, value="International tourism, number of arrivals")

## International Tourism Receipts
tourism.receipts <- getWorldBankData(id='ST.INT.RCPT.CD', date=years,
                                     value="International tourism, receipts (current US$)")

## Population
population <- getWorldBankData(id='SP.POP.TOTL', date=years,
                               value="population")

## GDP per capita (current US$)
GDP.per.capita <- getWorldBankData(id='NY.GDP.PCAP.CD',
                                   date=years,
                                   value="GDP.per.capita.Current.USD")

## Merge data sets
wbData <- merge(tourism.receipts, inter.tourist.arrivals)
wbData <- merge(wbData, population)
wbData <- merge(wbData, GDP.per.capita)

## Get country mappings
wbCountries <- getWorldBankCountries()

## Add regional information
wbData <- merge(wbData, wbCountries[c("iso2Code", "region.value",
                                      "incomeLevel.value")],
                by.x="country.id", by.y="iso2Code")

## Filter out the aggregates and country id column
subData <- subset(wbData, !region.value %in% "Aggregates" , select=
                      -country.id)

## Create a motion chart
#require(googleVis)
library(googleVis)
M <- gvisMotionChart(subData, idvar="country.name", timevar="year",
                     options=list(width=800, height=600))

## Display the chart in your browser
plot(M)


