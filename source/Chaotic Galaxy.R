library(ggplot2)
library(dplyr)
#Generic function
attractor = function(x, y, z)
{
    c(z[1]+z[2]*x+z[3]*x^2+ z[4]*x*y+ z[5]*y+ z[6]*y^2, 
      z[7]+z[8]*x+z[9]*x^2+z[10]*x*y+z[11]*y+z[12]*y^2)
}
#Function to iterate the generic function over the initial point c(0,0)
galaxy= function(iter, z)
{
    df=data.frame(x=0,y=0)
    for (i in 2:iter) df[i,]=attractor(df[i-1, 1], df[i-1, 2], z)
    df %>% rbind(data.frame(x=runif(iter/10, min(df$x), max(df$x)), 
                            y=runif(iter/10, min(df$y), max(df$y))))-> df
    return(df)
}
opt=theme(legend.position="none",
          panel.background = element_rect(fill="#00000c"),
          plot.background = element_rect(fill="#00000c"),
          panel.grid=element_blank(),
          axis.ticks=element_blank(),
          axis.title=element_blank(),
          axis.text=element_blank(),
          plot.margin=unit(c(-0.1,-0.1,-0.1,-0.1), "cm"))
#First galaxy
z1=c(1.0, -0.1, -0.2,  1.0,  0.3,  0.6,  0.0,  0.2, -0.6, -0.4, -0.6,  0.6)
galaxy1=galaxy(iter=2400, z=z1) %>% ggplot(aes(x,y))+
    geom_point(shape= 8, size=jitter(12, factor=4), color="#ffff99", alpha=jitter(.05, factor=2))+
    geom_point(shape=16, size= jitter(4, factor=2), color="#ffff99", alpha=jitter(.05, factor=2))+
    geom_point(shape=46, size= 0, color="#ffff00")+opt

galaxy1

#Second galaxy
z2=c(-1.1, -1.0,  0.4, -1.2, -0.7,  0.0, -0.7,  0.9,  0.3,  1.1, -0.2,  0.4)
galaxy2=galaxy(iter=2400, z=z2) %>% ggplot(aes(x,y))+
    geom_point(shape= 8, size=jitter(12, factor=4), color="#ffff99", alpha=jitter(.05, factor=2))+
    geom_point(shape=16, size= jitter(4, factor=2), color="#ffff99", alpha=jitter(.05, factor=2))+
    geom_point(shape=46, size= 0, color="#ffff00")+opt

galaxy2

#Third galaxy
z3=c(-0.3,  0.7,  0.7,  0.6,  0.0, -1.1,  0.2, -0.6, -0.1, -0.1,  0.4, -0.7)
galaxy3=galaxy(iter=2400, z=z3) %>% ggplot(aes(x,y))+
    geom_point(shape= 8, size=jitter(12, factor=4), color="#ffff99", alpha=jitter(.05, factor=2))+
    geom_point(shape=16, size= jitter(4, factor=2), color="#ffff99", alpha=jitter(.05, factor=2))+
    geom_point(shape=46, size= 0, color="#ffff00")+opt

galaxy3

#Fourth galaxy
z4=c(-1.2, -0.6, -0.5,  0.1, -0.7,  0.2, -0.9,  0.9,  0.1, -0.3, -0.9,  0.3)
galaxy4=galaxy(iter=2400, z=z4) %>% ggplot(aes(x,y))+
    geom_point(shape= 8, size=jitter(12, factor=4), color="#ffff99", alpha=jitter(.05, factor=2))+
    geom_point(shape=16, size= jitter(4, factor=2), color="#ffff99", alpha=jitter(.05, factor=2))+
    geom_point(shape=46, size= 0, color="#ffff00")+opt

galaxy4
