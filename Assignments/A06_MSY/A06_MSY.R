# MSY - «Short one line description»
# MSY

# Copyright 2009 Iago Mosqueira, Cefas. Distributed under the GPL 2 or later
# $Id:  $

# Reference:
# Notes:

# TODO Fri 07 Aug 2009 08:36:14 AM CEST IM:

# Parameters
M <- 0.2
F <- 0.3

Winf <- 10
k <- 0.5
t0 <- 0.1
b <- 3

# SR parameters
alp <- 0.2
bet <- 0.0001
sd <- 0.2

sel <- c(0.1, 0.5, rep(1, 8))
mat <- c(0, 0, rep(1, 8))
wei <- c(0.48, 2.31, 4.48, 6.31, 7.63, 8.51, 9.08, 9.43, 9.65, 9.79)

# this function computes the F that generates the highest yld in year 100
foo <- function(params)
{
  F <- params

  naa <- matrix(NA, nrow=100, ncol=10, dimnames=list(year=1:100, age=1:10))
  caa <- matrix(NA, nrow=100, ncol=10, dimnames=list(year=1:100, age=1:10))

  ssb <- rep(NA, 100)
  yie <- rep(NA, 100)

  naa[1,1] <- 100
  caa[1,1] <- naa[1,1] * (F * sel[1] / (F * sel[1] + M)) * (1 - exp(-(F * sel[1] + M)))

 for(a in 2:10)
  {
    naa[1,a] <- naa[1,a-1] * exp(-(M + F * sel[a-1]))
    caa[1,a] <- naa[1,a] * (F * sel[a] / (F * sel[a] + M)) * (1 - exp(-(F * sel[a] + M)))
  }

  ssb[1] <- sum(naa[1,] * wei * mat)
  yie[1] <- sum(caa[1,] * wei)

  for(y in 2:100)
  {
    # age 1
    naa[y,1] <- (alp * ssb[y-1] * exp(-bet * ssb[y-1])) + rnorm(1, 0, sd)
    caa[y,1] <- naa[y,1] * (F * sel[1] / (F * sel[1] + M)) * (1 - exp(-(F * sel[1] + M)))

    # other ages
    for(a in 2:10)
    {
      naa[y,a] <- naa[y-1,a-1] * exp(-(M + F * sel[a-1]))
      caa[y,a] <- naa[y,a] * (F * sel[a] / (F * sel[a] + M)) *
        (1 - exp(-(F * sel[a] + M)))
    }

    ssb[y] <- sum(naa[y,] * wei * mat)
    yie[y] <- sum(caa[y,] * wei)
  }
  return(1/yie[100])
} # }}}

res <- optim(0.3, foo, method="L-BFGS-B", lower=1e-08, upper=1)

# fooOut {{{
fooOut <- function(params)
{
  F <- params

  naa <- matrix(NA, nrow=100, ncol=10, dimnames=list(year=1:100, age=1:10))
  caa <- matrix(NA, nrow=100, ncol=10, dimnames=list(year=1:100, age=1:10))

  ssb <- rep(NA, 100)
  yie <- rep(NA, 100)

  naa[1,1] <- 100
  caa[1,1] <- naa[1,1] * (F * sel[1] / (F * sel[1] + M)) * (1 - exp(-(F * sel[1] + M)))

 for(a in 2:10)
  {
    naa[1,a] <- naa[1,a-1] * exp(-(M + F * sel[a-1]))
    caa[1,a] <- naa[1,a] * (F * sel[a] / (F * sel[a] + M)) * (1 - exp(-(F * sel[a] + M)))
  }

  ssb[1] <- sum(naa[1,] * wei * mat)
  yie[1] <- sum(caa[1,] * wei)

  for(y in 2:100)
  {
    # age 1
    naa[y,1] <- (alp * ssb[y-1] * exp(-bet * ssb[y-1])) + rnorm(1, 0, sd)
    caa[y,1] <- naa[y,1] * (F * sel[1] / (F * sel[1] + M)) * (1 - exp(-(F * sel[1] + M)))

    # other ages
    for(a in 2:10)
    {
      naa[y,a] <- naa[y-1,a-1] * exp(-(M + F * sel[a-1]))
      caa[y,a] <- naa[y,a] * (F * sel[a] / (F * sel[a] + M)) *
        (1 - exp(-(F * sel[a] + M)))
    }

    ssb[y] <- sum(naa[y,] * wei * mat)
    yie[y] <- sum(caa[y,] * wei)
  }
  return(list(ssb=ssb, yield=yie, naa=naa))
} # }}}

out <- fooOut(res$par)
ssb <- out$ssb
yie <- out$yie
naa <- out$naa

# SSB
plot(ssb, type='l', lwd=2, col='blue')

# Yield
plot(yie, type='l', lwd=2, col='red')

# SR
plot(ssb, naa[,1], type='l', col='red', ylim=c(0, max(naa[,1])), xlim=c(0, max(ssb)))

mean(yie[50:100])
var(yie[50:100])

