#====================================================================
# EJ
# 20101207
# Example code to build FLStock (partial)
#====================================================================

ppeff <- read.csv2("effort.csv", row.names=1)

ppeff[] <- apply(ppeff, 2, function(x){
	x <- as.character(x)
	x <- sub(" ", "", x)
	as.numeric(x)
})

ppcn <- read.csv2("year_age_8_ag.csv", row.names=1)
ppc <- read.csv2("year_landings.csv", row.names=1)
ppcw <- read.csv2("mean_length_weight_at_age.csv", row.names=1)

ppc <- t(ppc)
dimnames(ppc)[[1]][1] <- "all"
names(dimnames(ppc))<-c("age", "year")
ppc <- FLQuant(ppc, units="t")

# small trick so we don't need to provide all dimnames
ppcn <- t(ppcn[,-ncol(ppcn)])
names(dimnames(ppcn)) <- c("age","year")
dimnames(ppcn)[[1]] <- 1:8
ppcn <- FLQuant(ppcn)

# use mcf to set same dims
flqs <- mcf(list(ppc, ppcn))
ppc <- flqs[[1]]["all"]
ppcn <- flqs[[2]][ac(1:8)]

pp.stk <- FLStock(catch=ppc, catch.n=ppcn)
units(harvest(pp.stk)) <- "f"

# to generate constant mean weight at age
dnms <- dimnames(catch.wt(pp.stk))
catch.wt(pp.stk) <- FLQuant(ppcw[,"Weight_mean"], dimnames=dnms)

# et voilá
plot(pp.stk)
xyplot(data~year, groups=qname, data=flqs, auto.key=TRUE, type="l")

# however there is a problem
computeCatch(pp.stk)

