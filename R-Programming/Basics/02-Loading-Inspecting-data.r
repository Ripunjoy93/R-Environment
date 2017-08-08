# Loading data ------------------------------------------
# Load a csv file (recommended output from excel)

# On Windows
diamonds <- read.csv("c:\\documents and settings\\desktop\\diamonds.csv")
# On anything else
diamonds <- read.csv("~/desktop/diamonds.csv")
# Prompt for a file name
diamonds <- read.csv(file.choose())
# Load from a website
diamonds <- read.csv("http://had.co.nz/stat480/lectures/diamonds.csv")

# Load a file delimited by spaces
diamonds <- read.table(file.choose())
# Load a tab delimited file:
diamonds <- read.table(file.choose(), sep="\t")

# Examining an object -----------------------------------
# Bad idea if you have a big object:
diamonds

# Better:
head(diamonds)

# Statistical summary
summary(diamonds)

# Look at the structure
str(diamands)
