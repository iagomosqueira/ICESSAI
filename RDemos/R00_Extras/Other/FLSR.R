# FLSR - «Short one line description»
# FLSR

# Copyright 2010 Iago Mosqueira, Cefas. Distributed under the GPL 2 or later
# $Id:  $

# Reference:
# Notes:

# TODO Fri 15 Jan 2010 10:22:44 AM CET IM:

library(FLCore)

# example FLSR object
data(nsher)

summary(nsher)

# explore data using lowess
nsher <- lowess(nsher)
plot(nsher)

# already implemented model: Beverton & Holt
bevholt()

# set model, logl and initial for bevholt
model(nsher) <- bevholt()

# fit using MLE
nsher <- fmle(nsher)

plot(nsher)

# AIC
AIC(nsher)


# Compare Ricker model
nsherR <- nsher
model(nsherR) <- ricker
nsherR <- fmle(nsherR)

AIC(nsherR)

x11()
plot(nsherR)
