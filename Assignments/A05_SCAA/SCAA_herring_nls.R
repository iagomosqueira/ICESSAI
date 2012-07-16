# SCAA_herring - «Short one line description»
# SCAA_herring

# Copyright 2003-2009 FLR Team. Distributed under the GPL 2 or later
# Maintainer: Iago Mosqueira, Cefas
# Last Change: 14 Jan 2010 11:23
# $Id:  $

# Reference:
# Notes:

# TODO Fri 03 Jul 2009 12:17:45 PM CEST IM:

library(minpack.lm)
library(lattice)

caa <- read.table('caa_herring.dat', header=TRUE, sep='\t')
  caa <- matrix(as.matrix(caa[-1]), ncol=6, nrow=dim(caa)[1], 
    dimnames=list(year=caa$year, age=1:6))

waa <- read.table('waa_herring.dat', header=TRUE, sep='\t')
  waa <- matrix(as.matrix(waa[-1]), ncol=6, nrow=dim(waa)[1], 
    dimnames=list(year=waa$year, age=1:6))

survey <- read.table('survey_herring.dat', header=TRUE, sep='\t')
  survey <- matrix(as.matrix(survey[-1]), ncol=6, nrow=dim(survey)[1], 
    dimnames=list(year=survey$year, age=1:6))

ages <- 1:6
years <- dimnames(caa)$year
sel <- c(0.01, 0.5, 1, 1, 1, 1)
mat <- c(0.5, 1, 1, 1, 1, 1)

weight <- apply(waa, 2, mean)
weight <- c(0.104961,0.141098,0.172706,0.194000,0.213000,0.232980)

# naa matrix
naa <- caa
naa[] <- NA

# ssb vector
ssb <- rep(NA, length(years))

# Beverton & Holt SR
bv <- function(a, b, ssb)
  return((a * ssb) / (b + ssb))

# foo {{{
foo <- function(params)
{
  # extract parameters
  R1 <- params[1]
  a <- params[2]
  b <- params[3]
  Q <- params[4]
  harvest <- params[5:length(params)]

  # initial recruitment
  naa[1,1] <- R1
  # generate initial population
  for(age in 2:6)
    naa[1,age] <- naa[1, age-1] * exp(-harvest[1]*sel[age-1] - 0.2)

  # ssb for first year
  ssb[1] <- sum(naa[1,] * weight * mat)
 
  for (year in 2:length(years))
  {
    # predict recruitment
    naa[year, 1] <- bv(a, b, ssb[year-1])

    # project cohort
    for(age in 2:6)
      naa[year, age] <- naa[year-1, age-1] * exp(-harvest[year-1]*sel[age-1]-0.2)

    # calculate ssb
    ssb[year] <- sum(naa[year,] * weight * mat)
  }

  # caa predicted
  faa <- t(sel %*% t(harvest))
  caa_hat <- faa / (0.2 + faa) * naa * (1- exp(-faa - 0.2))
  caa_hat[caa_hat < 0]  <-  0

  # survey fit
  survey_hat <- naa[dimnames(survey)$year,] * (Q * matrix(c(0.3, rep(1, 5)),
    nrow=length(dimnames(survey)$year), ncol=6, dimnames=list(year=dimnames(survey)$year,
    age=1:6), byrow=TRUE))

  # TOTAL SS
  survey <- survey[-3,]
  survey_hat <- survey_hat[-3,]
  
  return(c(log(survey/survey_hat),  log(caa/caa_hat)))
} # }}}

res <- nls.lm(par=c(100000, 750000, 30000, 1e-4, rep(0.2, length(years))),
  fn=foo, control=nls.lm.control(maxiter=100, nprint=1))

# results
R1 <- res$par[1]
a <- res$par[2]
b <- res$par[3]
Q <- res$par[4]
harvest <- res$par[5:length(res$par)]

# re-generate naa and biomass

# initial recruitment
naa[1,1] <- R1

# generate initial population
for(age in 2:6)
  naa[1,age] <- naa[1, age-1] * exp(-harvest[1]*sel[age-1] - 0.2)

# ssb for first year
ssb[1] <- sum(naa[1,] * weight * mat)
 
for (year in 2:length(years))
{
  # predict recruitment
  naa[year, 1] <- bv(a, b, ssb[year-1])

  # project cohort
  for(age in 2:6)
    naa[year, age] <- naa[year-1, age-1] * exp(-harvest[year-1]*sel[age-1]-0.2)

  # calculate ssb
  ssb[year] <- sum(naa[year,] * weight * mat)
}

# caa predicted
faa <- t(sel %*% t(harvest))
caa_hat <- faa / (0.2 + faa) * naa * (1- exp(-faa - 0.2))

# Fit to catch
plot(1958:2008, rowSums(caa_hat), type='l', lwd=2, col='blue', xlab='', ylab='catch',
    ylim=c(0, max(c(max(rowSums(caa)), max(rowSums(caa_hat))))))
  points(1958:2008, rowSums(caa), pch=19, col='red')
  lines(1958:2008, rowSums(caa), col='red', lwd=1)
  legend(2000, 230000, c("pred","obs"), col=c('blue', 'red'), pch=c(NA, 19),
    lwd=c(2,0))

# residuals in catch
catches <- data.frame(year=rep(1958:2008, 6), data=c(log(caa)-log(caa_hat)),
  age=rep(1:6, each=51))
xyplot(data ~ year | as.factor(age), catches, ylab="log(catch residuals)",
  panel=function(x, y, ...)
  {
    panel.xyplot(x, y, ...)
    panel.abline(0, 0, lty=2)
  })

# survey fit
survey_hat <-  (naa[dimnames(survey)$year,] * Q)

# residuals in survey
resid <- log(survey)-log(survey_hat)
residuals <- data.frame(year=rep(2002:2008, 6), data=c(resid), age=rep(1:6, each=7))
xyplot(data ~ year | as.factor(age), residuals, ylab="log(survey residuals)",
  panel=function(x, y, ...)
  {
    panel.xyplot(x, y, ...)
    panel.abline(0, 0, lty=2)
  })

# plots
# SSB
plot(years, ssb, pch=19, type='b', lwd=1.5, ylim=c(0, max(ssb)+max(ssb)*0.15),
  xlab="", ylab="SSB", cex=0.5)

# recruitment
plot(years, naa[,1], pch=19, type='b', lwd=1.5, ylim=c(0, max(naa[,1])+max(naa[,1])*0.15),
  xlab="", ylab="recruits", cex=0.5)

# Fishing mortality
plot(years, harvest, pch=19, type='b', lwd=1.5, xlab="", ylab="F")

# SR
plot(ssb, naa[,1], ylim=c(0, max(naa[,1])), xlim=c(0, max(ssb)),
  ylab="recruits", xlab="SSB")
  lines(seq(0, max(ssb), length=150), bv(a, b, seq(0, max(ssb), length=150)),
    col="red", lwd=1.5)
