#====================================================================
# EJ
# 20110623
# Example code to read lowestoft data files
#====================================================================

library(FLCore)

# read stock data
stk <- readFLStock("indexhs.low")

plot(stk)

# read abundance indices aka tunning fleets
ind <- readFLIndices("tun06.low")

summary(ind)


