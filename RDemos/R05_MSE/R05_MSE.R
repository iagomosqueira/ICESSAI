###############################################################################
# Simulation lecture
#
# Copyright 2003-2009 FLR Team. Distributed under the GPL 2 or later
# Maintainer: Iago Mosqueira, Cefas; Ernesto Jardim, IPIMAR
# Last Change: Fri Mar 08, 2013 at 02:51 PM -0800
# $Id:  $
#
# Reference:
# Notes: It may help repeating the sample session in R manual 
# (http://cran.r-project.org/doc/manuals/R-intro.html#A-sample-session)
#
# TODO Tue 12 Jan 2010 09:51:24 AM CET IM:
###############################################################################

#==============================================================================
# Read data, set assumptions and initialize objects
#==============================================================================

source("functions.R")

# Mortalities
M <- 0.2
F <- 0.3

# Selectivity
Pa <- c(0.001, 0.25, rep(1, 13))

iter <- 200
iyears <- 25
pyears <- 25
f <- rep(F, iter)

# Empty NAA array
naa <- array(NA, dim=c(iyears + pyears,15, iter),
    dimnames=list(year=1:(iyears + pyears), age=1:15, iter=1:iter))

#==============================================================================
# Biological production
#==============================================================================

#------------------------------------------------------------------------------
# Part #1 - mortality
#------------------------------------------------------------------------------

# Initial population size at age=1
naa[1,1,] <- 1000

# Simulation for all ages
for(a in 2:15)
  naa[1,a,] <- naa[1,a-1,] * exp(- (F*Pa[a-1] + M))

#------------------------------------------------------------------------------
# Part #2 - individual growth
#------------------------------------------------------------------------------

# Von Bertalanffy growth
winf <- 10
k <- 0.5
t0 <- -0.1
b <- 3

# Calculate weight at age
waa <- winf * (1 - exp(-k * ((1:15)-t0))) ^ b

# Compute biomass
baa <- apply(naa, c(1,3), function(x) x*waa)
meanb <- mean(apply(apply(baa, c(2,3), sum), 1, mean), na.rm=TRUE)

#------------------------------------------------------------------------------
# Part #3 - recruitment B&H
#------------------------------------------------------------------------------

# B&H pars
b1 <- 1000
b2 <- 1000

# ssb
#ssb <- sum(naa[1,3:15,] * waa[3:15])
ssb <- apply(naa[1,3:15,] * waa[3:15], 2, sum)

#==============================================================================
# Management Strategy Evaluation
#==============================================================================

#------------------------------------------------------------------------------
# Operating Model
#------------------------------------------------------------------------------

for (y in 2:iyears)
{
  # recruitment
  naa[y,1,] <- (b1 * ssb) / (b2 + ssb) + (runif(iter, -0.2, 0.2)) * 1000
    
  # abundances
  for(a in 2:15)
    naa[y,a,] <- naa[y-1,a-1,] * exp(- (F*Pa[a-1] + M))
  
  # SSB
  #ssb <- sum(waa[3:15] * naa[y, 3:15,])
  ssb <- apply(naa[y,3:15,] * waa[3:15], 2, sum)
}

# catch series
caa <- naa
for (i in 1:50)
    caa[i,,] <- naa[i,,] * (1 - exp(-Pa %*% t(f) -M)) * (Pa %*% t(f)) / (Pa %*% t(f) + M)

# f series
fy <- array(NA, dim=c(iyears + pyears, iter), dimnames=list(year=1:(iyears + pyears), iter=1:iter))
fy[1:25,]<-F

# plots
par(mfrow=c(1,3))
# R
boxplot(t(naa[,1,]), main="R")
# catch
ca <- apply(caa,3,"%*%",waa)
boxplot(t(ca), main="Catch in weight")
# f
boxplot(t(fy), main="Fishing mortality")

#------------------------------------------------------------------------------
# Management Procedure
#------------------------------------------------------------------------------

for (i in (iyears+1):(iyears+pyears))
{
  #------------------------------------------------------------------
  # observation error (none for now)
  #------------------------------------------------------------------
  #caaNew <- caa*rlnorm(length(caa), 0, 0.1)
  
  #------------------------------------------------------------------
  # Assessment
  #------------------------------------------------------------------
  # Assumed M for VPA
  Mvpa <- 0.3
  res <- vpa(caa[1:(i-1),,], Pa, f, Mvpa, agesF=3:14)
  #res <- vpa(caaNew[1:(i-1),,], Pa, f, M, agesF=3:14)
  
  #------------------------------------------------------------------
  # Harvest Control Rule (HCR)
  #------------------------------------------------------------------
  # compute reference variable
  baa <- apply(res$naa[i-1,,], 2, function(x) x * waa)
  res$biom <- apply(baa, 2, sum, na.rm=TRUE)

  # Manage with F control conditioned on the biomass level
  # Note the trick of using f in the oldest age, the mean of the fully exploited ages
  # To avoid using the last year F estimate, which is an assumption we'll use the
  # average of the previous 3 years
  fi <- colMeans(res$faa[c((i-2):(i-4)),15,])

  # Management decision/policy - if biomass < meanb, cut F by 10%
  #f[res$biom < meanb] <- f[res$biom < meanb] * 0.90
  fi[res$biom < meanb] <- fi[res$biom < meanb] * 0.90
  print(sum(res$biom < meanb))

  #------------------------------------------------------------------
  # Implementation error (none for now)
  #------------------------------------------------------------------

  fy[i,] <- fi
  #fy[i,] <- fi*runif(iter,1.15,1.25)
  
  #------------------------------------------------------------------
  # Update OM - project population with Fs decided by the HCR
  #------------------------------------------------------------------
  ssb <- apply(waa[3:15] * naa[i-1, 3:15,], 2, sum)
  naa[i,1,] <- (b1 * ssb) / (b2 + ssb) + runif(iter, -0.2,0.2) * 1000
  caa[i,1,] <- naa[i,1,] * fy[i,] * Pa[1]
  for(a in 2:15)
  {
    naa[i,a,] <- naa[i,a-1,] * exp(-(fy[i,]*Pa[a-1] + M))
    # catch by age
    caa[i,a,] <- naa[i,a,] * fy[i,] * Pa[a]
  }
}

#------------------------------------------------------------------------------
# Visual analysis of the "real" population
#------------------------------------------------------------------------------
myplot()


#------------------------------------------------------------------------------
# Ideas
#------------------------------------------------------------------------------

# Test assumptions about M
# Use distinct errors
# Change the HCR reference 
# Insert implementation error
# Insert observation error
