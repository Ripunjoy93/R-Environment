# Packages also contain data: ----------------
library(reshape)
data(package="reshape")

?french_fries
head(friench_fries)
str(french_fries)

?tips
head(tips)
str(tips)

# Melting data -------------------------------

# When melting need to indicate which variables are 
# identifier and which variables are measured variables

ffm <- melt(french_fries, id=1:5, measure=5:9)

# A variable can only be id or measured, so we only need
# to specify one of the two

ffm <- melt(french_fries, measure=5:9)
ffm <- melt(french_fries, id=1:5)

# Can also use variable names instead of column indices

ffm <- melt(french_fries, id = c("time", "treatment", "subject", "rep"))


# Casting data ---------------------------------------

# Once we have data in molten form, we can cast the data into
# different shapes by specifying which variables should go in the rows
# and which in the columns (just like pivot tables in excel)

cast(ffm, treatment ~ variable, mean)
cast(ffm, subject ~ variable, mean)
cast(ffm, subject + treatment ~ variable, mean)

# Useful for determining where missing values are:

cast(ffm, subject ~ time, length)
cast(ffm, treatment ~ rep, length)
cast(ffm, subject + treatment ~ time, length)

# Find out more on the reshape website: http://had.co.nz/reshape