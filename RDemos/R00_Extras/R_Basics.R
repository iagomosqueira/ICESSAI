
# Starting

# Calculator
1 + 2

# Printing
6

"Hello world"

# Assignment: creating variables
# NAME <- VALUE

# numeric
a <- 1
a

a <- 4 + 5
a

# character
b <- "text"
b

# logical
c <- TRUE
c

# Vectors

# rep(VALUE, No of times)
a <- rep(1, 10)

# : sequence with steps of 1
b <- 1:10

# seq(START, END, ...)
seq(1, 20)
seq(1, 5, length=10)
seq(1, 10, by=2)

# c() concatenates values
c(1, 6, 8, 1, 10, 9)
a <- c(1, 6, 8, 1, 10, 9)

# FUNCTIONS

# name(ARGUMENT, ...)

log(a)

log(7.6)

b <- log(9)

# extra arguments
log(2)

log(2, base=10)

log(base=10, 2)

log(10, 2)

# SUBSETTING
v <- runif(10)

# [
v[1]

v[1:3]

v[c(1,3,5)]

length(v)

v[length(v)]

# [<-
v[1] <- 99
v

# STATS

#
sum(v) / length(v)

mean(v)

median(v)

var(v)

sd(v)

# cv?
sd(v) / mean(v)

# MATRIX
# matrix(x, ncol, nrow) 

matrix(1, ncol=2, nrow=4)

matrix(1:8, ncol=2, nrow=4)

matrix(1:8, ncol=2, nrow=4, byrow=TRUE)

# RECYCLING
matrix(1:4, ncol=2, nrow=4)

matrix(1:3, ncol=2, nrow=4)

# DATA.FRAME
# data.frame(var1=vector, var2=vector, ...)

data.frame(a=1:5, b=c('S', 'N', 'P', 'N', 'P'))

data.frame(a=1:5, b='A')

# PROGRAMMING

# for(INDEX in SEQUENCE) FUNCTION()

for(i in 1:10)
  print(i * 3)

v <- rep(NA, 10)

for(i in 1:length(v))
  v[i] <- rnorm(1) + log(runif(1)) ^ 2

# Multiple lines
for(i in 1:length(v))
{
  v[i] <- rnorm(1) + log(runif(1)) ^ 2
  v[i] <- v[i] * 99
}


# PLOT

# plot(x, y, ...)
plot(1:length(v), v)

# CLOSING
q()
