# Getting started ------------------------------------------------------------

# Once per computer:
install.package("ggplot2")

# Every time you open R
library(ggplot2)

# Two ways to inspect a data set:
head(diamonds)
str(diamonds)

# Make sure you type things exactly; 
# R is very fussy

# Graphics -------------------------------------------------------------------

# Scatterplots 

qplot(carat, price, data=diamonds)
qplot(log(carat), log(price), data=diamonds)
qplot(carat, price/carat, data=diamonds)

qplot(carat, price, data=diamonds, colour=color)
qplot(carat, price, data=diamonds, size=carat)
qplot(carat, price, data=diamonds, shape=cut)

qplot(price, carat, data=diamonds, facets = . ~ color)
qplot(price, carat, data=diamonds, facets = color ~ clarity)

# Bar charts and histograms

qplot(cut, data=diamonds, geom="bar")
qplot(price, data=diamonds, geom="histogram")
qplot(price, data=diamonds, geom="histogram", binwidth=500)
qplot(price, data=diamonds, geom="histogram", binwidth=100)
qplot(price, data=diamonds, geom="histogram", binwidth=10)
