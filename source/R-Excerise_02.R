# Dates and Times – Simple and Easy with lubridate solutions (part 1,2)

install.packages("lubridate")
library(lubridate)

####################
#                  #
#    Exercise 1    #
#                  #
####################
start_date<- dmy("23012017")
start_date
## [1] "2017-01-23"
####################
#                  #
#    Exercise 2    #
#                  #
####################
today()
## [1] "2016-08-14"
####################
#                  #
#    Exercise 3    #
#                  #
####################
year(start_date)
## [1] 2017
####################
#                  #
#    Exercise 4    #
#                  #
####################
month(start_date)
## [1] 1
####################
#                  #
#    Exercise 5    #
#                  #
####################
day(start_date)
## [1] 23
####################
#                  #
#    Exercise 6    #
#                  #
####################
month(start_date) <- 2

####################
#                  #
#    Exercise 7    #
#                  #
####################
start_date + days(6)
## [1] "2017-03-01"
####################
#                  #
#    Exercise 8    #
#                  #
####################
start_date - months(3)
## [1] "2016-11-23"
####################
#                  #
#    Exercise 9    #
#                  #
####################
concatenated_dates <- dmy(c("31.12.2015", "01.01.2016",  "15.02.2016"))
concatenated_dates
## [1] "2015-12-31" "2016-01-01" "2016-02-15"
####################
#                  #
#    Exercise 10   #
#                  #
####################
start_date + c(1:10) * days(1)
##  [1] "2017-02-24" "2017-02-25" "2017-02-26" "2017-02-27" "2017-02-28"
##  [6] "2017-03-01" "2017-03-02" "2017-03-03" "20


####################
#                  #
#    Exercise 1    #
#                  #
####################
start_date <- dmy_hms("01/12/2015 15:40:32")
end_date <- dmy_hms("01/10/2016 16:01:10")

####################
#                  #
#    Exercise 2    #
#                  #
####################
my_interval <- interval(start_date,end_date)

####################
#                  #
#    Exercise 3    #
#                  #
####################
class(my_interval)
## [1] "Interval"
## attr(,"package")
## [1] "lubridate"
####################
#                  #
#    Exercise 4    #
#                  #
####################
wday(start_date,label = TRUE,abbr = FALSE)
## [1] Tuesday
## 7 Levels: Sunday < Monday < Tuesday < Wednesday < Thursday < ... < Saturday
####################
#                  #
#    Exercise 5    #
#                  #
####################
yday(end_date) > 230
## [1] TRUE
####################
#                  #
#    Exercise 6    #
#                  #
####################
grep("Buenos_Aires",OlsonNames(),value=TRUE)
## [1] "America/Argentina/Buenos_Aires" "America/Buenos_Aires"
####################
#                  #
#    Exercise 7    #
#                  #
####################
with_tz(end_date, "America/Argentina/Buenos_Aires")
## [1] "2016-10-01 13:01:10 ART"
####################
#                  #
#    Exercise 8    #
#                  #
####################
NY_TZ <- grep("New_York",OlsonNames(),value=TRUE)

####################
#                  #
#    Exercise 9    #
#                  #
####################
end_date_ny <- force_tz(end_date, NY_TZ)

####################
#                  #
#    Exercise 10   #
#                  #
####################
end_date_ny - end_date
## Time difference of 4 hours

