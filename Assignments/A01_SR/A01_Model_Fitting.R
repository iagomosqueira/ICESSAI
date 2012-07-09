# Model Fitting
# Searching for parameters in R

# Copyright 2011-12 Iago Mosqueira & Ernesto Jardim, EC JRC

# This script shows the steps followed to fit an stock-recruitment model to
# the River Fraser chinook salmon dataset, available in file 'fraser.dat'

#==============================================================================
# Load and explore data
#==============================================================================

# load data from tab-separated file to data.frame
fraser <- read.table(file='fraser.dat', sep='\t', header=T)

# and attach it to the workspace so each collumn can be accessed by name
attach(fraser)

# try 
ls(pos=2)

# initial plot of spawners vs. recruits
plot(spawn, rec, xlab='spawners (thousands)', ylab='recruits (thousands)', pch=19)

###############################################################################
# We are now going to demonstrate the same techniques employed in the spreadsheet
# tutorial for estimating SR models
###############################################################################

#==============================================================================
# Mean recruitment: one parameter model
#==============================================================================

#------------------------------------------------------------------------------
# (1) analytical solution (constant recruitment)
#------------------------------------------------------------------------------

mean(rec)

sum(rec)/length(rec)

#------------------------------------------------------------------------------
# (2) grid solution (constant recruitment)
# create a grid of possible values for the estimated parameter and compute the SS
# for each of them
#------------------------------------------------------------------------------

# create vector of possible values for mean
mu <- seq(500, 1000, by=50)

# and set up a grid for residuals
grid <- matrix(nrow=length(year), ncol=length(mu), dimnames=list(year=year, mu=mu))

# populate the grid
for(i in 1:length(mu))
  grid[,i] <- rec - mu[i]

# calculate SS as square of residuals, summed by column
ss <- colSums(grid ^ 2)

# plot SS profile
plot(mu, ss, type='l', lwd=2, col='red')
  abline(min(ss), 0, lty=2)

# plot residuals of best fit
barplot(grid[,names(ss)[ss==min(ss)]], names.arg=year, ylab='squared residuals')
  abline(0, 0, lty=2)

# plot residual patterns in time
plot(year, grid[,names(ss)[ss==min(ss)]], pch=19)
  abline(0, 0, lty=2)

b <- names(ss)[ss == min(ss)]

#------------------------------------------------------------------------------
# (3) Linear least squares. One parameter model
# We can get the analytical solution in this case
#------------------------------------------------------------------------------

b  <-  sum(spawn * rec)/sum(spawn^2)

#------------------------------------------------------------------------------
# (4) modeling approach: grid search
#------------------------------------------------------------------------------

# possible values for b
bhats <- seq(1, 3, by=0.25)

grid <- matrix(nrow=length(year), ncol=length(bhats), dimnames=list(year=year, bhat=bhats))

# populate grid by using bhat values
for(i in 1:length(bhats))
  grid[,i] <- rec - bhats[i] * spawn

# sum of squares
ss <- colSums(grid ^ 2)

plot(bhats, ss, type='l', lwd=2, col='red')
  abline(min(ss), 0, lty=2)

b2 <- bhats[ss==min(ss)]

#------------------------------------------------------------------------------
# (4) modeling approach: fitting by minimizing a function
#------------------------------------------------------------------------------

# function to minimize, returns SS for a given value of bhat
foo <- function(bhat)
  sum((rec - bhat * spawn)^2)

# optimization function in R, returns minimum (best value of bhat) and
# objective (SS at that value)
res <- optimize(foo, c(1, 3))

bhat <- res$minimum
ss <- res$objective
ssreg <- ss
sstot <- sum((rec - mean(rec)) ^2)
R2 <- 1-(ssreg/sstot)

# NOTE: Shouldn't this really be sserr?
# sstot = sum((y - mean(y)) ^ 2)
# ssreg = sum((yhat - mean(yhat)) ^ 2)
# sserr = sum((y - yhat) ^ 2)

plot(spawn, rec, xlab='spawners (thousands)', ylab='recruits (thousands)', pch=19,
  ylim=c(0, 2000))
abline(0, bhat)
text(220, 1750, paste('y =', formatC(bhat, digits=5), 'x'))
text(220, 1600, as.expression(substitute(R^2 == r, list(r=round(R2,3))))) 

# residual analysis
resid <- rec - bhat * spawn

