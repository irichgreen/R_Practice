install.packages("twitteR")
install.packages("RColorBrewer")
install.packages("ROAuth")
library(twitteR) 
library(RColorBrewer)
library(ROAuth)
url_rqst<-"https://api.twitter.com/oauth/request_token"
url_acc<-"https://api.twitter.com/oauth/access_token"
url_auth<-"https://api.twitter.com/oauth/authorize"
API_key<-"pgQe8vyN3VNZXkoKYyuBg"
API_secret<-"iz0zf9x6mrSijhbz5wsNNAGrsboQ3pVOX4NFbEqgNX8"
Acc_token <-"47051754-6wuje0FeeS3xyVWGNJ8Kb3nkr9PA5HHS235gTSB10"
Acc_secret <-"KtkJqhLUr2sEfrWL7sIiuBpAmm76lpM9Q6RqMmY07t0"
#===============
setup_twitter_oauth(consumer_key=API_key, consumer_secret=API_secret, access_token=Acc_token, access_secret=Acc_secret)

sales_tweets<-searchTwitter("buy new car",n=500)
library(plyr)
sales_text<-laply(sales_tweets,function(t)t$getText())
str(sales_text)
head(sales_text,3)
pos.word=scan("positive-words.txt",what="character",comment.char=";")
neg.word=scan("negative-words.txt",what="character",comment.char=";")
pos.words<-c(pos.word,"ripper","speed")
neg.words<-c(neg.word,"small","narrow")
score.sentiment = function(sentences, pos.words, neg.words, .progress='none')
{
    require(plyr)
    require(stringr)
    # we got a vector of sentences. plyr will handle a list
    # or a vector as an "l" for us
    # we want a simple array ("a") of scores back, so we use
    # "l" + "a" + "ply" = "laply":
    scores = laply(sentences, function(sentence, pos.words, neg.words) {
        # clean up sentences with R's regex-driven global substitute, gsub():
        sentence = gsub('[[:punct:]]', '', sentence)
        sentence = gsub('[[:cntrl:]]', '', sentence)
        sentence = gsub('\\d+', '', sentence)
        # and convert to lower case:
        sentence = tolower(sentence) # for english
        # split into words. str_split is in the stringr package
        word.list = str_split(sentence, '\\s+')
        # sometimes a list() is one level of hierarchy too much
        words = unlist(word.list)
        # compare our words to the dictionaries of positive & negative terms
        pos.matches = match(words, pos.words)
        neg.matches = match(words, neg.words)
        # match() returns the position of the matched term or NA
        # we just want a TRUE/FALSE:
        pos.matches = !is.na(pos.matches)
        neg.matches = !is.na(neg.matches)
        # and conveniently enough, TRUE/FALSE will be treated as 1/0 by sum():
        score = sum(pos.matches) - sum(neg.matches)
        return(score)
    }, pos.words, neg.words, .progress=.progress )
    scores.df = data.frame(score=scores, text=sentences)
    return(scores.df)
}
head(sales_text,5)
Encoding(sales_text)[1:10]
sales_text<-sales_text[!Encoding(sales_text)=="UTF-8"]
head(sales_text,4)
sales_text[[10]]
sales_scores=score.sentiment(sales_text,pos.words,neg.words,.progress='text')
hist(sales_scores$score)
df <- do.call("rbind", lapply(sales_tweets, as.data.frame))
removeTwit <- function(x) {gsub("@[[:graph:]]*", "", x)}
df$ptext <- sapply(df$text, removeTwit)
removeURL <- function(x) { gsub("http://[[:graph:]]*", "", x)}
df$ptext <- sapply(df$ptext, removeURL)
*#build, corpus
myCorpus <- Corpus(VectorSource(df$ptext))
tmp1 <- tm_map(myCorpus, stemDocument, lazy = TRUE)
tmp2<-tm_map(tmp1,removePunctuation)
tmp3<-tm_map(tmp2,stripWhitespace)
tmp4 <-tm_map(tmp3,removeNumbers)
tmp5<-tm_map(tmp4, removeWords, stopwords("english"))
tdm <- TermDocumentMatrix(tmp5)
findFreqTerms(tdm, lowfreq=20)
findAssocs(tdm,'car',0.2)
dtm <- DocumentTermMatrix(tmp5)
inspect(dtm[1:10,100:105])