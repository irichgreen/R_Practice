install.packages("FFTrees")
library("FFTrees")

breastcancer.fft <- fft(formula = diagnosis ~.,
                        data = breastcancer)
breastcancer.fft

plot(breastcancer.fft, 
     main = "Breastcancer FFT", 
     decision.names = c("Healthy", "Cancer"))

plot(breastcancer.fft, 
     main = "Breastcancer FFT", 
     decision.names = c("Healthy", "Cancer"),
     tree = 5)

# Create a 50% training and 50% testing dataset with train.p = .5
breastcancer.test.fft <- fft(formula = diagnosis ~ ,
                             data = breastcancer,
                             train.p = .5)

# Only use 3 cues in the trees
breastcancer.r.fft <- fft(formula = diagnosis ~ thickness + mitoses + adhesion,
                          data = breastcancer)