# residuals by year
barplot(resid, names.arg=year, ylab='squared residuals', col='blue')
  abline(0, 0, lty=2)

# residuals by spawners
plot(spawn, resid, xlab='spawners (thousands)', ylab='recruits (thousands)', pch=19)
  abline(0, 0)

#==============================================================================
# Linear two parameter recruitment model
# R = a + b*S
#==============================================================================

#------------------------------------------------------------------------------
# modeling approach: grid search
#------------------------------------------------------------------------------

# possible values for b
ahat <- seq(-100, 100, by=10)
bhats <- seq(1.25, 3.25, by=0.25)

grid <- array(dim=c(length(year), length(ahat), length(bhats)), dimnames=list(year=year,
  ahat=ahat, bhat=bhats))

# populate grid by using bhat values
for(i in 1:length(ahat))
  for(j in 1:length(bhats))
    grid[,i,j] <- rec - (ahat[i] + bhats[j] * spawn)

# sum of squares, now a matrix for a and b
ss <- colSums(grid ^ 2)

# some plots
filled.contour(ahat, bhats, ss, col=rainbow(20))
contour(ahat, bhats, ss/10000)

image(ahat, bhats, -ss)

persp(ahat, bhats, ss, theta=40, phi=20, col=rainbow(round(ss/max(ss)*20)))

# getting results: the actual min value for SS
ss[which.min(ss)]

# and the parameter estimates
a <- as.numeric(names(which.min(apply(ss, 1, function(x) min(x)))))
b <- as.numeric(names(which.min(apply(ss, 2, function(x) min(x)))))

#------------------------------------------------------------------------------
# modeling approach: fitting by minimizing a function
#------------------------------------------------------------------------------

# function to minimize, returns SS for a given value of params
foo <- function(params)
  sum((rec - (params[1] + params[2] * spawn))^2)

# optimization function in R, returns minimum (best value of bhat) and
# objective (SS at that value)
res <- optim(c(0, 0), foo, method='L-BFGS-B')

plot(spawn, rec, xlab='spawners (thousands)', ylab='recruits (thousands)', pch=19,
  ylim=c(0, 2000))
abline(res$par[1], res$par[2])

text(300, 1750, paste('y =', formatC(res$par[1], digits=5), "+", formatC(res$par[2], digits=5), 'x'))

# residual analysis
resid <- rec - (res$par[1] + res$par[2] * spawn)

# residuals by year
barplot(resid, names.arg=year, ylab='squared residuals', col='blue')
  abline(0, 0, lty=2)

# residuals by spawners
plot(spawn, resid, xlab='spawners (thousands)', ylab='recruits (thousands)', pch=19)
  abline(0, 0)

#------------------------------------------------------------------------------
# modeling approach: fitting with lm
# As usual "there are several ways to skin a cat"
#------------------------------------------------------------------------------

# use function "lm" to adjust the linear model
SRmodLin2 <- lm(rec~spawn)

# and now plots 
par(mfrow=c(2,2))
plot(SRmodLin2)

# tests
anova(SRmodLin2, test="F")

#==============================================================================
# Linearized model (Ricker)
# R = S*exp(a - b*S)
# log(R/S) = a-b*S
#==============================================================================

# transform data
fraser <- transform(fraser, lnRS=log(rec/spawn))

# use lm
SRLinRicker <- lm(lnRS~spawn, data=fraser)
summary(SRLinRicker)

# and now plots 
par(mfrow=c(2,2))
plot(SRLinRicker)

# tests
anova(SRLinRicker, test="F")

# plot
par(mfrow=c(1,1))
plot(lnRS~spawn, data=fraser)
abline(SRLinRicker$coefficients)

# another way to "skin the cat"
SRLinRicker <- lm(log(rec/spawn)~spawn, data=fraser)
summary(SRLinRicker)

#==============================================================================
# Non-linear estimation: Beverton & Holt SR model
# R = a*S / b+S
#==============================================================================
#------------------------------------------------------------------------------
# modeling approach: fitting by minimizing function
#------------------------------------------------------------------------------

# function to minimize, returns SS for a given value of bhat 
# (note this is not using log residuals)
foo <- function(params)
  sum((rec - params[1] * spawn / (params[2] + spawn))^2)

# VER (NÂO FUNCIONA !!!)
#foo <- function(par)
#  sum(log(rec / (par[1] * ssb / (par[2] + ssb))))

