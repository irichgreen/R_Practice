library(OutbreakTools)
data(FluH1N1pdm2009)
attach(FluH1N1pdm2009)


x <- new("obkData", individuals = individuals, dna = FluH1N1pdm2009$dna,
         dna.individualID = samples$individualID, dna.date = samples$date,
         trees = FluH1N1pdm2009$trees)

plotggphy(x, ladderize = TRUE, branch.unit = "year",
          tip.color = "location", tip.size = 3, tip.alpha = 0.75)


library(ggtree)
ggtree(x, mrsd="2009-09-30", as.Date=TRUE) +
    geom_tippoint(aes(color=location), size=3, alpha=.75) +
    scale_color_brewer("location", palette="Spectral") +
    theme_tree2(legend.position='right')
