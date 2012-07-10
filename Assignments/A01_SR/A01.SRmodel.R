###############################################################################
# model_fitting assigment - B&H fit to sole
# Copyright 2003-2009 FLR Team. Distributed under the GPL 2 or later
# Maintainer: Iago Mosqueira, Cefas; Ernesto Jardim, IPIMAR
# Last update: 17/06/2011
# This script shows the steps followed to complete the assignment regarding
# fitting a S/R B&H to sole data. 
###############################################################################


# load data
sole <- read.table('sole.dat', header=T, sep='\t')
attach(sole)

# function to minimize (log-likelihood of Beverton & Holt SR model)
foo <- function(par)
  sum(log(rec / (par[1] * ssb / (par[2] + ssb)))^2)

# call optimizer
res <- optim(c(5000, 1000), foo)

# estimated values
rechat <- res$par[1] * ssb / (res$par[2] + ssb)

# log residuals
lnresid <- log(rec / rechat)

# SStot
sstot <- sum((log(rec) - mean(log(rec)))^2)

# R2
R2 <- 1 - (res$value/sstot)

# plot model fit
plot(ssb, rec, pch=19, xlab='SSB', ylab='recruits', xlim=c(0,max(ssb)),
  ylim=c(0, max(rec)))
pssb <- seq(0, max(ssb), length=200)
lines(pssb, res$par[1] * pssb / (res$par[2] + pssb), col='red')

# plot obs. vs. pred.
lim <- max(rec, rechat)
plot(rec, rechat, xlab='R', ylab=expression(hat(R)), pch=19,
  xlim=c(0, lim), ylim=c(0, lim))
lines(c(0, lim), c(0, lim), lty=2)

# plot residuals over time
barplot(lnresid, names.arg=year, ylab='Ln residuals', col='blue')
  abline(0, 0, lty=2)

# plot residuals over SSB
plot(ssb, lnresid, pch=19, xlab='SSB', ylab='Ln residual')
  abline(0, 0, lty=2)
