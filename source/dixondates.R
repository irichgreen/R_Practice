#'% Using Dates and Times in R
#'% Bonnie Dixon
#'% 14-02-10 15:09:57
#'
#' *Today at the [Davis R Users'
#' Group](http://www.noamross.net/davis-r-users-group.html), [Bonnie
#' Dixon](http://ffhi.ucdavis.edu/people/directory/bmdixon) gave a tutorial on the
#' various ways to handle dates and times in R. Bonnie provided this great script
#' which walks through essential classes, functions, and packages. Here it is piped through
#' `knitr::spin`. The original R script can be found as a gist
#' [here](https://gist.github.com/noamross/8928124).*
#'
#'Date/time classes
#'=================
#'
#'Three date/time classes are built-in in R, Date, POSIXct, and POSIXlt.
#'
#'
#'Date
#'----
#'
#'This is the class to use if you have only dates, but no times, in your data.
#'
#'create a date:
dt1 <- as.Date("2012-07-22"); dt1
#'non-standard formats must be specified:
dt2 <- as.Date("04/20/2011", format = "%m/%d/%Y"); dt2     
dt3 <- as.Date("October 6, 2010", format = "%B %d, %Y"); dt3
#'see list of format symbols:
?strptime     
#'
#'**calculations with dates:**
#'
#'find the difference between dates:
dt1 - dt2
difftime(dt1, dt2, units = "weeks")
#'Add or subtract days:
dt2 + 10
dt2 - 10
#'create a vector of dates and find the intervals between them:
three.dates <- as.Date(c("2010-07-22", "2011-04-20", "2012-10-06"))
three.dates
diff(three.dates)
#'create a sequence of dates:
six.weeks <- seq(dt1, length = 6, by = "week"); six.weeks
six.weeks <- seq(dt1, length = 6, by = 14); six.weeks
six.weeks <- seq(dt1, length = 6, by = "2 weeks"); six.weeks
#'
#'see the internal integer representation
unclass(dt1)
dt1 - as.Date("1970-01-01")
#'
#'
#'POSIXct
#'-------
#'
#'If you have times in your data, this is usually the best class to use.
#'
#'create some POSIXct objects:
tm1 <- as.POSIXct("2013-07-24 23:55:26"); tm1
tm2 <- as.POSIXct("25072013 08:32:07", format = "%d%m%Y %H:%M:%S"); tm2
#'specify the time zone:
tm3 <- as.POSIXct("2010-12-01 11:42:03", tz = "GMT"); tm3
#'
#'**some calculations with times**
#'
#'compare times:
tm2 > tm1
#'Add or subtract seconds:
tm1 + 30
tm1 - 30
#'find the difference between times:
tm2 - tm1
#'automatically adjusts for daylight savings time:
as.POSIXct("2013-03-10 08:32:07") - as.POSIXct("2013-03-09 23:55:26")
#'
#'Get the current time (in POSIXct by default):
Sys.time()
#'
#'see the internal integer representation:
unclass(tm1)
difftime(tm1, as.POSIXct("1970-01-01 00:00:00", tz = "UTC"), units = "secs")
#'
#'
#'POSIXlt
#'-------
#'
#'This class enables easy extraction of specific componants of a time.
#'("ct" stand for calender time and "lt" stands for local time.  "lt" also helps
#'one remember that POXIXlt objects are *lists*.)
#'
#'create a time:
tm1.lt <- as.POSIXlt("2013-07-24 23:55:26"); tm1.lt
unclass(tm1.lt)
unlist(tm1.lt)
#'extract componants of a time object:
tm1.lt$sec
tm1.lt$wday
#'truncate or round off the time:
trunc(tm1.lt, "days")
trunc(tm1.lt, "mins")
#'
#'
#'chron
#'-----
#'
#'This class is a good option when you don't need to deal with timezones.
#'It requires the package `chron`.
#'
require(chron)
#'
#'create some times:
tm1.c <- as.chron("2013-07-24 23:55:26"); tm1.c
tm2.c <- as.chron("07/25/13 08:32:07", "%m/%d/%y %H:%M:%S"); tm2.c
#'extract just the date:
dates(tm1.c)
#'compare times:
tm2.c > tm1.c
#'add days:
tm1.c + 10
#'calculate the differene between times:
tm2.c - tm1.c
difftime(tm2.c, tm1.c, units = "hours")
#'does not adjust for daylight savings time:
as.chron("2013-03-10 08:32:07") - as.chron("2013-03-09 23:55:26")
#'
#'Detach the `chron` package as it will interfere with `lubridate` later in
#'this script.
detach("package:chron", unload = TRUE)
#'
#'Summary of date/time classes
#'----------------------------
#'
#' -   When you just have dates, use Date.
#' -   When you have times, POSIXct is usually the best,
#' -   but POSIXlt enables easy extraction of specific components
#' -   and chron is simplest when you don't need to deal with timezones and
#'    daylight savings time.
#'
#' 
#'Manipulating times and dates
#'============================
#'
#' 
#'lubridate
#'---------
#'This package is a wrapper for POSIXct with more intuitive syntax.
require(lubridate)
#'
#'create a time:
tm1.lub <- ymd_hms("2013-07-24 23:55:26"); tm1.lub
tm2.lub <- mdy_hm("07/25/13 08:32"); tm2.lub
tm3.lub <- ydm_hm("2013-25-07 4:00am"); tm3.lub
tm4.lub <- dmy("26072013"); tm4.lub
#'
#'some manipulations:
#'extract or reassign componants:
year(tm1.lub)
week(tm1.lub)
wday(tm1.lub, label = TRUE)
hour(tm1.lub)
tz(tm1.lub)
second(tm2.lub) <- 7; tm2.lub
#'converting to decimal hours can facilitate some types of calculations:
tm1.dechr <- hour(tm1.lub) + minute(tm1.lub)/60 + second(tm1.lub)/3600
tm1.dechr
#'
#'Lubridate distinguishes between four types of objects:
#'  instants, intervals, durations, and periods.
#'An instant is a specific moment in time.
#'Intervals, durations, and periods are all ways of recording time spans.
#'
#'Dates and times parsed in lubridate are instants:
is.instant(tm1.lub)
#'round an instant:
round_date(tm1.lub, "minute")
round_date(tm1.lub, "day")
#'get the current time or date as an instant:
now()
today()
#'Note that lubridate uses UTC time zones as default.
#'
#'see an instant in a different time zone:
with_tz(tm1.lub, "America/Los_Angeles")
#'change the time zone of an instant (keeping the same clock time):
force_tz(tm1.lub, "America/Los_Angeles")
#'some calculations with instants.  Note that the units are seconds:
tm2.lub - tm1.lub
tm2.lub > tm1.lub
tm1.lub + 30
#'
#'An interval is the span of time that occurs between two specified instants.
in.bed <- as.interval(tm1.lub, tm2.lub); in.bed
#'Check whether a certain instant occured with a specified interval:
tm3.lub %within% in.bed
tm4.lub %within% in.bed
#'determine whether two intervals overlap:
daylight <- as.interval(ymd_hm("2013-07-25 06:03"), ymd_hm("2013-07-25 20:23"))
daylight
int_overlaps(in.bed, daylight)
#'
#'A duration is a time span not anchored to specific start and end times.
#'  It has an exact, fixed length, and is stored internally in seconds.
#'
#'create some durations:
ten.minutes <- dminutes(10); ten.minutes
five.days <- ddays(5); five.days
one.year <- dyears(1); one.year
as.duration(in.bed)
#'arithmatic with durations:
tm1.lub - ten.minutes
five.days + dhours(12)
ten.minutes/as.duration(in.bed)
#'
#'A period is a time span not anchored to specific start and end times,
#'  and measured in units larger than seconds with inexact lengths.
#'create some periods:
three.weeks <- weeks(3); three.weeks
four.hours <- hours(4); four.hours
#'arithmatic with periods:
tm4.lub + three.weeks
sabbatical <- months(6) + days(12); sabbatical
three.weeks/sabbatical
#'
#'
#'Calculating mean clock times
#'----------------------------
#'Say we have a vector of clock times in decimal hours,
#'  and we want to calculate the mean clock time.
bed.times <- c(23.9, 0.5, 22.7, 0.1, 23.3, 1.2, 23.6); bed.times
mean(bed.times)  # doesn't work
#'
#'The clock has a circular scale, which ends where it begins,
#'  so we need to use circular statistics.
#'  (For more info on circular statistics see 
#'  <http://en.wikipedia.org/wiki/Mean_of_circular_quantities>.)
#'
#'Get the package, psych.
require(psych)
circadian.mean(bed.times)
#'
#'
#'An example of using times and dates in a data frame
#'---------------------------------------------------
#'
#'Here is a data frame with a week of hypothetical times of going to bed 
#'  and getting up for one person, and the total amount of time sleep time
#'  obtained each night according to a sleep monitoring device.
sleep <- 
    data.frame(
        bed.time = ymd_hms("2013-09-01 23:05:24", "2013-09-02 22:51:09",
                           "2013-09-04 00:09:16", "2013-09-04 23:43:31",
                           "2013-09-06 00:17:41", "2013-09-06 22:42:27",
                           "2013-09-08 00:22:27"),
        rise.time = ymd_hms("2013-09-02 08:03:29", "2013-09-03 07:34:21",
                            "2013-09-04 07:45:06", "2013-09-05 07:07:17",
                            "2013-09-06 08:17:13", "2013-09-07 06:52:11",
                            "2013-09-08 07:15:19"),
        sleep.time = dhours(c(6.74, 7.92, 7.01, 6.23, 6.34, 7.42, 6.45))
    ); sleep
