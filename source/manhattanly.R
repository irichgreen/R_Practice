install.packages("manhattanly")
library(manhattanly)
manhattanly(HapMap, 
            snp = "SNP", gene = "GENE", 
            annotation1 = "ZSCORE", annotation2 = "EFFECTSIZE", 
            highlight = significantSNP)

qqly(HapMap, snp = "SNP", gene = "GENE")

manhattanly(HapMap, snp = "SNP", gene = "GENE", highlight = significantSNP)

p <- manhattanly(HapMap, snp = "SNP", gene = "GENE",
                 annotation1 = "DISTANCE", annotation2 = "EFFECTSIZE",
                 highlight = significantSNP)

# get the x and y coordinates from the pre-processed data
plotData <- manhattanr(HapMap, snp = "SNP", gene = "GENE")[["data"]]

# annotate the smallest p-value
annotate <- plotData[which.min(plotData$P),]

# x and y coordinates of SNP with smallest p-value
xc <- annotate$pos
yc <- annotate$logp

library(plotly)
p %>% plotly::layout(annotations = list(
    list(x = xc, y = yc,
         text = paste0(annotate$SNP,"<br>","GENE: ",annotate$GENE),
         font = list(family = "serif", size = 10))))

plotly_POST(p, filename = "r-docs/manhattan", world_readable=TRUE)
