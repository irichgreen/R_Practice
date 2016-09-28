###############
#             #
# Exercise 1  #
#             #
###############
attach(mtcars)
par(col=2,lty=2,bg=4);plot(mpg,wt)
# plot of chunk plot exercises
###############

###############
#             #
# Exercise 2  #
#             #
###############

par(mfrow=c(2,1));plot(mpg,wt);plot(mpg,hp)
# plot of chunk plot exercises
###############
#             #
# Exercise 3  #
#             #
###############

par(mfrow=c(2,2))
plot(mpg,wt,col=2,xlab="Weight",ylab="Miles per Gallon", main="Mpg vs Weight")
plot(mpg,hp,col=3,xlab="Horse Power",ylab="Miles per Gallon", main="Mpg vs Horse Power")
plot(mpg,carb,col=4,xlab="No of Carburators",ylab="Miles per Gallon", main="Mpg vs No of Carb",pch=2)
plot(mpg,drat,col=4,xlab="Rear axle ratio",ylab="Miles per Gallon", main="Mpg vs Rar",pch=2)
legend<-c("Weight","Hp","No of Carb","Rar")
legend("topright",legend,col=c(1:4))
# plot of chunk plot exercises
###############
#             #
# Exercise 4  #
#             #
###############

dev.off()
## null device 
##           1
###############
#             #
# Exercise 5  #
#             #
###############

par(mar=c(4, 4, 4, 4))

###############
#             #
# Exercise 6  #
#             #
###############

windows();plot(mpg,cyl)

###############
#             #
# Exercise 7  #
#             #
###############

ex7<-plot(mpg,cyl);jpeg(filename = "Rplot.jpg",
                        width = 480, height = 480, units = "px", pointsize = 12,
                        quality = 75,
                        bg = "white", res = NA, family = "", restoreConsole = TRUE,
                        type = c("windows", "cairo"), ex7)
# plot of chunk plot exercises
###############
#             #
# Exercise 8  #
#             #
###############

dev.off()
## pdf 
##   2
ex8<-plot(mpg,wt,col=2,xlab="Weight",ylab="Miles per Gallon", main="Mpg vs Weight",xlim=c(0,100),ylim=c(0,100))
points(mpg,hp,col=3)
points(mpg,carb,col=4)
points(mpg,drat,col=4)

jpeg(filename = "Rplot.jpg",
     width = 480, height = 480, units = "px", pointsize = 12,
     quality = 75,
     bg = "white", res = NA, family = "", restoreConsole = TRUE,
     type = c("windows", "cairo"), ex8)