# optimization function in R, returns minimum (best value of bhat) and
# objective (SS at that value)
res <- optim(c(5000, 1000), foo, method='L-BFGS-B', lower=c(1e-8, 1e-8),
  upper=c(Inf, Inf), control=list(trace=1))

plot(spawn, rec, xlab='spawners (thousands)', ylab='recruits (thousands)', pch=19,
  ylim=c(0, 2000))
lines(res$par[1]*spawn/(res$par[2]+spawn)~spawn)

text(300, 1750, paste('R =', formatC(res$par[1], digits=5), "* S/(", formatC(res$par[2], digits=5), '+ S)'))

# residual analysis
resid <- rec - res$par[1]*spawn/(res$par[2]+spawn)

# residuals by year
barplot(resid, names.arg=year, ylab='squared residuals', col='blue')
  abline(0, 0, lty=2)

# residuals by spawners
plot(spawn, resid, xlab='spawners (thousands)', ylab='recruits (thousands)', pch=19)
  abline(0, 0)

#------------------------------------------------------------------------------
# modeling approach: fitting by minimizing a function using FLR
#------------------------------------------------------------------------------
library(FLCore)

# Creating an object of class 'FLSR', suing the fraser data.frame
# as input, and a 'bevholt' model
sr <- FLSR(rec=FLQuant(fraser$rec, dimnames=list(year=fraser$year)),
  ssb=FLQuant(fraser$spawn, dimnames=list(year=fraser$year-1)),
  model='bevholt')

# Fit using MLE (optim) on the function in logl(sr)
sr <- fmle(sr)

# summary of results and plot
summary(sr)
plot(sr)

# AIC
AIC(sr)

# plot (example why "attach" is not a good option)
plot(spawn, rec, xlab='spawners (thousands)', ylab='recruits (thousands)', pch=19,
  ylim=c(0, 2000))

# now it works
plot(spawn, fraser$rec, xlab='spawners (thousands)', ylab='recruits (thousands)', pch=19,
  ylim=c(0, 2000))
lines(sr@params[1]*spawn/(sr@params[2]+spawn)~spawn)
text(300, 1750, paste('R =', formatC(sr@params[1], digits=5), "* S/(", formatC(sr@params[2], digits=5), '+ S)'))

# Try now with a Ricker model
model(sr) <- 'ricker'
sr <- fmle(sr)

# add to plot
lines(sr@params[1]*sort(spawn)*exp(-sr@params[2]*spawn)~sort(spawn), col=2)

# summary & Co.
summary(sr)
plot(sr)
AIC(sr)

#==============================================================================
# Linear least squares, many parameters: production model
#==============================================================================
rsole <- read.csv("rocksole.csv")
nyrs <- nrow(rsole)
rsole <- transform(rsole, cpue=landings/effort)
rsole$deltaU <- NA
rsole$deltaU[-nyrs] <- rsole$cpue[-1]/rsole$cpue[-nyrs]-1
rsole.pm <- lm(deltaU~effort+cpue, data=rsole)
par(mfrow=c(2,2))
plot(rsole.pm)
plot(deltaU~cpue, data=rsole)
points(predict(rsole.pm)~cpue, data=rsole[-nyrs,], pch=2, col=2)
abline(0,0)
plot(residuals(rsole.pm)~cpue, data=rsole[-nyrs,])
abline(0,0)
plot(deltaU~effort, data=rsole)
points(predict(rsole.pm)~effort, data=rsole[-nyrs,], pch=2, col=2)
abline(0,0)
plot(residuals(rsole.pm)~effort, data=rsole[-nyrs,])
abline(0,0)

#==============================================================================
# Bootstraping
#==============================================================================

# let's go back to the linear S/R
par(mfrow=c(1,1))
plot(rec~spawn)
lines(predict(SRmodLin2)~spawn)

# number of resamples and matrix to old the results
rsamp <- 1000
bootPars <- matrix(NA, ncol=2, nrow=rsamp)
rj <- residuals(SRmodLin2)
recPred <- predict(SRmodLin2)

for(i in 1:rsamp){
	recNew <- sample(rj, replace=TRUE)+recPred
	modLin <- lm(recNew~spawn)
	bootPars[i,] <- coefficients(modLin)
}

# bias ?
apply(bootPars,2,summary)
apply(bootPars,2,quantile, prob=c(0.025, 0.975))

# plots
par(mfrow=c(2,1))
hist(bootPars[,1], main="a")
hist(bootPars[,2], main="b")

