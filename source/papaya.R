library(papayar)
formalArgs(papaya)


library(oro.nifti)
x = nifti(img = array(rnorm(100^3), dim= rep(100, 3)), dim=rep(100, 3), datatype=16)
y = nifti(img = array(rbinom(100^3, prob = 0.5, size = 10), dim= rep(100, 3)), dim=rep(100, 3), datatype=16)
index.file = papaya(list(x, y))
