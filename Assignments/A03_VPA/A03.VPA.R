# VPA - A plain Virtual Population Analysis using Pope's (1972) approximation
# A03_VPA.R

# Copyright 2011-12 Iago Mosqueira & Ernesto Jardim, EC JRC


# Read data, set assumptions and initialize objects

# Load CAA and WAA by year
caa <- read.table('csherring_caa.dat', sep='\t', header=TRUE)
waa <- read.table('csherring_waa.dat', sep='\t', header=TRUE)

# mean weight-at-age, selectivity and maturity
weight <- c(0.10, 0.14, 0.17, 0.19, 0.21, 0.23)
sel <- c(0.01, 0.5, 1, 1, 1, 1)
mat <- c(0.5, 1, 1, 1, 1, 1)
years <- caa$year
ages <- 1:6
M <- 0.2

# CAA matrix
caam <- as.matrix(caa[,2:7])
dimnames(caam) <- list(year=years, age=ages)

# WAA matrix
waam <- as.matrix(waa[,2:7])
dimnames(waam) <- list(year=years, age=ages)

# Empty NAA matrix
naam <- caam
naam[] <- NA

# Empty FAA matrix
faam <- caam
faam[] <- NA

#==============================================================================
# VPA
#==============================================================================

# Assign initial values to FAA_year=2008
faam['2008',] <- sel * 0.5

# then to NAA_year=2008
naam['2008',] <- (caam['2008',] * (faam['2008',] + M)) / (faam['2008',] *
  (1 - exp(-faam['2008',] - M)))

# populate naam and faam values from NAA_year=2008 and NAA_age=6
for (y in rev(years)[-1])
{
  for(a in 1:5)
  {
    naam[as.character(y), as.character(a)] <- naam[as.character(y+1),
      as.character(a+1)] * exp(M) + caam[as.character(y),
      as.character(a)] * exp(0.5 * M)
    faam[as.character(y), as.character(a)] <- log(naam[as.character(y),
      as.character(a)] / naam[as.character(y+1), as.character(a+1)]) - M
  }
  faam[as.character(y), '6'] <- mean(faam[as.character(y), as.character(3:5)])
  naam[as.character(y), '6'] <- (caam[as.character(y), '6'] * (faam[as.character(y),
    '6'] + M)) / (faam[as.character(y), '6'] * (1 -
    exp(-faam[as.character(y), '6'] - M)))
}

# plot age-1 abundance
mojo <- naam[,'1']
plot(years, mojo, type='b', pch=19, cex=0.6, ylab="Age-1 abundance", xlab="", main="My MOJO plot")

# plot F
plot(years, rowMeans(faam[,c("3", "4", "5", "6")]), type='b', pch=19, cex=0.6, ylab="F (age 3-6)", xlab="")

# plot SSB
plot(years, rowSums((naam * waam) %*% mat), type='b', pch=19, cex=0.6, ylab="SSB", xlab="")

# What is the abundance at age, 1958-2008?
naam

# Is fishing mortality since 2000 high or low relative
# to earlier levels?
mean(faam[as.character(2000:2008),])
mean(faam[as.character(1958:1999),])

# Is recruitment since 2000 weak or strong relative
# to earlier levels?
mean(naam[as.character(2000:2008),1])
mean(naam[as.character(1958:1999),1])

#==============================================================================
# Examine sensitivity of recruitment series to various values of Fage-3+ in 2004:
# F2004,age-3+= (0.25, 0.75)
#==============================================================================

# vpa {{{
vpa <- function(caam, sel, lastF, M, agesF=seq(dim(caam)[2]))
{
  # last year
  lastY <- dim(caam)[1]
  lastA <- dim(caam)[2]

  # Empty NAA matrix
  naam <- caam
  naam[] <- NA

  # Empty FAA matrix
  faam <- caam
  faam[] <- NA

  # Assign initial values to FAA_lastyear
  faam[lastY,] <- sel * lastF

  # then to NAA_lastyear
  naam[lastY,] <- (caam[lastY,] * (faam[lastY,] + M)) / (faam[lastY,] *
    (1 - exp(-faam[lastY,] - M)))

  # populate naam and faam values from NAA_year=2008 and NAA_age=6
  for (y in rev(years)[-1])
  {
    for(a in 1:(lastA-1))
    {
      naam[as.character(y), as.character(a)] <- naam[as.character(y+1),
        as.character(a+1)] * exp(M) + caam[as.character(y),
        as.character(a)] * exp(0.5 * M)
      faam[as.character(y), as.character(a)] <- log(naam[as.character(y),
        as.character(a)] / naam[as.character(y+1), as.character(a+1)]) - M
    }
    faam[as.character(y), lastA] <- mean(faam[as.character(y), agesF])
    naam[as.character(y), lastA] <- (caam[as.character(y), lastA] * (faam[as.character(y),
      lastA] + M)) / (faam[as.character(y), lastA] * (1 -
      exp(-faam[as.character(y), lastA] - M)))
  }
  return(list(naa=naam, faa=faam))
} # }}}

res <- vpa(caam, sel=sel, lastF=0.5, M=0.2, agesF=3:5)
res2 <- vpa(caam, sel, 0.25, 0.2, 3:5)
res3 <- vpa(caam, sel, 0.75, 0.2, 3:5)

# Recruitments
plot(1958:2008, res$naa[,1], type='b', ylab="recruits", xlab="")
  lines(1958:2008, res2$naa[,1], type='b', pch=3)
  lines(1958:2008, res3$naa[,1], type='b', pch=4)

# Fs
plot(1958:2008, apply(res$faa[,3:5], 1, mean), type='b', ylab="F(3-5)", xlab="")
  lines(1958:2008, apply(res2$faa[,3:5], 1, mean), type='b', pch=3)
  lines(1958:2008, apply(res3$faa[,3:5], 1, mean), type='b', pch=4)

# SSBs
plot(1958:2008, rowSums((res$naa * waam) %*% mat), type='b', ylab="SSB", xlab="")
  lines(1958:2008, rowSums((res2$naa * waam) %*% mat), type='b', pch=3)
  lines(1958:2008, rowSums((res3$naa * waam) %*% mat), type='b', pch=4)


# Selectivity
sel <- c(0.01, 1, 1, 1, 1, 1)
resS <- vpa(caam, sel=sel, lastF=0.5, M=0.2, agesF=2:5)
