library(ggplot2)
library(ggExtra)
frm = read.csv("tips.csv")

plot_center = ggplot(frm, aes(x=total_bill,y=tip)) + 
    geom_point() +
    geom_smooth(method="lm")

# default: type="density"
ggMarginal(plot_center, type="histogram")

# our own (very beta) plot package: details later
# install.packages("WVPlots")
#devtools::install_github("WinVector/WVPlots")

# our own (very beta) plot package: details later
library(WVPlots)
frm = read.csv("tips.csv")

ScatterHist(frm, "total_bill", "tip",
            smoothmethod="lm",
            annot_size=3,
            title="Tips vs. Total Bill")
