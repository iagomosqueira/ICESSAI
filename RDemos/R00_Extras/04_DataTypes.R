# DataTypes.R - Getting to know R data types
# First/04_DataTypes.R

# Copyright 2011-12 JRC FishReg. Distributed under the GPL 2 or later
# Maintainer: FishReg, JRC

# Introduction to R for Fisheries Science

# DATA TYPES

# First operations

# Assignment

# To create objects in our workspace, use <-

ob <- 4

ov <- 1:10

# Type its name to inspect, same as show()

ov

show(ov)

# Basic operators

# Subsetting, [

ov[2]

# Arithmetic, works element by element

ob + ob

ob + 10

ov * 2

ob ^ ob

# WARNING: R recycling rule!

ov * c(1, 2)

# Nesting operations

log(((ob + 2) * (ov / 3)) ^ 2)

# Comparison

ov > ob

ov <= ob


# NUMERIC VECTORS

# Vectors can be created as a sequence, using : or seq()

ov <- 1:10

seq(1, 10, by=2)
seq(1, 10, length=20)

# or by contatenating elements, using c()

on <- c(1,5,7,6,3,4,4,1,2)

# Many functions operate on vectors naturally

mean(on)

var(on)

# Subsetting can select one or more elements,
# including or excluding

ov[3]

ov[3:5]

ov[-1]

# Information on a vector, like
# length

length(ov)

# summary of values

summary(ov)

# Some eye candy

plot(ov)

# equivalent to

plot(1:length(ov), ov)

# try some of the extra arguments

dat <- rnorm(20, 5, 6)

plot(dat, main="Some random numbers", xlab="", ylab="N", type='b')

# When in doubt, use is()
is(ov)

is.numeric(ov)
is.vector(ov)

# STRINGS (CHARACTERS)

# Vectors can also consist of strings

# Use quotes to create them

a <- "welcome to"
b <- "the R course"

# We can combine them in a longer string

msg <- c(a,b)

# Using paste converts to character if needed
paste(a, b, 2012)

# Checking data type
is.vector(msg)

is.numeric(msg)

is.character(msg)


# FACTOR

# Character data with a limited set of possible values

dir <- c("N", "S", "W", "E")

dir <- as.factor(dir)

levels(dir)

# Values not in levels() are not valid

dir[2] <- "P"


# LOGICAL

# R has explicit logical elements: TRUE and FALSE

res <- c(TRUE, FALSE)


# what are they?

is(res)

is.logical(res)

# Logicals are commonly used for subsetting

dat <- 1:4

dat[c(TRUE, FALSE, FALSE, TRUE)]


# SPECIAL VALUES

# R has special representations of

# Inf

Inf

1/0

# Not-a-number

NaN

1/0 - 1/0
sin(Inf)

# Not Available
NA

dat <- c(1, 4, 8, 9, NA, 12)

dat

is.na(dat)

# Some functions can deal with NA as required
mean(dat)

res <- mean(dat, na.rm=TRUE)

sum(dat, na.rm=TRUE)

# EX01_Vectors.R


# DATA FRAME 

# A 2D table of data

# Example:

year <- seq(2000, 2010)
catch <- c(900, 1230, 1400, 930, 670, 1000, 960, 840, 900, 500,400)

dat <- data.frame(year=year, catch=catch)

# A data.frame can be inspect using

# summary

summary(dat)

# or head/tail

head(dat)
tail(dat)

# and its size with dim
dim(dat)

# Access individual columns using $
dat$year

# or, either by name
dat[, 'catch']

# or position
dat[, 2]

# Same for rows
dat[1:5,]

# Selection based on boolean logic comes handy
# e.g. select those rows matching year=2004
dat[dat$year==2004,]

# Adding extra columns of various types
dat$area <- rep(c("N", "S"), length=11)

dat$survey <- c(TRUE, FALSE, FALSE, rep(TRUE, 5), FALSE, TRUE, TRUE)


# LIST

# A list is a very flexible container. Element can be of any class and size

lst <- list(data=dat, description="Some data we cooked up")

# Extract elements by name using $
lst$dat

is.data.frame(lst$dat)

# or using [ and [[
# [ name/position subsets the list
lst[1]

is(lst[1])

# while [[ extracts the subset element
lst[[1]]

is(lst[[1]])


# Lists can be nested. Use with caution!

lst$repetition <- lst


# MATRIX

# A 2D structure of either numeric or character elements

# Constructed using matrix()

matrix(rnorm(100), ncol=10, nrow=10)

mat <- matrix(rnorm(100), ncol=10, nrow=10)

# Subsetting as in df

mat[1, 2]
mat[1, ]
mat[1:4,]

# Get size using dim
dim(mat)

# R works column first, unless instructed otherwise

a <- matrix(1:16, nrow=4)

a <- matrix(1:16, nrow=4, byrow=TRUE)

# An important method for matrices is apply()

mat <- matrix(1:10, ncol=10, nrow=10)

apply(mat, 2, sum)

apply(mat, 1, sum)


# ARRAY

# An array is an n-dimensional extension of a matrix

# Created by array(), specifying dim and dimnames

array(1:100, dim=c(5, 5, 4))

arr <- array(1:25, dim=c(5, 5, 4))

# Subsetting works as in matrix, on all dims (count the commas)

arr[1:3, 1:5, 4]

# but be careful with dimensions collapsing

arr[1,,]

arr[1,3,]

# Arithmetic (element by element) is well defined

arr * 2

arr + (arr / 2)

# apply is our friend here too

apply(arr, 2, sum)

apply(arr, 2:3, sum)
