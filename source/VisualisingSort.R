insertion_sort_steps <- function(x  = sample(1:15)){
    
    msteps <- matrix(data = x, ncol = length(x))
    
    for (i in 2:length(x)) {
        
        j <- i
        
        while ((j > 1) && (x[j] < x[j - 1])) {
            
            temp <- x[j]
            x[j] <- x[j - 1]
            x[j - 1] <- temp
            j <- j - 1
            
            msteps <- rbind(msteps, as.vector(x))
            
        }
    }
    
    msteps
    
}

set.seed(12345)

x <- sample(seq(4))

x
## [1] 3 4 2 1
msteps <- insertion_sort_steps(x)

as.data.frame(msteps)

sort_matix_to_df <- function(msteps){
    
    df <- as.data.frame(msteps, row.names = NULL)
    
    names(df) <- seq(ncol(msteps))
    
    df_steps <- df %>%
        tbl_df() %>% 
        mutate(step = seq(nrow(.))) %>% 
        gather(position, element, -step) %>%
        arrange(step)
    
    df_steps
    
}

df_steps <- sort_matix_to_df(msteps)

head(df_steps, 10)
