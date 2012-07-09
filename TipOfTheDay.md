# R's Tip of the Day #

## 01 - Double tab to find objects witrh matching names ##

After typing some characters of a variable name, use the tab key to get R to show you all matching variables names in your workspace. Also works with help and function names.

## 02 - Brackets vs. Parenthesis ##

	a <- 5; b <- 1; c <- 4

	g <- function (n)
    for (i in 1:n) d <- 1/(a*(b+c))
	
  g2 <- function (n)
    for (i in 1:n) d <- 1/(a*((b+c)))
	
  f <- function (n)
    for (i in 1:n) d <- 1/{a*{b+c}}
	
  f2 <- function (n)
    for (i in 1:n) d <- 1/{a*{{b+c}}}
	
  system.time(f(5000000))
  system.time(f2(5000000))
  system.time(g(5000000))
	system.time(g2(5000000))

## 03 - The fortunes package ##

	install.packages("fortunes")
	fortune()

## 04 - browser() ##

	foo <- function(x){
		y <- x*2
		browser()
	}

	arr <- array(rnorm(1000), dim=c(4,5,5))
	apply(arr, 3, function(x) sum((x)^2))	
	
	obj <- data.frame(it=rep(1:100,10000), val=rnorm(1000000))
	lst <- split(obj,obj$it)
	lapply(lst, function(x) max(x$val))


## 05 - speed up loops ##

	v <- rnorm(1000000)
	system.time(for(i in v){i^2+i^5})
	system.time(for(i in 1:length(v)){v[i]^2+v[i]^5})
