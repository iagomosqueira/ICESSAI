# intro_FLR - «Short one line description»
# intro_FLR

# Copyright 2010 Iago Mosqueira, Cefas. Distributed under the GPL 2 or later
# $Id:  $

# First we install the FLCore package
#install.packages("FLCore",repos="http://flr-project.org/R")

# and load it
library(FLCore)

# Let's load some data
caa <- read.table('caa_herring.dat', sep='\t', header=TRUE)

# and create an 'FLQuant' with it
catch.n <- FLQuant(t(as.matrix(caa[,-1])), dimnames=list(age=1:6, year=caa$year),
    units="t")

# An FLQuant is a 6-dimensional array
is(catch.n)
dim(catch.n)
dimnames(catch.n)

# with some attributes
attributes(catch.n)

# like dimnames
dimnames(catch.n)

# dimensions
dim(catch.n)

# units
units(catch.n)

# and a name for the first dimension, 'quant'
quant(catch.n)

# The creator method accepts 'smaller' classes,
# like vector
FLQuant(1:10)

# matrix
FLQuant(matrix(rlnorm(20), ncol=4, nrow=5))

# and array
FLQuant(array(rlnorm(160), dim=c(4,5,2,4)))

# The various attributes can also be set when building objects
# quant
FLQuant(1:10, quant='age')

# units
FLQuant(1:10, quant='age', units='t')

# dimnames
FLQuant(rlnorm(30), units='t', dimnames=list(age=1:3, year=2000:2009))

# or dim
FLQuant(rlnorm(50), dim=c(5,10))

# The sixth dimension, 'iter', is also treated differently
FLQuant(matrix(rlnorm(200), ncol=4, nrow=5), iter=10)
FLQuant(rlnorm(200), dim=c(4,5), iter=10)

flq <- FLQuant(rlnorm(2000), dimnames=list(age=0:9, year=1990:2009, iter=1:10),
  units='kg')

# A summary method is available
summary(catch.n)

# each class has a basic plot for simple inspection
plot(catch.n)

# but the useful thing to do is to build your own plots, lattice style,
# using a formula of type y ~ x | panels

# all data by year
xyplot(data ~ year, catch.n)
# separate panels by age
xyplot(data ~ year | age, catch.n)
# a trick to get numbers in panel strips
xyplot(data ~ year | as.factor(age), catch.n)

# Methods exist for various tasks

# selection
catch.n[1,]
catch.n[1,1:10]
catch.n[1,'1988']

# accessing and selecting quant and units
quant(catch.n)
units(catch.n)
units(catch.n) <- 'tonnes'

# apply, very useful to master
apply(catch.n, c(1,3:6), sum)
apply(catch.n, c(2:6), sum)

# sweep
caamean <- apply(catch.n, 2, mean)
sweep(catch.n, 2, caamean, "/")

# and arithmetic
catch.n * 2
catch.n + catch.n


# FLQuant is simply the building block for complex objects
# that model elements of the real fishery system

# Let's load an existing object of class FLSR
data(nsher)

summary(nsher)

plot(nsher)

# A model can be selected from some available
nsher.bh <- nsher
model(nsher.bh) <- bevholt

# and then fitted
nsher.bh <- fmle(nsher.bh)

# and inspected
summary(nsher.bh)

# the AIC can be calculated
AIC(nsher.bh)

# and compared with the Ricker fit. The preferred model is the one
# with the lowest AIC value
AIC(nsher)

# Recruitments can now be predicted but new values of SSB
predict(nsher.bh, ssb=FLQuant(66))


# loading example FLStock object, NS plaice
data(ple4)

# inspection
summary(ple4)

plot(ple4)

dims(ple4)

# range holds dimensions info, also plusgroup and fbar range
range(ple4)

# accessors defined for every slot
catch(ple4)
catch.n(ple4)[,'1990']

# many FLQuant methods also available at this level
summary(propagate(ple4, 10))

summary(ple4[,'1990'])

summary(trim(ple4, year=1990:1999))

summary(expand(ple4, year=1957:2057))

# and a number of methods for usual computations

# rec = stock.n[rec.age=first.age,]
rec(ple4)

# SSB = stock.n * exp(-F * F.spwn - M * M.spwn) * stock.wt * mat
ssb(ple4)

# Fbar = mean(F between fbar ages)
fbar(ple4)

# fapex = max F per year
fapex(ple4)

# ssbpurec = SSB per unit recruit
ssbpurec(ple4)

# r = stock reproductive potential
r(ple4)

# survprob = survival probabilities by year or cohort
survprob(ple4)
survprob(ple4, by ='cohort')

# sp = surplus production (delta stock + catch)
sp(ple4)

# lattice plots work on FLStock objects, use 'slot' keyword
xyplot(data ~ year | slot, ple4)

# probably more useful to extract individual slots into an 'FLQuants' list, use 'qname'
xyplot(data ~ year | qname, FLQuants(rec=stock.n(ple4)[1,], ssb=ssb(ple4), 
  catch=catch(ple4)), type='b', pch=19, scales=list(relation='free'))

# Coercion methods allow transfornmation
as.FLSR(ple4)

# Finally, we can see the level of encapsulation obtained by running an XSA with
#install.packages(c("FLAssess","FLXSA"),repos="http://flr-project.org/R")
library(FLXSA)

# we need an FLStock (catch data)
data(ple4)

# and one or more indices of abundance
data(ple4.indices)

# we can now run XSA
ple4xsa <- FLXSA(ple4, ple4.indices)

#diagnostics(ple4xsa)

# the stock object is now updated with the new results (stock.n, harvest)
ple4 <- ple4 + ple4xsa

plot(ple4)
