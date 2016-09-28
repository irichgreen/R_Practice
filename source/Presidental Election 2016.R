require(XML)
require(dplyr)
require(tidyr)
require(readr)
require(mosaic)
require(RCurl)
require(ggplot2)
require(lubridate)
require(RJSONIO)

url = "http://projects.fivethirtyeight.com/2016-election-forecast/national-polls/"
doc <- htmlParse(url, useInternalNodes = TRUE)

sc = xpathSApply(doc, "//script[contains(., 'race.model')]", 
                 function(x) c(xmlValue(x), xmlAttrs(x)[["href"]]))

jsobj = gsub(".*race.stateData = (.*);race.pathPrefix.*", "\\1", sc)

data = fromJSON(jsobj)
allpolls <- data$polls

#unlisting the whole thing
indx <- sapply(allpolls, length)
pollsdf <- as.data.frame(do.call(rbind, lapply(allpolls, `length<-`, max(indx))))

pollswt <- as.data.frame(t(as.data.frame(do.call(cbind, lapply(pollsdf$weight, data.frame, 
                                                               stringsAsFactors=FALSE)))))
names(pollswt) <- c("wtpolls", "wtplus", "wtnow")
row.names(pollswt) <- NULL

pollsdf <- cbind(pollsdf, pollswt)

#unlisting the voting
indxv <- sapply(pollsdf$votingAnswers, length)
pollsvot <- as.data.frame(do.call(rbind, lapply(pollsdf$votingAnswers,
                                                `length<-`, max(indxv))))
pollsvot1 <- rbind(as.data.frame(do.call(rbind, lapply(pollsvot$V1, data.frame,
                                                       stringsAsFactors=FALSE))))
pollsvot2 <- rbind(as.data.frame(do.call(rbind, lapply(pollsvot$V2, data.frame,
                                                       stringsAsFactors=FALSE))))


pollsvot1 <- cbind(polltype = rownames(pollsvot1), pollsvot1, 
                   polltypeA = gsub('[0-9]+', '', rownames(pollsvot1)),
                   polltype1 = extract_numeric(rownames(pollsvot1)))

pollsvot1$polltype1 <- ifelse(is.na(pollsvot1$polltype1), 1, pollsvot1$polltype1 + 1)


pollsvot2 <- cbind(polltype = rownames(pollsvot2), pollsvot2, 
                   polltypeA = gsub('[0-9]+', '', rownames(pollsvot2)),
                   polltype1 = extract_numeric(rownames(pollsvot2)))

pollsvot2$polltype1 <- ifelse(is.na(pollsvot2$polltype1), 1, pollsvot2$polltype1 + 1)


pollsdf <- pollsdf %>% 
    mutate(population = unlist(population), 
           sampleSize = as.numeric(unlist(sampleSize)), 
           pollster = unlist(pollster), 
           startDate = ymd(unlist(startDate)),
           endDate = ymd(unlist(endDate)), 
           pollsterRating = unlist(pollsterRating)) %>%
    select(population, sampleSize, pollster, startDate, endDate, pollsterRating,
           wtpolls, wtplus, wtnow)



allpolldata <- cbind(rbind(pollsdf[rep(seq_len(nrow(pollsdf)), each=3),],
                           pollsdf[rep(seq_len(nrow(pollsdf)), each=3),]), 
                     rbind(pollsvot1, pollsvot2))

allpolldata <- allpolldata %>%
    arrange(polltype1, choice) 

ggplot(subset(allpolldata, ((polltypeA == "now") & (endDate > ymd("2016-08-01")))), 
       aes(y=adj_pct, x=endDate, color=choice)) + 
    geom_line() + geom_point(aes(size=wtnow)) + 
    labs(title = "Vote percentage by date and poll weight\n", 
         y = "Percent Vote if Election Today", x = "Poll Date", 
         color = "Candidate", size="538 Poll\nWeight")

# code found at http://stats.stackexchange.com/questions/25895/computing-standard-error-in-weighted-mean-estimation

# cited from http://www.cs.tufts.edu/~nr/cs257/archive/donald-gatz/weighted-standard-error.pdf
# Donald F. Gatz and Luther Smith, "THE STANDARD ERROR OF A WEIGHTED MEAN CONCENTRATION-I. BOOTSTRAPPING VS OTHER METHODS"

weighted.var.se <- function(x, w, na.rm=FALSE)
    #  Computes the variance of a weighted mean following Cochran 1977 definition
{
    if (na.rm) { w <- w[i <- !is.na(x)]; x <- x[i] }
    n = length(w)
    xWbar = weighted.mean(x,w,na.rm=na.rm)
    wbar = mean(w)
    out = n/((n-1)*sum(w)^2)*(sum((w*x-wbar*xWbar)^2)-2*xWbar*sum((w-wbar)*(w*x-wbar*xWbar))+xWbar^2*sum((w-wbar)^2))
    return(out)
}

allpolldata2 <- allpolldata %>%
    filter(wtnow > 0) %>%
    filter(polltypeA == "now") %>%
    mutate(dayssince = as.numeric(today() - endDate)) %>%
    mutate(wt = wtnow * sqrt(sampleSize) / dayssince) %>%
    mutate(votewt = wt*pct) %>%
    group_by(choice) %>%
    arrange(choice, -dayssince) %>%
    mutate(cum.mean.wt = cumsum(votewt) / cumsum(wt)) %>%
    mutate(cum.mean = cummean(pct))

ggplot(subset(allpolldata2, ( endDate > ymd("2016-01-01"))), 
       aes(y=cum.mean, x=endDate, color=choice)) + 
    geom_line() + geom_point(aes(size=wt)) + 
    labs(title = "Cumulative Mean Vote Percentage\n", 
         y = "Cumulative Percent Vote if Election Today", x = "Poll Date", 
         color = "Candidate", size="Calculated Weight")

ggplot(subset(allpolldata2, (endDate > ymd("2016-01-01"))), 
       aes(y=cum.mean.wt, x=endDate, color=choice)) + 
    geom_line() + geom_point(aes(size=wt)) + 
    labs(title = "Cumulative Weighted Mean Vote Percentage\n", 
         y = "Cumulative Weighted Percent Vote if Election Today", x = "Poll Date", 
         color = "Candidate", size="Calculated Weight")

pollsummary <- allpolldata2 %>% 
    select(choice, pct, wt, votewt, sampleSize, dayssince) %>%
    group_by(choice) %>%
    summarise(mean.vote = weighted.mean(pct, wt, na.rm=TRUE),
              std.vote = sqrt(weighted.var.se(pct, wt, na.rm=TRUE)))

pollsummary

