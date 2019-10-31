# Load data ------------------------------------------------------

# Open the servey survey data off the website
# (but I recommend you download a copy on to your computer)
ss <- read.csv("http://had.co.nz/stat480/data/server-survey.csv")

# Give each record a unique id
ss$id <- 1:nrow(ss)


# Basic summaries----------------------------------------------------
#
# Certain summaries only make sense for continuous variables
# so we'll create a data frame that only contains them.
# 
# We've seen sapply before - it works like lapply, but it will
# simplify (that's what the s stands for) the result into a simple
# vector or array if possible.  Also remember that a data.frame is 
# a list of vectors, so cont will be a logical vector indicating
# if each variable is numeric (ie. continuous) or not
cont <- sapply(ss, is.numeric)
scont <- ss[, cont]

# Melt the data so we can perform some basic summary statistics
library(reshape)
contm <- melt(scont, id="id", preserve=FALSE)

# This doesn't look very good because of the scientific notation
cast(contm, variable ~ ., c(length, min, max, mean, sd))

# so we'll tell R not to use scientific notation unless it really
# has too, and drop off the first row, which isn't very interesting
# anyway
options(scipen = 9)
cast(contm, variable ~ ., c(length, min, max, mean, sd))[-1, ]

# Explore with GGobi ----------------------------------------------

# It's often useful to do some basic exploration in GGobi as well:
# it's very easy to switch between different plots.

library(rggobi)
ggobi(ss)

# Focus on asian_prop, sex, state, and pcttip ------------------------

# We don't have time to fix all the variables in class, so we'll
# focus on four with characteristics representative of all the others

## Sex 

table(ss$sex, exclude=NULL)

# The 2 represents unknown, so we'll lump it in with the missings
ss$sex[ss$sex == 2] <- NA
table(ss$sex, exclude=NULL)

ss$sex <- factor(ss$sex, levels=c(0,1), labels=c("male", "female"))
# Worked out from look at hair colour/baldness


## State

table(ss$state)
# What a mess!

table(tolower(ss$state))
# A little better
ss$state <- tolower(ss$state)

# Let's remove all non-US states, and standardise US to their
# two letter abbreviations.  We can do this in two ways.  The
# first is simple, but time consuming: fix each case individually.

ss$state[ss$state == "(province)  ontario, canada"] <- NA
ss$state[ss$state == "alaska"] <- "AK"
# and so on.

# Anothe way is to use subsetting creatively
# First we'll make up a named vector of all the states and their
# abbreviations (I got mine from http://www.usps.com/ncsc/lookups/usps_abbreviations.html)

states <- c("alabama"="al", "alaska"="ak", "american samoa"="as", "arizona"="az", "arkansas"="ar", "california"="ca", "colorado"="co", "connecticut"="ct", "delaware"="de", "district of columbia"="dc", "federated states of micronesia"="fm", "florida"="fl", "georgia"="ga", "guam"="gu", "hawaii"="hi", "idaho"="id", "illinois"="il", "indiana"="in", "iowa"="ia", "kansas"="ks", "kentucky"="ky", "louisiana"="la", "maine"="me", "marshall islands"="mh", "maryland"="md", "massachusetts"="ma", "michigan"="mi", "minnesota"="mn", "mississippi"="ms", "missouri"="mo", "montana"="mt", "nebraska"="ne", "nevada"="nv", "new hampshire"="nh", "new jersey"="nj", "new mexico"="nm", "new york"="ny", "north carolina"="nc", "north dakota"="nd", "northern mariana islands"="mp", "ohio"="oh", "oklahoma"="ok", "oregon"="or", "palau"="pw", "pennsylvania"="pa", "puerto rico"="pr", "rhode island"="ri", "south carolina"="sc", "south dakota"="sd", "tennessee"="tn", "texas"="tx", "utah"="ut", "vermont"="vt", "virgin islands"="vi", "virginia"="va", "washington"="wa", "west virginia"="wv", "wisconsin"="wi", "wyoming"="wy")

# Next. find the states in that list
longstates <- ss$state %in% names(states)
ss$state[longstates]

# Then subset to get the abbreviations
states[ss$state[longstates]]

# Then replace existing
ss$state[longstates] <- states[ss$state[longstates]]

table(ss$state)
# Not perfect, but a lot better.  You might want to clean up
# the few typos by hand.

# Lastly we'll get rid of all the non US states by setting 
# them to missing
ss$state[!ss$state %in% states] <- NA
# (Alternatively, you might want to aggregate by country instead)

# And turn it into a factor
ss$state <- factor(ss$state, levels=states)

## Percent tip

table(ss$pcttip)

# A couple of problems:
#  * some are proportions and some a percents
#  * some awfully big tips!

# Turn proportions into percents
props <- !is.na(ss$pcttip) & na.omit(ss$pcttip < 1)
ss$pcttip[props] <- ss$pcttip[props] * 100

table(ss$pcttip)
table(round_any(ss$pcttip, 1), exclude=NULL)
# Looks like some awfully bad tippers too!

# Let's investigate the big tips
ss <- ss[!is.na(ss$pcttip) &  ss$pcttip > 70, ]

# They look suspicious to me - do people really tip 100% at IHOP?!

# For this class, we'll just drop those records, but I suggest
# you explore them further
ss <- ss[!(!is.na(ss$pcttip) &  ss$pcttip > 70), ]

## Asian prop

table(ss$asian_prop, exclude=NULL)
# Again propotions instead of percentages, plus a few wacko numbers

props <- !is.na(ss$asian_prop) & ss$asian_prop < 1
ss$asian_prop[props] <- ss$asian_prop[props] * 100

ss[!is.na(ss$asian_prop) &  ss$asian_prop > 100, ]
ss[!is.na(ss$asian_prop) &  ss$asian_prop > 100, "asian_prop"] <- NA

qplot(ss$asian_prop, type="histogram", breaks=seq(0, 100, by=5))
qplot(ss$asian_prop, type="histogram", breaks=seq(0, 100, by=1))

# Quick state by state analysis ----------------------------------------

ssstatem <- melt(ss, id=c("id", "state"), measure=c("pcttip", "asian_prop"), preserve=FALSE)
cast(ssstatem, state ~ variable, length)
cast(ssstatem, state ~ variable, c(length, mean))

means <- cast(ssstatem, state ~ variable, mean)

qplot(asian_prop, pcttip, data=means, main="State means")
qplot(asian_prop, pcttip, data=ss, main="Individual restaurants")

# Might want to think about making the size of the points proportional
# to the number of observations, so we can see which ones have less dat
