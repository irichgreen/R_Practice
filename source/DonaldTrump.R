library(twitteR)
library(purrr)
library(dplyr)
library(stringr)

# You'd need to set up authentication before running this
# See help(setup_twitter_oauth)
api_key <- "FmiQhLjrrFoWeZXnKthNYLTdG"
api_secret <- "tHHIZA2ctKH5uoJUm38phZF7d9TveoXm6htFcmkIfJHC50MLhk"
access_token <- "66102774-Q8IRvFvPXQyqEuZbREqUaPB0qydj6LQb7Xogw3G2K"
access_token_secret <- "Bv2PcnMR6NSYJMMOnIOxmncG3PDY2FTt3hjpc0RXCO7tN"
setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)

tweets <- userTimeline("realDonaldTrump", n = 3200)  %>% map_df(as.data.frame)

#tweets <- searchTwitter("#7FavPackages", n = 3200) %>% map_df(as.data.frame)

# Grab only the first for each user (some had followups), and ignore retweets
tweets <- tweets %>%
    filter(!str_detect(text, "^RT ")) %>%
    arrange(created) %>%
    distinct(screenName, .keep_all = TRUE)

library(BiocInstaller)

# to avoid non-package words
built_in <- tolower(sessionInfo()$basePkgs)
cran_pkgs <- tolower(rownames(available.packages()))
bioc_pkgs <- tolower(rownames(available.packages(repos = biocinstallRepos()[1:3])))
blacklist <- c("all")

# install.packages("tidytext")
library(tidytext)

spl_re <- "[^a-zA-Z\\d\\@\\#\\.]"
link_re <- "https://t.co/[A-Za-z\\d]+|&amp;"

packages <- tweets %>%
    mutate(text = str_replace_all(text, link_re, "")) %>%
    unnest_tokens(package, text, token = "regex", pattern = spl_re) %>%
    filter(package %in% c(cran_pkgs, bioc_pkgs, built_in)) %>%
    distinct(id, package) %>%
    filter(!package %in% blacklist)

pkg_counts <- packages %>%
    count(package, sort = TRUE)

packages %>%
    filter(package %in% bioc_pkgs)

set.seed(2016)
pkg_counts %>%
    filter(n == 1, !package %in% bioc_pkgs) %>%
    sample_n(10)

