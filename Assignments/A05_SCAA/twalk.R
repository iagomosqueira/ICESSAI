


library(Rtwalk)

x0 <- c(100000, 750000, 30000, 1e-4, rep(0.2, length(years)))
xp0 <- c(10000, 75000, 3000, 1e-2, rep(0.6, length(years)))
  
Runtwalk(dim=396, Tr=10, Obj=foo, x0=x0, xp0=xp0, Supp=function(x) { rep(TRUE, 55) })

  # extract parameters
  R1 <- params[1]
  a <- params[2]
  b <- params[3]
  Q <- params[4]
  harvest <- params[5:length(params)]


library(FLCore)

data(nsher)

rec <- rec(nsher)
ssb <- ssb(nsher)

foo <- function(x) logl(nsher)(x[1], x[2], rec, ssb)

res <- Runtwalk(dim=2, Tr=10, Obj=foo, x0=c(0.5, 0.5), xp0=c(2,2), Supp=function(x) return(TRUE))
