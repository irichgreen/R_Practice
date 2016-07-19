# Script to make a word cloud of your google searches.  Get your google search
# history at http://history.google.com.  This script assumes the JSON files
# exported are in a 'Searches' subfolder

library(jsonlite)
#install.packages("rlist")
library(rlist)
library(magrittr)
#install.packages("stringi")
library(stringi)
library(wordcloud)
library(tm)
#install.packages("SnowballC")
library(SnowballC)

queries = lapply(list.files('Searches', full.names=TRUE), fromJSON, simplifyDataFrame=FALSE) %>%
    do.call("c", .) %>%
    do.call("c", .) %>%
    do.call("c", .) %>%
    list.mapv(.$query) %>%
    tolower

queries = queries[!grepl(pattern = '[-][>]',x = queries)]

queries = queries %>%    
    removePunctuation %>%
    removeWords(stopwords("english")) %>%
    wordStem



# queries = lapply(list.files('Searches', full.names=TRUE), fromJSON, simplifyDataFrame=FALSE) %>%
#     do.call("c", .) %>%
#     do.call("c", .) %>%
#     do.call("c", .) %>%
#     list.mapv(.$query) %>%
#     tolower %>%
#     removePunctuation %>%
#     removeWords(stopwords("english")) %>%
#     wordStem

words = stri_split_regex(queries, "\\s") %>%
    do.call("c", .) %>%
    `[`(., . != "")

word_table = table(words) %>%
    sort(decreasing = TRUE)


pal <- colorRampPalette(c("red","blue"))(10)
wordcloud(names(word_table), word_table, scale=c(3, 1), min.freq=10,colors=pal,random.order=TRUE, max.words=200)
