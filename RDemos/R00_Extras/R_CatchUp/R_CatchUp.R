# R_CatchUp.R - DESC
# R_CatchUp.R

# Copyright 2003-2013 FLR Team. Distributed under the GPL 2 or later
# Maintainer: Iago Mosqueira, JRC

# DATA TYPES

# numeric

1

NA

NaN

Inf

# character

'Hi'

# logical

TRUE

FALSE

T

# vector

c(1, 3, 5, 9)

1:8

seq(1, 2, length=12)

# matrix

matrix(NA, nrow=3, ncol=4)

matrix(1:12, nrow=3, ncol=4)

matrix(1:12, nrow=3, ncol=4, byrow=TRUE)

matrix(1:2, nrow=3, ncol=4)

matrix(1:5, nrow=3, ncol=4)

# array

array(1, dim=c(2,3,2))

# data.frame

data.frame(year=2006:2013, ssb=c(24, 27, 28, 22, 12, NA, 33, 21))

data.frame(year=2006:2013, ssb=c(24, 27, 28, 22, 12, NA))

data.frame(year=2006:2013, ssb=c(24, 27))

data.frame(year=2006:2013, ssb=c(24, 27, 28))

# lists

list(a=1, b=c('STR', 'LSL'), c=array(1, dim=c(2,3,2)))

# VARIABLES & ASSIGMENT

x <- 2.9818

y <- c(1,2,3,4,5)

# SUBSETTING

y[1]

y[c(1,3)]

# ARITH

2 + 3

x * y

2/3*6+1-2

((((2/3)*6)+1)-2)

(2/(3*(6+(1-2))))

# USING FUNCTIONS

x <- c(9, 5, 3, 9, 1)

max(x)

x <- c(9, 5, 3, 9, 1, NA)

max(x)

help('max')

max(x, na.rm=TRUE)

# MATH

x <- c(9, 5, 3, 9, 1)

sqrt(x)

exp(x)

log(x)

# STATS

mean(x)

median(x)

var(x)

sd(x)

quantile(x, 0.975)

# RANDOM NUMBERS & PDFs

x <- rnorm(100, mean=3, sd=10)

summary(x)

dnorm(3, mean=1, sd=2)

x <- rlnorm(200, meanlog=2, sdlog=2)

# PLOTTING

plot(x)

plot(fraser$spawn, type='l')

plot(fraser$spawn, fraser$rec)

plot(fraser$spawn, fraser$rec, pch=19, xlab="SSB", ylab="Recruits")

plot(fraser$spawn, fraser$rec, pch=19, xlab="SSB", ylab="Recruits",
	xlim=c(0, max(fraser$spawn)), ylim=c(0, max(fraser$rec)))
abline(mean(fraser$rec), 0, lty=2, col="red")

hist(x)

# CREATE YOUR OWN FUNCTIONS

foo <- function(x) {
	res <- rnorm(x, 1, 2)
	return(res)
}

foo(2)

foo(x=3)

foo <- function(x, mean=1, sd=2) {
	res <- rnorm(x, mean=mean, sd=sd)
	return(res)
}

foo(2)

foo(2, mean=2, sd=100)

foo <- function(x) {
	return(x ^ z)
}

foo(3)

z <- 4

foo(3)

help('function')

# INPUT

fraser <- read.table(file='fraser.dat', sep='\t', header=T)
