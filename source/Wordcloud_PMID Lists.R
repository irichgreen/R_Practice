library(devtools)
source_url("https://gist.githubusercontent.com/aurora-mareviv/697cbb505189591648224ed640e70fb1/raw/b42ac2e361ede770e118f217494d70c332a64ef8/pmid.tagcloud.R")


#########################################################
#### CAPTURE ABSTRACTS FROM PMIDs & MAKE A WORDCLOUD ####
#########################################################

# GNU-GPL license
# Author: Mareviv (https://talesofr.wordpress.com)

# Script to retrieve and mine abstracts from PubMed (http://www.ncbi.nlm.nih.gov/pubmed)
# Uses the function ReadPubMed from the package RefManageR. It reads the PubMed API similarly to the search engine in PubMed's page.

# First, automagically install needed libraries:
list.of.packages <- c("RCurl", "RefManageR", "plyr", "tm", "wordcloud", "SnowballC")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, repos='https://cran.rstudio.com/')

# Get and store the working directory
wdir <- getwd()


# 1. Import PMIDs
message("retrieving PMIDs info...")
library(RCurl)
urli <- getURL("https://gist.githubusercontent.com/aurora-mareviv/14e5837814a8d8d47c20/raw/90b198bae82154688dcd9a2596af798612e6619f/pmids.csv", ssl.verifypeer = FALSE)
pmids <- read.csv(textConnection(urli))
message("PMID info succesfully retrieved")


# 2. Loop several queries to PubMed and return in a data.frame
index <- pmids$pmId[1:length(pmids$pmId)]  
# The PubMed (free) API may give problems with large queries, so we'll prefer a shorter vector for this test: 
index50 <- pmids$pmId[1:50]

library(RefManageR)
library(plyr)
message("connecting to the free PubMed API...")
auth.pm <- ldply(index50, function(x){
    tmp <- unlist(ReadPubMed(x, database = "PubMed", mindate = 1950))
    tmp <- lapply(tmp, function(z) if(is(z, "person")) paste0(z, collapse = ",") else z)
    data.frame(tmp, stringsAsFactors = FALSE)
})
message("abstract data successfully downloaded!")


# 3. Create a directory to write the abstracts.txt file into: (this folder can only contain this .txt file!)       
corpus.dir <- paste(wdir, "corpus1", sep="/")
message(paste("creating new directory: ", corpus.dir, sep=""))
dir.create(corpus.dir)
setwd(corpus.dir)


# 4. Extract abstracts to a .txt
text <- paste(auth.pm$abstract)
message(paste("writing file: ", plot.dir, "/abstracts.txt", sep=""))
writeLines(text, "abstracts.txt")


# 5. Create tagcloud
library(tm)
library(wordcloud)
library(SnowballC)

message("constructing the tagcloud...")
abstract <- Corpus (DirSource(wdir2)) # import text file in this directory
abstract <- tm_map(abstract, stripWhitespace) # transformations
abstract <- tm_map(abstract, content_transformer(tolower))
abstract <- tm_map(abstract, removeWords, stopwords("english"))
# abstract <- tm_map(abstract, stemDocument) # optional in this case
abstract <- tm_map(abstract, removeNumbers) # optional in this case
abstract <- tm_map(abstract, removePunctuation)
# tuning
abstract <- tm_map(abstract, removeWords, "methods")
abstract <- tm_map(abstract, removeWords, "results")
abstract <- tm_map(abstract, removeWords, "conclusions")
abstract <- tm_map(abstract, removeWords, "conclusion")
abstract <- tm_map(abstract, removeWords, "whether")
abstract <- tm_map(abstract, removeWords, "due")


# 6. Print image in a new folder: wordcloud
plot.dir <- paste(wdir, "wordcloud", sep="/")
message(paste("creating new directory: ", plot.dir, sep=""))
dir.create(plot.dir)
setwd(plot.dir)
message(paste("printing file: ", plot.dir, "/wordcloud.png", sep=""))
png(file = "wordcloud.png", width = 400, height = 400, units = "px", bg = "transparent")
wordcloud(abstract, scale=c(5,0.5), max.words=150, random.order=FALSE, rot.per=0.35, use.r.layout=FALSE, colors=brewer.pal(8, "Dark2"))
dev.off()