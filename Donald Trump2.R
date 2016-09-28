library(dplyr)
library(purrr)
library(twitteR)
# You'd need to set global options with an authenticated app
api_key <- "FmiQhLjrrFoWeZXnKthNYLTdG"
api_secret <- "tHHIZA2ctKH5uoJUm38phZF7d9TveoXm6htFcmkIfJHC50MLhk"
access_token <- "66102774-Q8IRvFvPXQyqEuZbREqUaPB0qydj6LQb7Xogw3G2K"
access_token_secret <- "Bv2PcnMR6NSYJMMOnIOxmncG3PDY2FTt3hjpc0RXCO7tN"
setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)

# We can request only 3200 tweets at a time; it will return fewer
# depending on the API
trump_tweets <- userTimeline("realDonaldTrump", n = 3200)
trump_tweets_df <- tbl_df(map_df(trump_tweets, as.data.frame))
# if you want to follow along without setting up Twitter authentication,
# just use my dataset:
load(url("http://varianceexplained.org/files/trump_tweets_df.rda"))

library(tidyr)

tweets <- trump_tweets_df %>%
    select(id, statusSource, text, created) %>%
    extract(statusSource, "source", "Twitter for (.*?)<") %>%
    filter(source %in% c("iPhone", "Android"))


library(lubridate)
library(scales)
library(ggplot2)
library(stringr)

tweets %>%
    count(source, hour = hour(with_tz(created, "EST"))) %>%
    mutate(percent = n / sum(n)) %>%
    ggplot(aes(hour, percent, color = source)) +
    geom_line() +
    scale_y_continuous(labels = percent_format()) +
    labs(x = "Hour of day (EST)",
         y = "% of tweets",
         color = "")

tweet_picture_counts <- tweets %>%
    filter(!str_detect(text, '^"')) %>%
    count(source,
          picture = ifelse(str_detect(text, "t.co"),
                           "Picture/link", "No picture/link"))

ggplot(tweet_picture_counts, aes(source, n, fill = picture)) +
    geom_bar(stat = "identity", position = "dodge") +
    labs(x = "", y = "Number of tweets", fill = "")

library(tidytext)

reg <- "([^A-Za-z\\d#@']|'(?![A-Za-z\\d#@]))"
tweet_words <- tweets %>%
    filter(!str_detect(text, '^"')) %>%
    mutate(text = str_replace_all(text, "https://t.co/[A-Za-z\\d]+|&amp;", "")) %>%
    unnest_tokens(word, text, token = "regex", pattern = reg) %>%
    filter(!word %in% stop_words$word,
           str_detect(word, "[a-z]"))

tweet_words


android_iphone_ratios <- tweet_words %>%
    count(word, source) %>%
    filter(sum(n) >= 5) %>%
    spread(source, n, fill = 0) %>%
    ungroup() %>%
    mutate_each(funs((. + 1) / sum(. + 1)), -word) %>%
    mutate(logratio = log2(Android / iPhone)) %>%
    arrange(desc(logratio))

nrc <- sentiments %>%
    filter(lexicon == "nrc") %>%
    dplyr::select(word, sentiment)

nrc

sources <- tweet_words %>%
    group_by(source) %>%
    mutate(total_words = n()) %>%
    ungroup() %>%
    distinct(id, source, total_words)

by_source_sentiment <- tweet_words %>%
    inner_join(nrc, by = "word") %>%
    count(sentiment, id) %>%
    ungroup() %>%
    complete(sentiment, id, fill = list(n = 0)) %>%
    inner_join(sources) %>%
    group_by(source, sentiment, total_words) %>%
    summarize(words = sum(n)) %>%
    ungroup()

head(by_source_sentiment)

library(broom)

sentiment_differences <- by_source_sentiment %>%
    group_by(sentiment) %>%
    do(tidy(poisson.test(.$words, .$total_words)))

sentiment_differences