#'We want to calculate sleep efficiency, 
#'  the percent of time in bed spent asleep.
sleep$efficiency <- 
    round(sleep$sleep.time/(sleep$rise.time - sleep$bed.time)*100, 1)
sleep
#'Now let's calculate the mean of each column:
colMeans(sleep)  # doesn't work
circadian.mean(hour(sleep$bed.time) + 
                   minute(sleep$bed.time)/60 + 
                   second(sleep$bed.time)/3600)
circadian.mean(hour(sleep$rise.time) + 
                   minute(sleep$rise.time)/60 + 
                   second(sleep$rise.time)/3600)
mean(sleep$sleep.time)/3600
mean(sleep$efficiency)
#'We can also plot sleep duration and efficiency across the week:
par(mar = c(5, 4, 4, 4))
plot(round_date(sleep$rise.time, "day"), sleep$efficiency, 
     type = "o", col = "blue", xlab = "Morning", ylab = NA)
par(new = TRUE)
plot(round_date(sleep$rise.time, "day"), sleep$sleep.time/3600, 
     type = "o", col = "red", axes = FALSE, ylab = NA, xlab = NA)
axis(side = 4)
mtext(side = 4, line = 2.5, col = "red", "Sleep duration")
mtext(side = 2, line = 2.5, col = "blue", "Sleep efficiency")
#'
#' 
#'More resources on times and dates
#'=================================
#'date and time tutorials for R:
#'
#'- <http://www.stat.berkeley.edu/classes/s133/dates.html>
#'- <http://science.nature.nps.gov/im/datamgmt/statistics/r/fundamentals/dates.cfm>
#'- <http://en.wikibooks.org/wiki/R_Programming/Times_and_Dates>
#'
#'lubridate:
#'
#'- <http://www.jstatsoft.org/v40/i03/paper>
#'
#'time zone and daylight saving time info:
#'
#'- <http://www.timeanddate.com/>
#'- <http://en.wikipedia.org/wiki/List_of_tz_database_time_zones>
#'- <http://www.twinsun.com/tz/tz-link.htm>
#'- Also see the R help file at ?Sys.timezone
#'