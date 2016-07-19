if (!require(devtools))
    install.packages("devtools")
source_gist("gist.github.com/skranz/fad6062e5462c9d0efe4")
install.rtutor(update.github=TRUE)

install_github("MariusBreitmayer/RTutorAttributeTradeOffs")


library(RTutorAttributeTradeOffs)

# Adapt your working directory to an existing folder
setwd("C:/insertdirectoryHERE")
# Adapt your user name
run.ps(user.name="Jon Doe", package="RTutorAttributeTradeOffs",
       load.sav=TRUE, sample.solution=FALSE)
