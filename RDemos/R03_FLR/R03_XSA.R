# FLXSA demo

# Copyright 2011-12 Iago Mosqueira & Ernesto Jardim, EC JRC


# load pkgs
library(FLXSA)


# NS plaice data
data(ple4)

summary(ple4)
plot(ple4)

# Indices of abundance
data(ple4.indices)

# Run XSA, ion one line of code. Defaults for control
xsa <- FLXSA(ple4, ple4.indices)

# Output standard table of diagnostics
diagnostics(xsa)

# Fix BUG on names of fitted indices
inames <- unlist(lapply(ple4.indices,'name'))
names(xsa@index.res)<- inames

# Residuals of fit to indices by age & year
plot(bubbles(age~year|qname, data=mcf(xsa@index.res)))

# Update stock object with new results
ple4 <- ple4 + xsa

# control options can be changed
FLXSA.control()

mycontrol <- FLXSA.control(vpa=TRUE)
xsa <- FLXSA(ple4, ple4.indices, control=mycontrol)

# Plain VPA also available
vpa <- VPA(ple4)

# Plot differences in abundances
xyplot(data~year|qname, data=FLQuants(vpa=quantSums(stock.n(vpa)), xsa=quantSums(stock.n(ple4))), type='b')

# and F
xyplot(data~year|qname, data=FLQuants(vpa=quantMeans(harvest(vpa)), xsa=quantMeans(harvest(ple4))), type='b')

# Run retrospective for years 2000:2008
retro.years <- 2000:2008

ple4.retro <- FLStocks(tapply(retro.years, 1:length(retro.years),
  function(x) window(ple4, end=x) + FLXSA(window(ple4,end=x), ple4.indices)))

# plot results
plot(FLStocks(ple4.retro))
