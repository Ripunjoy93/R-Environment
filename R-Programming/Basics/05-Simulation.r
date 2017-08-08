# Generating random numbers -------------------------
rnorm(10)
rnorm(100)
rnorm(100, mean=10, sd=5)
rpois(10, 10)

# * normal = rnorm
# * poisson = rpois
# * binomial = rbinom
# * gamma = rgamma
# * look at help.search(keyword="distribution") for more
# 
# Always check with the documentation that the distribution
# is parameterised the way you expect.  Eg. for normal, standard
# deviation, not variance.


# Repeating a task -------------------------
# 
# replicate(n, task) repeats task n times and joins the 
# result into a single vector.

replicate(100, mean(rnorm(100)))
replicate(100, mean(rnorm(10)))


# Display an empirical distribution ----------------
# 
# An empirical distribution is one derived from data,
# as opposed to a theoretical distribution.  

qplot(replicate(100, mean(runif(10))), type="histogram")

# More replicates will give a better estimate of the distribution
# (but will take more time, obviously)

qplot(replicate(100, mean(runif(10))), type="histogram")
qplot(replicate(1000, mean(runif(10))), type="histogram")
qplot(replicate(10000, mean(runif(10))), type="histogram")
qplot(replicate(100000, mean(runif(10))), type="histogram")

# Central limit theorem -------------------------------
#
# Let use these tools to explore the central limit theorem.
# We will also use functions to reduce duplication in our code.

# First get the simple case working
qplot(replicate(100, mean(runif(10))), type="histogram")
# Easy! - we have already done this

# Next, figure out what parameters we want.  We'll start with:
#  * n = number of replicates
#  * m = number of samples to average over
# Create variables, and then use those in the expression:

n <- 100
m <- 10
qplot(replicate(n, mean(runif(m))), type="histogram")

# This is _exactly_ what we had before, we've just replaced 
# a couple of numbers with variables

# Next, we wrap it our expression in a function with the 
# parameters we figured out:

clt <- function(n, m) {
	x <- replicate(n, mean(runif(m)))
	qplot(x, type="histogram")
}
# Notice that I've indented the inside of the function to
# make it easier to see where it begins and ends.  You'll want
# to create and edit functions in a text editor (or the script editor 
# in R) - it's just too hard to do it line by line.

# Now check that it works:
clt(1000, 1)
clt(1000, 2)
clt(1000, 3)
clt(1000, 4)

# Let's make our function a bit more flexible, so that
# we can specify the distribution function as well. 

# So we need one new parameter: r, the random number
# generating function

r <- runif
qplot(replicate(n, mean(r(m))), type="histogram")

# It works, so now for the next step:

clt <- function(n, m, r) {
	x <- replicate(n, mean(r(m)))
	qplot(x, type="histogram")
}

clt(1000, 1, runif)
clt(1000, 1, rnorm)
clt(1000, 1, rpois)

# Uh oh!  That last one didn't work.  Why not?
# The rpois function needs another parameter, lambda, which
# we haven't supplied.  

# The easiest way to get around this is to create a new 
# random number generate that generates random poisson number
# with given lambda

clt(1000, 1, function(n) rpois(n, lambda=5))
clt(1000, 1, function(n) rpois(n, lambda=10))
clt(1000, 1, function(n) rpois(n, lambda=100))

# Here you can see we didn't name the function we created,
# we just passed it into another function.  A function with
# no name is a called an anonymous function.

# Here we see that as the mean of the lambda increases, it 
# becomes more symmetric.  

# We can also improve our clt function in another way, by 
# adding default values.  When we don't specify the parameter in the 
# function call, the default will be used instead.

clt <- function(n=1000, m=1, r=runif) {
	x <- replicate(n, mean(r(m)))
	qplot(x, type="histogram")
}

# Here our defaults are: n = 100, m = 1 and r = runif

clt()
clt(10000)
clt(m=10)
clt(r=rnorm)