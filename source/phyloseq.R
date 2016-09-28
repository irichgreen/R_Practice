# install package
#source('http://bioconductor.org/biocLite.R')
#biocLite('phyloseq')

library(phyloseq)

data(GlobalPatterns)
GP <- prune_taxa(taxa_sums(GlobalPatterns) > 0, GlobalPatterns)
GP.chl <- subset_taxa(GP, Phylum=="Chlamydiae")

plot_tree(GP.chl, color="SampleType", shape="Family", label.tips="Genus", size="Abundance") + ggtitle("tree annotation using phyloseq")

library(scales)
library(ggtree)
p <- ggtree(GP.chl, ladderize = FALSE) + geom_text2(aes(subset=!isTip, label=label), hjust=-.2, size=4) +
    geom_tiplab(aes(label=Genus), hjust=-.3) +
    geom_point(aes(x=x+hjust, color=SampleType, shape=Family, size=Abundance),na.rm=TRUE) +
    scale_size_continuous(trans=log_trans(5)) +
    theme(legend.position="right") + ggtitle("reproduce phyloseq by ggtree")
print(p)

df <- fortify(GP.chl)
barcode <- as.character(df$Barcode_full_length)
names(barcode) <- df$label
barcode <- barcode[!is.na(barcode)]
msaplot(p, Biostrings::BStringSet(barcode), width=.3, offset=.05)

      