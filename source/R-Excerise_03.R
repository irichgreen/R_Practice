library(reshape2)

####################
#                  #
#    Exercise 1    #
#                  #
####################

moltenMtcars <- melt(mtcars, id.vars = c("cyl", "gear"))

####################
#                  #
#    Exercise 2    #
#                  #
####################

CarSurvey <- dcast(moltenMtcars, cyl + gear ~ variable, mean)

####################
#                  #
#    Exercise 3    #
#                  #
####################

weatherSurvey <- melt(airquality, id.vars=c("Month", "Day"))

####################
#                  #
#    Exercise 4    #
#                  #
####################

weatherSurvey <- melt(airquality, id.vars=c("Month", "Day"),
                      variable.name="Condition", value.name="Measurement")

####################
#                  #
#    Exercise 5    #
#                  #
####################

airqualityEdit <- dcast(weatherSurvey, Month + Day ~ Condition,
                        value.var = "Measurement")

####################
#                  #
#    Exercise 6    #
#                  #
####################

AirQualityArray <- acast(weatherSurvey, Day ~ Month ~ Condition,
                         value.var = "Measurement")

####################
#                  #
#    Exercise 7    #
#                  #
####################

acast(weatherSurvey, Month ~ Condition, fun.aggregate = mean,
      value.var = "Measurement", na.rm = T)
##      Ozone  Solar.R      Wind     Temp
## 5 23.61538 181.2963 11.622581 65.54839
## 6 29.44444 190.1667 10.266667 79.10000
## 7 59.11538 216.4839  8.941935 83.90323
## 8 59.96154 171.8571  8.793548 83.96774
## 9 31.44828 167.4333 10.180000 76.90000
####################
#                  #
#    Exercise 8    #
#                  #
####################

acast(weatherSurvey, Month ~ Condition, fun.aggregate = mean,
      na.rm = T, margins = TRUE)
##          Ozone  Solar.R      Wind     Temp    (all)
## 5     23.61538 181.2963 11.622581 65.54839 68.70696
## 6     29.44444 190.1667 10.266667 79.10000 87.38384
## 7     59.11538 216.4839  8.941935 83.90323 93.49748
## 8     59.96154 171.8571  8.793548 83.96774 79.71207
## 9     31.44828 167.4333 10.180000 76.90000 71.82689
## (all) 42.12931 185.9315  9.957516 77.88235 80.05722
####################
#                  #
#    Exercise 9    #
#                  #
####################

recast(mtcars, cyl + gear ~ variable, mean, id.var = c("cyl", "gear"))
##   cyl gear    mpg     disp       hp     drat       wt    qsec  vs   am
## 1   4    3 21.500 120.1000  97.0000 3.700000 2.465000 20.0100 1.0 0.00
## 2   4    4 26.925 102.6250  76.0000 4.110000 2.378125 19.6125 1.0 0.75
## 3   4    5 28.200 107.7000 102.0000 4.100000 1.826500 16.8000 0.5 1.00
## 4   6    3 19.750 241.5000 107.5000 2.920000 3.337500 19.8300 1.0 0.00
## 5   6    4 19.750 163.8000 116.5000 3.910000 3.093750 17.6700 0.5 0.50
## 6   6    5 19.700 145.0000 175.0000 3.620000 2.770000 15.5000 0.0 1.00
## 7   8    3 15.050 357.6167 194.1667 3.120833 4.104083 17.1425 0.0 0.00
## 8   8    5 15.400 326.0000 299.5000 3.880000 3.370000 14.5500 0.0 1.00
##       carb
## 1 1.000000
## 2 1.500000
## 3 2.000000
## 4 1.000000
## 5 4.000000
## 6 6.000000
## 7 3.083333
## 8 6.000000
####################
#                  #
#    Exercise 10   #
#                  #
####################

recast(airquality, Month + Day ~ variable, mean, id.var = c("Month", "Day"))[1:5,]
##   Month Day Ozone Solar.R Wind Temp
## 1     5   1    41     190  7.4   67
## 2     5   2    36     118  8.0   72
## 3     5   3    12     149 12.6   74
## 4     5   4    18     313 11.5   62
## 5     5   5    NA      NA 14.3   56
