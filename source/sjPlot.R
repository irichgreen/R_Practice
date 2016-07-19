# Beautiful table-outputs: Summarizing mixed effects models #rstats
#install.packages("sjPlot")

# load required packages
library(sjPlot) # table functions 
library(sjmisc) # sample data 
library(lme4) # fitting models


# load sample data
data(efc)
# prepare grouping variables
efc$grp = as.factor(efc$e15relat)
levels(x = efc$grp) <- get_val_labels(efc$e15relat)
efc$care.level <- as.factor(rec(efc$n4pstu, "0=0;1=1;2=2;3:4=4"))
levels(x = efc$care.level) <- c("none", "I", "II", "III")

# data frame for fitted model
mydf <- data.frame(neg_c_7 = as.numeric(efc$neg_c_7),
                   sex = as.factor(efc$c161sex),
                   c12hour = as.numeric(efc$c12hour),
                   barthel = as.numeric(efc$barthtot),
                   education = as.factor(efc$c172code),
                   grp = efc$grp,
                   carelevel = efc$care.level)

# fit sample models
fit1 <- lmer(neg_c_7 ~ sex + c12hour + barthel + (1|grp), data = mydf)
fit2 <- lmer(neg_c_7 ~ sex + c12hour + education + barthel + (1|grp), data = mydf)
fit3 <- lmer(neg_c_7 ~ sex + c12hour + education + barthel +
                 (1|grp) +
                 (1|carelevel), data = mydf)

sjt.lmer(fit1, fit2)
sjt.lmer(fit1,
         fit2,
         labelDependentVariables = c("Negative Impact",
                                     "Negative Impact"))

sjt.lmer(fit1,
         fit2,
         showHeaderStrings = TRUE,
         stringB = "Estimate",
         stringCI = "Conf. Int.",
         stringP = "p-value",
         stringDependentVariables = "Response",
         stringPredictors = "Coefficients",
         stringIntercept = "Konstante",
         labelDependentVariables = c("Negative Impact",
                                     "Negative Impact"))


sjt.lmer(fit1, fit2,
         separateConfColumn = FALSE, # ci in same cell as estimates
         showStdBeta = TRUE,         # also show standardized beta values
         pvaluesAsNumbers = FALSE)   # "*" instead of numeric values


sjt.lmer(fit1, fit2,
         labelPredictors = c("Carer's Sex",
                             "Hours of Care",
                             "Elder's Dependency",
                             "Mid Educational Level",
                             "High Educational Level"))

sjt.lmer(fit1, fit2, fit3)

sjt.lmer(fit1, fit2, fit3, 
         CSS = list(css.separatorcol = 'padding-right:1.5em; padding-left:1.5em;'))

sjt.lmer(fit1, fit2, fit3)
sjt.lmer(fit1, fit2, fit3,
         remove.estimates = 2)

sjt.lmer(fit1, fit2, fit3,
         remove.estimates = c("c12hour", "sex2"))
