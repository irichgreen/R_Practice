suppressMessages({
    library(randomForest)
    library(data.table)
    library(gbm)
    library(ggplot2)
    library(plyr)
    library(dplyr)
    library(rpart)
})

x <- seq(-2,2,by=0.01)
lenx<- length(x)
y <- 2 + 3*x^2 + rnorm(lenx, 0, 0.5)
y_r <- 2 + 3*x^2
x.y <- data.frame(x=x,y=y, y_r=y_r)

x.y.samp <- x.y %>% sample_frac(0.5)
x.y.samp.test <- x.y %>% sample_frac(0.1)

ggplot(x.y.samp, aes(x,y_r)) + geom_line(size=1.5, colour='red') + geom_point(aes(y=y), size=2)

mdl_cart <- rpart(y ~ x,data=x.y.samp)
x.y.samp.test$cart_fit <- predict(mdl_cart,newdata=x.y.samp.test)

ggplot(x.y.samp, aes(x,y_r)) + geom_line(size=1.5, colour='red') + geom_point(aes(y=y), size=1) + geom_line(data =  x.y.samp.test, aes(x=x, y=cart_fit))

mdl_rf <- randomForest(y ~ x,data=x.y.samp)
x.y.samp.test$rf_fit <- predict(mdl_rf,newdata=x.y.samp.test)

ggplot(x.y.samp, aes(x,y_r)) + geom_line(size=1.5, colour='red') + geom_point(aes(y=y), size=1) + geom_line(data =  x.y.samp.test, aes(y=rf_fit))

#regression이나 regression tree가 아닌 neural network등 다양한 모형을 weak learner로 사용 가능하다.

shrink <- 0.1

#regression based boosting
y_n <- x.y.samp$y
x <- x.y.samp$x
v_y_l <- list()
for(i in 1:100){
    lm_fit <- lm(y_n ~ x*I(0 < x))
    v_y <- shrink * predict(lm_fit)
    v_y_l[[i]] <- shrink * predict(lm_fit, newdata=x.y.samp.test)
    resid_n <-  y_n - v_y
    y_n <- resid_n
}

x.y.samp.test$lm_fit <- apply(as.data.table(v_y_l),1,sum)

x.y.samp.test$lm_fit_3 <- apply(as.data.table(v_y_l)[,1:10,with=F],1,sum)

x.y.samp.test$lm_fit_2 <- apply(as.data.table(v_y_l)[,1:5,with=F],1,sum)

x.y.samp.test$lm_fit_1 <- apply(as.data.table(v_y_l)[,1:2,with=F],1,sum)

ggplot(x.y.samp, aes(x=x,y=y_r)) + geom_line(size=1.5, colour='red') + geom_point(aes(y=y), size=1) + geom_line(data=x.y.samp.test, aes(x=x,y=lm_fit), colour='purple', linetype=2, size=1) + geom_line(data=x.y.samp.test, aes(x=x,y=lm_fit_2),colour='purple',linetype=4) + geom_line(data=x.y.samp.test, aes(x=x,y=lm_fit_3),colour='purple',linetype=4) + geom_line(data=x.y.samp.test,aes(x=x,y=lm_fit_1),colour='purple',linetype=4) 

