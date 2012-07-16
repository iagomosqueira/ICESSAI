# vpa - «Short one line description»
# vpa

# Copyright 2010 Iago Mosqueira, Cefas. Distributed under the GPL 2 or later
# $Id:  $

# Reference:
# Notes:

# TODO Thu 17 Jun 2010 12:05:05 AM CEST IM:

vpa <- function(caam, sel, lastF, M, agesF=seq(dim(caam)[2]))
{
  # last year
  lastY <- dim(caam)[1]
  years <- 1:lastY
  lastA <- dim(caam)[2]

  # Empty NAA matrix
  naam <- caam
  naam[] <- NA

  # Empty FAA matrix
  faam <- caam
  faam[] <- NA
  
  # Assign initial values to faa
  for(i in 1:dim(caam)[3])
    faam[lastY,,i] <- sel * lastF[i]

  # then to naa
  naam[lastY,,] <- (caam[lastY,,] * (faam[lastY,,] + M)) / (faam[lastY,,] *
    (1 - exp(-faam[lastY,,] - M)))

  # populate naam and faam values from NAA_year=2008 and NAA_age=6
  for (y in rev(years)[-1])
  {
    for(a in 1:(lastA-1))
    {
      naam[as.character(y), as.character(a),] <- naam[as.character(y+1),
        as.character(a+1),] * exp(M) + caam[as.character(y),
        as.character(a),] * exp(0.5 * M)
      faam[as.character(y), as.character(a),] <- log(naam[as.character(y),
        as.character(a),] / naam[as.character(y+1), as.character(a+1),]) - M
    }
    faam[as.character(y), lastA,] <- mean(faam[as.character(y), agesF,])
    naam[as.character(y), lastA,] <- (caam[as.character(y), lastA,] *
        (faam[as.character(y), lastA,] + M)) / (faam[as.character(y), lastA,] *
        (1 - exp(-faam[as.character(y), lastA,] - M)))
  }
  return(list(naa=naam, faa=faam))
}



###########
# plot

myplot <- function(){
par(mfrow=c(2,2))

# recruitment
plot(apply(naa[,1,], 1, median, na.rm=T), type='b', pch=19, ylim=c(0, max(naa, na.rm=T)), xlab="", ylab="individuals", main="R")
  lines(1:50, apply(naa[,1,], 1, quantile, 0.025, na.rm=T), lty=2)
  lines(1:50, apply(naa[,1,], 1, quantile, 0.975, na.rm=T), lty=2)
abline(v=25, lty=2, col='red')

# SSB
ssb <- apply(apply(naa[,,], c(1,3), function(x) x * waa), c(2,3), sum, na.rm=T)
plot(apply(ssb, 1, median, na.rm=T), type='b', ylim=c(0, max(ssb, na.rm=T)), pch=19, xlab="", ylab="ton", main="SSB")
  lines(1:50, apply(ssb, 1, quantile, 0.025), lty=2)
  lines(1:50, apply(ssb, 1, quantile, 0.975), lty=2)
abline(v=25, lty=2, col='red')

# catch
catch <- apply(apply(caa[,,], c(1,3), function(x) x * waa), c(2,3), sum, na.rm=T)
plot(apply(catch, 1, median, na.rm=T), type='b', ylim=c(0, max(catch)), pch=19, xlab="", ylab="ton", main="Catch")
  lines(1:50, apply(catch, 1, quantile, 0.025, na.rm=T), lty=2)
  lines(1:50, apply(catch, 1, quantile, 0.975, na.rm=T), lty=2)
abline(v=25, lty=2, col='red')

# f
plot(apply(fy, 1, median, na.rm=T), type='b', ylim=c(0, max(fy, na.rm=T)), pch=19, xlab="", ylab="ton", main="F")
  lines(1:50, apply(fy, 1, quantile, 0.025, na.rm=T), lty=2)
  lines(1:50, apply(fy, 1, quantile, 0.975, na.rm=T), lty=2)
abline(v=25, lty=2, col='red')

}

