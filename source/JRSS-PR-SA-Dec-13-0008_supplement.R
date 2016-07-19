 #  Copyright 2015 Cristiano Varin (Ca’ Foscari University), Manuela Cattelan
 #  (University of Padova) and David Firth (University of Warwick).
 #  Permission to use, copy, modify and distribute this software and
 #  its documentation, for any purpose and without fee, is hereby granted,
 #  provided that:
 #  1) this copyright notice appears in all copies and
 #  2) the source is acknowledged through a citation to the paper
 #     Varin C., Cattelan M. and Firth D. (2015). Statistical modelling of citation
 #     exchange between statistics journals. Journal of the Royal Statistical Society
 #     Series A, to appear.
 #  The authors make no representation about the suitability of this software
 #  for any purpose.  It is provided "as is", without express or implied warranty.


## ------------------------------------------------------------------------
## Section 1: Cross-citation data
## ------------------------------------------------------------------------

Cmatrix <- as.matrix(read.csv("Data/cross-citation-matrix.csv",
                              row.names = 1))
journal.abbr <- rownames(Cmatrix)
journal.abbr

## ------------------------------------------------------------------------
## Section 2: Cluster analysis
## ------------------------------------------------------------------------

Tmatrix <- Cmatrix + t(Cmatrix)
diag(Tmatrix) <- diag(Cmatrix)
journals.cluster <- hclust(d = as.dist(1 - cor(Tmatrix)))
plot(journals.cluster, sub = "", xlab = "")


## ------------------------------------------------------------------------
## Section 3: Quasi-Stigler model
## ------------------------------------------------------------------------

require(BradleyTerry2)

Cdata <- countsToBinomial(Cmatrix)

fit <- BTm(outcome = cbind(win1, win2),
           player1 = player1, player2 = player2, data = Cdata)

npairs <- NROW(Cdata)
njournals <- nlevels(Cdata$player1)
phi <- sum(residuals(fit, "pearson")^2) / (npairs - (njournals - 1))
phi

## 3.1 Journal residuals

journal.res <- rep(NA, njournals)
res <- residuals(fit, type = "pearson")
coefs <- c(0, coef(fit)) # 0 is the coefficient of the first journal
for(i in 1:njournals){
    A <- which(Cdata$player1 == journal.abbr[i])
    B <- which(Cdata$player2 == journal.abbr[i])
    y <- c(res[A], -res[B])
    x <- c(-coefs[Cdata$player2[A]], -coefs[Cdata$player1[B]])
    journal.res[i] <- sum(y * x) / sqrt(phi * sum(x ^ 2))
}
names(journal.res) <- journal.abbr

require(car)
qqPlot(journal.res, ylab = "Sorted journal residuals",
       xlab = "Normal quantiles")

plot(journal.res ~ coefs, ylab = "Journal residuals",
     xlab = "Export scores")

## 3.2 Quasi standard errors
#install.packages("qvcalc")

require(qvcalc)
cov.matrix <- matrix(0, nrow = njournals, ncol = njournals)
cov.matrix[-1, -1] <- vcov(fit)
qse <- qvcalc(phi * cov.matrix , estimates = c(0, coef(fit)),
              labels = journal.abbr)

export.scores <- qse$qvframe$estimate
export.scores <- export.scores - mean(export.scores)
names(export.scores) <- journal.abbr

sort.id <- sort(export.scores, decreasing = TRUE, index.return = TRUE)$ix
fit.table <- data.frame(quasi = export.scores[sort.id], qse = qse$qvframe$quasiSE[sort.id])
fit.table

#install.packages("plotrix")
require(plotrix)
segs <- apply(fit.table, 1, function(x) x[1] + c(0, -1.96, 1.96) * x[2])
centipede.plot(segs, left.labels = journal.abbr[sort.id],
               right.labels = round(export.scores[sort.id], 2),
               xlab = "Export Scores")


## ------------------------------------------------------------------------
## Section 4: Ranking lasso
## ------------------------------------------------------------------------

source("R-code/ranking-lasso.R")
## ## time consuming
rlasso <- ranking.lasso(y = fit$model$Y, X = fit$model$X, adaptive = TRUE)

lasso.scores <- cbind(0, rlasso$beta)
colnames(lasso.scores) <- journal.abbr
lasso.scores <- lasso.scores - rowMeans(lasso.scores)

tic <- 2 * rlasso$lik + 2 * phi * rlasso$df
best <- max(which.min(tic))

fit.table <- data.frame(fit.table, lasso = lasso.scores[best, sort.id])
fit.table


plot(x = c(0,rlasso$s,1), y = lasso.scores[, 1],
     ylim = range(lasso.scores), type = "l",
     xlab = "s/max(s)", ylab = "Export Scores")
for(i in 2:njournals)
	lines(x = c(0,rlasso$s,1), y = lasso.scores[,i] )
abline(v = rlasso$s[best], lty = "dashed")
abline(h = 0, lty = "dotted")


## ------------------------------------------------------------------------
## Section 5: Comparison with RAE 2008 results
## ------------------------------------------------------------------------

## 5.1 Scoring the RAE submissions according to journal-ranking measures

RA2 <- read.csv("Data/RAE-UoA22/RA2.csv", as.is = TRUE)
institutions <- read.csv("Data/RAE-UoA22/Institution.csv", as.is = TRUE)

source("R-code/tidy-the-RAE-downloads.R")

journals <- read.csv("Data/RAE22-journals.csv", as.is = TRUE)
row.names(journals) <- journals$RAE.name
RA2.ja$Publisher <- journals[RA2.ja$Publisher, "shortName"]

