####################
#                  #
#    Exercise 1    #
#                  #
####################

library("quantmod")
# rata
fb.p <- getSymbols("FB", env=NULL)

####################
#                  #
#    Exercise 2    #
#                  #
####################

Cl(to.monthly(fb.p["2015::2015-12-31"]))
## Warning: timezone of object (UTC) is different than current timezone ().
##          fb.p["2015::2015-12-31"].Close
## jan 2015                          75.91
## feb 2015                          78.97
## mar 2015                          82.22
## apr 2015                          78.77
## maj 2015                          79.19
## jun 2015                          85.77
## jul 2015                          94.01
## avg 2015                          89.43
## sep 2015                          89.90
## okt 2015                         101.97
## nov 2015                         104.24
## dec 2015                         104.66
####################
#                  #
#    Exercise 3    #
#                  #
####################

plot(weeklyReturn(fb.p, subset="2016::"), main="Weekly return of Facebook")

####################
#                  #
#    Exercise 4    #
#                  #
####################

candleChart(fb.p, subset="2016::2016-12-31", name="Facebook", theme="white")


####################
#                  #
#    Exercise 5    #
#                  #
####################

chartSeries(fb.p, subset="2016::2016-12-31", type="line", name="Facebook", theme="white")
addBBands()
addRSI()

####################
#                  #
#    Exercise 6    #
#                  #
####################

getFX("EUR/USD", from=Sys.Date()-1, env = NULL)
##            EUR.USD
## 2016-08-29 1.11874
####################
#                  #
#    Exercise 7    #
#                  #
####################

fb.f <- getFin("FB", env=NULL)
viewFin(fb.f)
##                                              2015-12-31 2014-12-31
## Cash & Equivalents                                   NA         NA
## Short Term Investments                            16731       9037
## Cash and Short Term Investments                   18434      11199
## Accounts Receivable - Trade, Net                   2559       1678
## Receivables - Other                                  NA         NA
## Total Receivables, Net                             2559       1678
## Total Inventory                                      NA         NA
## Prepaid Expenses                                    659        513
## Other Current Assets, Total                          NA         NA
## Total Current Assets                              21652      13390
## Property/Plant/Equipment, Total - Gross            7819       5784
## Accumulated Depreciation, Total                   -2132      -1817
## Goodwill, Net                                     18026      17981
## Intangibles, Net                                   3246       3929
## Long Term Investments                                NA         NA
## Other Long Term Assets, Total                       796        699
## Total Assets                                      49407      39966
## Accounts Payable                                    413        378
## Accrued Expenses                                   1449        866
## Notes Payable/Short Term Debt                         0          0
## Current Port. of LT Debt/Capital Leases               7        114
## Other Current liabilities, Total                     56         66
## Total Current Liabilities                          1925       1424
## Long Term Debt                                       NA         NA
## Capital Lease Obligations                           107        119
## Total Long Term Debt                                107        119
## Total Debt                                          114        233
## Deferred Income Tax                                 163        769
## Minority Interest                                    NA         NA
## Other Liabilities, Total                           2994       1558
## Total Liabilities                                  5189       3870
## Redeemable Preferred Stock, Total                    NA         NA
## Preferred Stock - Non Redeemable, Net                NA         NA
## Common Stock, Total                                   0          0
## Additional Paid-In Capital                        34886      30225
## Retained Earnings (Accumulated Deficit)            9787       6099
## Treasury Stock - Common                              NA         NA
## Other Equity, Total                                -430       -227
## Total Equity                                      44218      36096
## Total Liabilities & Shareholders' Equity      49407      39966
## Shares Outs - Common Stock Primary Issue             NA         NA
## Total Common Shares Outstanding                    2845       2797
##                                              2013-12-31 2012-12-31
## Cash & Equivalents                                   NA    2384.00
## Short Term Investments                            10405    7242.00
## Cash and Short Term Investments                   11449    9626.00
## Accounts Receivable - Trade, Net                   1109     719.00
## Receivables - Other                                  NA         NA
## Total Receivables, Net                             1109    1170.00
## Total Inventory                                      NA         NA
## Prepaid Expenses                                    512     471.00
## Other Current Assets, Total                          NA         NA
## Total Current Assets                              13070   11267.00
## Property/Plant/Equipment, Total - Gross            4142    3273.00
## Accumulated Depreciation, Total                   -1260    -882.00
## Goodwill, Net                                       839     587.00
## Intangibles, Net                                    883     801.00
## Long Term Investments                                NA         NA
## Other Long Term Assets, Total                       221      57.00
## Total Assets                                      17895   15103.00
## Accounts Payable                                    268     234.00
## Accrued Expenses                                    555     423.00
## Notes Payable/Short Term Debt                         0       0.00
## Current Port. of LT Debt/Capital Leases             239     365.00
## Other Current liabilities, Total                     38      30.00
## Total Current Liabilities                          1100    1052.00
## Long Term Debt                                       NA    1500.00
## Capital Lease Obligations                           237     491.00
## Total Long Term Debt                                237    1991.00
## Total Debt                                          476    2356.00
## Deferred Income Tax                                  NA         NA
## Minority Interest                                    NA         NA
## Other Liabilities, Total                           1088     305.00
## Total Liabilities                                  2425    3348.00
## Redeemable Preferred Stock, Total                    NA         NA
## Preferred Stock - Non Redeemable, Net                NA       0.00
## Common Stock, Total                                   0       0.00
## Additional Paid-In Capital                        12297   10094.00
## Retained Earnings (Accumulated Deficit)            3159    1659.00
## Treasury Stock - Common                              NA         NA
## Other Equity, Total                                  12       2.00
## Total Equity                                      15470   11755.00
## Total Liabilities & Shareholders' Equity      17895   15103.00
## Shares Outs - Common Stock Primary Issue             NA         NA
## Total Common Shares Outstanding                    2547    2372.71
## attr(,"col_desc")
## [1] "As of 2015-12-31" "As of 2014-12-31" "As of 2013-12-31"
## [4] "As of 2012-12-31"
####################
#                  #
#    Exercise 8    #
#                  #
####################

fb.bs <- viewFin(fb.f, "BS","A")
fb.bs["Total Current Assets",c("2013-12-31", "2014-12-31", "2015-12-31")]/fb.bs["Total Current Liabilities",c("2013-12-31", "2014-12-31", "2015-12-31")]
## 2013-12-31 2014-12-31 2015-12-31 
##   11.88182    9.40309   11.24779
####################
#                  #
#    Exercise 9    #
#                  #
####################

price <- Cl(fb.p[NROW(fb.p)])
fb.is <- viewFin(fb.f, "IS", "a")
EPS <- fb.is["Diluted Normalized EPS", "2015-12-31"]

price/EPS
##            FB.Close
## 2016-08-29 98.09302
####################
#                  #
#    Exercise 10   #
#                  #
####################

getROA <- function(symbol, year)
{
    symbol.f <- getFin(symbol, env=NULL)
    symbol.ni <- viewFin(symbol.f, "IS", "A")["Net Income", paste(year, sep="", "-12-31")]
    symbol.ta <- viewFin(symbol.f, "BS", "A")["Total Assets", paste(year, sep="", "-12-31")]
    
    symbol.ni/symbol.ta*100
}

getROA("FB", "2015")

