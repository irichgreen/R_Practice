library(ggplot2)
library(dplyr)
library(stringi)
library(hrbrmisc)
library(scales)
library(ggalt)
library(sitools)

install.packages("hrbrmisc")
install.packages("ggalt")
install.packages("sitools")

# mixed encodings ftw!
Sys.setlocale('LC_ALL','C') 

# different names in different data sets; sigh
org_crosswalk <- read.table(text='company,trans
                            "Adidas AG","Adidas AG"
                            "Allianz SE","Allianz SE"
                            "BASF SE","BASF SE"
                            "Bayer AG","Bayer AG"
                            "Bayerische Motoren Werke AG","BMW AG"
                            "BMW AG","BMW AG",
                            "Beiersdorf AG","Beiersdorf AG"
                            "Commerzbank AG","Commerzbank AG"
                            "Continental AG","Continental AG"
                            "Daimler AG","Daimler AG"
                            "Deutsche Bank AG","Deutsche Bank AG"
                            "Deutsche Boerse AG","Deutsche Boerse AG"
                            "Deutsche Lufthansa AG","Deutsche Lufthansa AG"
                            "Deutsche Post AG","Deutsche Post AG"
                            "Deutsche Telekom AG","Deutsche Telekom AG"
                            "E.ON","E.ON"
                            "Fresenius Medical Care AG & Co. KGaA","Fresenius Medical Care AG"
                            "Fresenius Medical Care AG","Fresenius Medical Care AG"
                            "Fresenius SE & Co KGaA","Fresenius SE & Co KGaA"
                            "HeidelbergCement AG","HeidelbergCement AG"
                            "Henkel AG & Co. KGaA","Henkel AG & Co. KGaA"
                            "Infineon Technologies AG","Infineon Technologies AG"
                            "K+S AG","K+S AG"
                            "Lanxess AG","Lanxess AG"
                            "Linde AG","Linde AG"
                            "Merck KGaA","Merck KGaA"
                            "MŸnchener RŸckversicherungs-Gesellschaft AG","Munich RE AG"
                            "M�nchener R�ckversicherungs-Gesellschaft AG","Munich RE AG"
                            "M\x9fnchener R\x9fckversicherungs-Gesellschaft AG","Munich RE AG"
                            "M?nchener R?ckversicherungs-Gesellschaft AG","Munich RE AG"
                            "Munich RE AG","Munich RE AG"
                            "RWE AG","RWE AG"
                            "SAP SE","SAP SE"
                            "Siemens AG","Siemens AG"
                            "ThyssenKrupp AG","ThyssenKrupp AG"
                            "Volkswagen AG","Volkswagen AG"', stringsAsFactors=FALSE, sep=",", quote='"', header=TRUE)

# quicker/less verbose than left_join()
org_trans <- setNames(org_crosswalk$trans, org_crosswalk$company)

# get and clean both data sets, being kind to the propublica bandwidth $
rec_url <- "https://projects.propublica.org/graphics/javascripts/dividend/record_dates.csv"
rec_fil <- basename(rec_url)
if (!file.exists(rec_fil)) download.file(rec_url, rec_fil)

records <- read.csv(rec_fil, stringsAsFactors=FALSE)
records %>%
    select(company=1, year=2, record_date=3) %>%
    mutate(record_date=as.Date(stri_replace_all_regex(record_date,
                                                      "([[:digit:]]+)/([[:digit:]]+)+/([[:digit:]]+)$",
                                                      "20$3-$1-$2"))) %>%
    mutate(company=ifelse(grepl("Gesellschaft", company), "Munich RE AG", company)) %>% 
    mutate(company=org_trans[company]) -> records

div_url <- "https://projects.propublica.org/graphics/javascripts/dividend/dividend.csv"
div_fil <- basename(div_url)
if (!file.exists(div_fil)) download.file(div_url, div_fil)

dividends <- read.csv(div_fil, stringsAsFactors=FALSE)

dividends %>%
    select(company=1, pricing_date=2, short_int_qty=3) %>%
    mutate(pricing_date=as.Date(stri_replace_all_regex(pricing_date,
                                                       "([[:digit:]]+)/([[:digit:]]+)+/([[:digit:]]+)$",
                                                       "20$3-$1-$2"))) %>%
    mutate(company=ifelse(grepl("Gesellschaft", company), "Munich RE AG", company)) %>% 
    mutate(company=org_trans[company]) -> dividends

# sitools::f2si() doesn't work so well for this for some reason, so mk a small helper function
m_fmt <- function (x) { sprintf("%d M", as.integer(x/1000000)) }

# gotta wrap'em all
subt <- wrap_format(160)("German companies typically pay shareholders one big dividend a year. With the help of U.S. banks, international investors briefly lend their shares to German funds that don’t have to pay a dividend tax. The avoided tax – usually 15 percent of the dividend – is split by the investors and other participants in the deal. These transactions cost the German treasury about $1 billion a year. [Y-axis == short interest quantity]")

gg <- ggplot()

# draw the markers for the dividends
gg <- gg + geom_vline(data=records,
                      aes(xintercept=as.numeric(record_date)),
                      color="#b2182b", size=0.25, linetype="dotted")

# draw the time series
gg <- gg + geom_line(data=dividends,
                     aes(pricing_date, short_int_qty, group=company),
                     size=0.15)

gg <- gg + scale_x_date(expand=c(0,0))
gg <- gg + scale_y_continuous(expand=c(0,0), labels=m_fmt,
                              limits=c(0,800000000))

gg <- gg + facet_wrap(~company, scales="free_x")

gg <- gg + labs(x="Red, dotted line == Dividend date", y=NULL,
                title="Tax Avoidance Has a Heartbeat",
                subtitle=subt,
                caption="Source: https://projects.propublica.org/graphics/dividend")

# devtools::install_github("hrbrmstr/hrbrmisc") or roll your own
gg <- gg + theme_hrbrmstr_an(grid="XY", axis="", strip_text_size=8.5,
                             subtitle_size=10)
gg <- gg + theme(axis.text=element_text(size=6))
gg <- gg + theme(panel.grid.major=element_line(size=0.05))
gg <- gg + theme(panel.background=element_rect(fill="#e2e2e233",
                                               color="#e2e2e233"))
gg <- gg + theme(panel.margin=margin(10,10,20,10))
gg <- gg + theme(plot.margin=margin(20,20,20,20))
gg <- gg + theme(axis.title.x=element_text(color="#b2182bee", size=9, hjust=1))
gg <- gg + theme(plot.caption=element_text(margin=margin(t=5)))
gg