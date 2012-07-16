

source("SCAA_herring_nls.R")

# Projections

pyears <- seq(2009, 2025)

pnaa <- rbind(naa, matrix(NA, nrow=length(pyears), ncol=ncol(naa), 
    dimnames=list(year=pyears, age=1:6)))

pssb <- c(ssb, rep(NA, length(pyears)))

pharvest <- c(harvest, rep(0.10,, length(pyears)))

for(year in (pyears-1957)) {

  # predict recruitment
  pnaa[year, 1] <- bv(a, b, pssb[year-1])

  # project cohort
  for(age in 2:6)
    pnaa[year, age] <- pnaa[year-1, age-1] * exp(-pharvest[year-1]*sel[age-1]-0.2)

  # calculate ssb
  pssb[year] <- sum(pnaa[year,] * weight * mat)

}

# Stochastic Projections

pyears <- seq(2009, 2025)
niter <- 100
reclim <- 150000

pharvest <- c(harvest[length(harvest)], rep(0.1, length(pyears)))

spnaa <- array(NA, dim=c(length(pyears)+1, ncol(naa), niter),
  dimnames=list(year=c(2008, pyears), age=1:6, iter=seq(niter)))
spnaa[1,,] <- naa['2008',]


spssb <- matrix(NA, nrow=length(pyears) + 1, ncol=niter,
  dimnames=list(year=c(2008, pyears), iter=seq(niter)))
spssb['2008',] <- ssb[length(ssb)]

for(year in seq(pyears) + 1) {

  # predict recruitment
  spnaa[year, 1, ] <- bv(a, b, spssb[year-1,]) + runif(niter, -reclim, reclim)

  # project cohort
  for(age in 2:6)
    spnaa[year, age, ] <- spnaa[year-1, age-1, ] * exp(-pharvest[year-1]*sel[age-1]-0.2)

  # calculate ssb
  spssb[year,] <- colSums(spnaa[year,,] * weight * mat)

}

# plot SSB median + 95% quantiles + some trajectories
plot(c(2008, pyears), apply(spssb, 1, median), ylab="SSB", xlab="", pch=19, type='b',
     ylim=c(0, max(spssb)))
  lines(c(2008, pyears), apply(spssb, 1, quantile, 0.025), lty=2)
  lines(c(2008, pyears), apply(spssb, 1, quantile, 0.975), lty=2)
  for(i in sample(niter)[1:6])
    lines(c(2008, pyears), spssb[,i], col="red")