depts <- read.csv("Data/RAE22-depts.csv")
row.names(depts) <- as.character(depts$depts)
RA2.ja$Institution <- as.character(RA2.ja$Institution)
RA2.ja$Institution <- depts[RA2.ja$Institution, "shortName"]

attach(RA2.ja)
tapply(Publisher, Institution, function(P) {1 - mean(P == "other")})
detach(RA2.ja)

RA2.ja <- RA2.ja[!(RA2.ja$Institution %in%
                   c("Brunel", "Greenwich", "Salford", "Strathclyde")), ]
RA2.ja$Institution <- factor(as.character(RA2.ja$Institution))
attach(RA2.ja)
probstats.fraction.of.articles <- tapply(Publisher, Institution,
    function(P) {1 - mean(P == "other")})
detach(RA2.ja)
##  all of these remaining fractions are now > 0.5
probstats.fraction.of.articles

RA2.ja.statprob <- RA2.ja[RA2.ja$Publisher != "other", ]
nrow(RA2.ja.statprob) / nrow(RA2.ja)

journal.scores <- read.csv("Data/journal-scores.csv")
journal.scores$SM <- exp(journal.scores$SM)
journal.scores$SM.grouped <- exp(journal.scores$SM.grouped)

row.names(journal.scores) <- journal.scores$shortName
RA2.ja.statprob$II <- journal.scores[RA2.ja.statprob$Publisher, "II"]
RA2.ja.statprob$I2 <- journal.scores[RA2.ja.statprob$Publisher, "I2"]
RA2.ja.statprob$I2no <- journal.scores[RA2.ja.statprob$Publisher, "I2no"]
RA2.ja.statprob$I5 <- journal.scores[RA2.ja.statprob$Publisher, "I5"]
RA2.ja.statprob$AI <- journal.scores[RA2.ja.statprob$Publisher, "AI"]
RA2.ja.statprob$SM <- journal.scores[RA2.ja.statprob$Publisher, "SM"]
RA2.ja.statprob$SM.grouped <- journal.scores[RA2.ja.statprob$Publisher,
                                             "SM.grouped"]


## 5.2 Journal-based mean scores for departments

attach(RA2.ja.statprob)
stats.fraction.of.probstats <- tapply(SM, Institution,
                                 function(x) {1 - mean(is.na(x))})
detach(RA2.ja.statprob)
stats.fraction.of.probstats

stats.fraction.of.articles <- probstats.fraction.of.articles *
    stats.fraction.of.probstats
stats.fraction.of.articles

attach(RA2.ja.statprob)
II.mean <- tapply(II, Institution, function(vec) mean(na.omit(vec)))
I2.mean <- tapply(I2, Institution, function(vec) mean(na.omit(vec)))
I2no.mean <- tapply(I2no, Institution, function(vec) mean(na.omit(vec)))
I5.mean <- tapply(I5, Institution, function(vec) mean(na.omit(vec)))
AI.mean <- tapply(AI, Institution, function(vec) mean(na.omit(vec)))
SM.mean <- tapply(SM, Institution, function(vec) mean(na.omit(vec)))
SM.grouped.mean <- tapply(SM.grouped, Institution,
                          function(vec) mean(na.omit(vec)))
detach(RA2.ja.statprob)
means <- data.frame(II.mean, I2.mean, I2no.mean, I5.mean, AI.mean,
                    SM.mean, SM.grouped.mean)

RA2.ja.stat <- RA2.ja.statprob[!is.na(RA2.ja.statprob$SM), ]
attach(RA2.ja.stat)
II.mean.r <- tapply(II, Institution, function(vec) mean(na.omit(vec)))
I2.mean.r <- tapply(I2, Institution, function(vec) mean(na.omit(vec)))
I2no.mean.r <- tapply(I2no, Institution,
                      function(vec) mean(na.omit(vec)))
I5.mean.r <- tapply(I5, Institution, function(vec) mean(na.omit(vec)))
AI.mean.r <- tapply(AI, Institution, function(vec) mean(na.omit(vec)))
SM.mean.r <- tapply(SM, Institution, function(vec) mean(na.omit(vec)))
SM.grouped.mean.r <- tapply(SM.grouped, Institution,
                            function(vec) mean(na.omit(vec)))
detach(RA2.ja.stat)
means.r <- data.frame(II.mean.r, I2.mean.r, I2no.mean.r,
              I5.mean.r, AI.mean.r, SM.mean.r, SM.grouped.mean.r)


## 5.3 Comparison with the published RAE assessments

RAEprofiles <- read.csv("Data/RAE22-outputs-subprofiles.csv")

RAE.4star <- RAEprofiles$X4star
RAE.34star <- RAEprofiles$X4star + RAEprofiles$X3star
RAE.34star.wtd <- RAEprofiles$X4star + RAEprofiles$X3star/3

cor(means, RAE.34star.wtd)

cor(means.r, RAE.34star.wtd)

the.line <- lm(RAE.34star.wtd ~ SM.grouped.mean,
               weights = as.numeric(stats.fraction.of.articles > 0.5))
plot(SM.grouped.mean, RAE.34star.wtd,
     xlab = "Mean of (grouped) Stigler-Model export scores",
     ylab = "RAE score (4* and 3* percentages, weighted 3:1)",
     main = "RAE 2008 results vs Stigler Model mean score")
abline(the.line, lty = "dashed")

plotting.colours <- ifelse(stats.fraction.of.articles > 0.5,
                           "black", "white")
plot(SM.grouped.mean, RAE.34star.wtd,
     xlab = "Mean of (grouped) Stigler-Model export scores",
     ylab = "RAE score (4* and 3* percentages, weighted 3:1)",
     main = "RAE 2008 vs Stigler Model: Restricted to
the 13 most 'Statistical' departments",
     col = plotting.colours)
abline(the.line)
