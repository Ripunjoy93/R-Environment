# Load data set
load(url("http://had.co.nz/de.zip"))

# Figure out what we just loaded
ls()
str(de)

# Is a list consisting of 3d arrays
#  - list is of difference meterological variables
#  - array is 3d array of location and time

# Is meterological data on 24 x 24 grid over central America
# Data collected monthly for 6 years (72 observations total)

str(de$temperature)

# Extract single time series for experimentation
o <- de$ozone[1,1,]
plot(o, type=”l”)

# Deasonalising -----------------------------------------------

# Strong seasonal effect - how can we remove it?

# Simple way is just to take difference with lag twelve
# For each month, this will subtract the previous years value
plot(diff(o, lag=12))

# And make a function that deasonalises a single location
# This is useful because if we come up with a better way of
# deseasonalising the data (see below) we can easily plug it in
ds <- function(x) diff(x, lag=12)

ds(o)
# Always check it works!

# Repeat over all locations -----------------------------------

# Now want to deasonalise all locations.  Could possibility do 
# this by hand but it would be fiddly and take a long time.  
# Instead we'll use the iapply function which splits an array
# in to pieces, applies our function to each piece and then joins
# the pieces back together

library(reshape)

# Arguments to iapply:
#  * array to manipulate
#  * array indices to split up by
#  * function to use 

# Location stored in the first two dimensions, so we need to use
# 1:2 as the second argument

# Check that it's doing what we expect
dim(iapply(de$ozone, 1:2, ds)
str(iapply(de$ozone, 1:2, ds)
iapply(de$ozone, 1:2, ds)[1, 1, ]

# Finally, create a function to encapsulate this task
ds_all <- function(x) iapply(x, 1:2, ds)

# Repeat for all variables ------------------------------

# Similarly want to deasonalise all locations for all variables.
# Different variables stored in a list, so we can use lapply

lapply(de, ds_all)

# Easy! :)

# Advanced deasonalising -------------------------------------

# Another approach would be to subtract each month's average value
# The easiest way to do this is with a linear model

# Need to create variable which gives month for each time point
# Use factor because we want to estimate a mean for each month
month <- factor(rep(1:12, 6), labels=c("Jan","Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))

# Monthly averages
coef(lm(o ~ month - 1))
# Remove monthly averages
resid(lm(o ~ month))

# Then create deasonalising function
ds <- function(x) resid(lm(x ~ month))