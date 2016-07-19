library(showtext)

font.add.google("Gochi Hand", "gochi")
font.add.google("Rock Salt", "rock")

link = "http://img.dafont.com/dl/?f=wm_people_1";
download.file(link, "wmpeople1.zip", mode = "wb");
unzip("wmpeople1.zip");
font.add("wmpeople1", "wmpeople1.TTF");

link = "http://img.dafont.com/dl/?f=emoticons";
download.file(link, "emoticons.zip", mode = "wb");
unzip("emoticons.zip");
font.add("emoticons", "emoticons.ttf");


showtext.auto()
set.seed(2015-05-14)

#install.packages("ggtree")
library(ggplot2)
library(ggtree)



tree <- rtree(30)
ggtree(tree, color="darkgreen") + geom_tiplab(family="gochi") + theme_classic() +
    theme(axis.text.x=element_text(size=rel(4), family="emoticons", color="firebrick")) +
    scale_y_continuous(breaks=seq(0, 30, 4), labels=letters[c(12:17, 20, 21)]) +
    theme(axis.text.y=element_text(size=rel(4), family="wmpeople1", color="#FDAC4F")) +
    annotate("text", x=2, y=18, label="Have fun with ggtree!",
             family="rock", angle=30, size=12, color="steelblue")


download.file("http://dl.dafont.com/dl/?f=people_freak", "people_freak.zip", mode="wb")
unzip("people_freak.zip")
font.add("people_freak", "People_freak.ttf")
ggtree(rtree(10)) + geom_text(aes(label=node, color=isTip), family="people_freak", hjust=0)

