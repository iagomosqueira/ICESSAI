# R Basic Features
# Introducing some of R basic features

# Copyright 2011-12 Iago Mosqueira & Ernesto Jardim, EC JRC

# NOTES
# It may help repeating the sample session in R manual 
# (http://cran.r-project.org/doc/manuals/R-intro.html#A-sample-session)


# Procedures

# Algebra
2 * 2
1 + 3
2 * (3.1416 + 1)

# Matrix algebra
x <- 1:4
y <- diag(x)
z <- matrix(1:12, ncol = 3, nrow = 4)
y %*% z
y %*% x
x %*% z

# check that y %*% z is the same as
m <- z
m[] <- NA
m[1,1] <- sum(y[1,]*z[,1])
m[2,1] <- sum(y[2,]*z[,1])
m[3,1] <- sum(y[3,]*z[,1])
m[4,1] <- sum(y[4,]*z[,1])

# etc, finish yourself

z * 3
y + (y * 2)

# Statistics
x <- rnorm(20, 4, 25)
mean(x)
median(x)
var(x)
sd(x)

# Named storage

# Objects are stored in the workspace by name
foo <- 1:10
foo
length(foo)

# even functions, both user-defined
foo <- function(x)
{
  return(x + 1)
}
foo

# or R's own
sd

# Functions are created to perform a given task repeatedly
foo <- function(x, y=2)
{
  return(x * y)
}

foo(10, 5)
foo(3)

# Every object in R belongs to a class
class(foo)
class(x)

# with inheritance
is(z)
is(x, 'vector')

# lists are very flexible, and sometimes dangerous, objects
li <- list(a=1, b=matrix(4, ncol=3, nrow=5), c=list(aa=1:10))
li

# and data.frames are the natural class for 2D tables
df <- data.frame(year=1971:2010, check=TRUE, intensity=rnorm(40))
df
head(df)
summary(df)
