# debugging - «Short one line description»
# debugging

# Copyright 2009 Iago Mosqueira, Cefas. Distributed under the GPL 2 or later
# $Id:  $

# Reference:
# Notes:

# TODO Wed 29 Jul 2009 10:27:08 AM CEST IM:

# Finding and fixing bugs in R can be very easy or very difficult, it all
# depends on (1) ow hard the bug is, (2) how do we try to locate and identify it,
# and (3) how many eyes look for it

# "Given enough eyeballs, all bugs are shallow"
# Linus Law - Eric S. Raymond, The Cathedral and the Bazaar.
# http://en.wikipedia.org/wiki/Linus%27_Law

# ERROR MESSAGES

# Calling a function providing a missing variable as argument
seq(a, 10)

#

# BASE R DEBUGGING

# traceback
# Shows the call stack that has lead to an error
x <- rnorm(8)
y <- 1:7
lm(y ~ x)

traceback()

# debug()
# Gets a function into debug mode, so a browser is opened once
# the function is called
foo <- function(a)
{
  return(a^2)
}

debug(foo)
foo(8)

# Inside a browsing session we get a different prompt, Browse[1]>

# The following commands can be used:
# n, to go to the next command
# c, to continue to the end of the function or the next stopping point
# Q, to quit browser

# local variables can be inspected and modified
ls()
a
a <- 3
c

undebug(foo)

# browser
# Specific stops can be placed inside a function using browser()
foo <- function(a)
{
  if(a < 10)
    browser()
  
  return(a^2)
}

foo(12)
foo(8)
c

# debug Package
require(debug)

foo <- function(a)
{
  return(a^2)
}

mtrace(foo)
foo(8)

# PROFILING AND OPTIMIZING CODE

# "We should forget about small efficiencies, say about 97% of the time: premature optimization is the root of all evil."
# D. Knuth

# Measuring time
foo <- function(a)
{
  for(i in 1:a)
  {
    x <- rnorm(a)
    y <- rlnorm(a)
    lm(y ~ x)
  }
}

# returns time difference between right before and after calling foo(8)
system.time(foo(8))

# test increase in time with size
time <- data.frame(n=1:50, time=NA)
for(i in 1:50)
  time[i,'time'] <- system.time(foo(i))[3]

plot(time$n, time$time, xlab="n", ylab="time (sec)")

# Profiling
data(longley)

Rprof("longley.lm.out")
invisible(replicate(1000, lm(Employed ~ ., data=longley)))
Rprof(NULL)

longleydm <- data.matrix(data.frame(intcp=1, longley))

Rprof("longley.lm.fit.out")
invisible(replicate(1000, lm.fit(longleydm[,-8], longleydm[,8])))
Rprof(NULL)

data <- summaryRprof("longley.lm.out")
print(str(data))

# plot profiling data using profr pkg
require(profr)

plot(parse_rprof("longley.lm.out"),
                 main="Profile of lm()")
plot(parse_rprof("longley.lm.fit.out"),
                 main="Profile of lm.fit()")

# A Perl script[1] can be used to create a graphic representation of the output of Rprof
system("./prof2dot.pl longley.lm.out | dot -Tpdf > longley_lm.pdf")
system("./prof2dot.pl longley.lm.fit.out | dot -Tpdf > longley_lmfit.pdf")

#[1] http://wiki.r-project.org/rwiki/doku.php?id=tips:misc:profiling



# WRITING TESTS

# UNIT TESTING

# SOME TRICKS

# - Modularize your code using functions.
# - Test inputs of each function for correct values, dimensions and classes.
# - Be careful with variables names (R is case sensitive).
# - Start on an empty R session.
# - Use NA to initialize empty objects, so that missing values are clearly detected.
# - Write test code that includes positive and negative examples, and boundaries.
# - If a function keeps returning wrong results, rewrite it from scratch in a less
#   efficient but simpler way.
# - Set an explicit random seed if using random number generation
set.seed(898)
rnorm(2)
rnorm(2)
set.seed(898)
rnorm(2)
