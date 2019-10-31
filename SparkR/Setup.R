#-----------------------------:::::::SparkR::::::::---------------------------------

# Working with Spark, using SparkR from R Studio

# After adding SPARK_HOME to the path in windows, check the available environments from RStudio

Sys.getenv()

# SPARK_HOME environment is availabe at C:\spark-2.0.2-bin-hadoop2.7

# Set the environment SPARK_HOME
Sys.setenv(SPARK_HOME="C:\\spark-2.0.2-bin-hadoop2.7")

# Set the library path
.libPaths(c(file.path(Sys.getenv("SPARK_HOME"),"R","lib"), .libPaths()))

# load SparkR Library from RStudio
library(SparkR)
library(rJava) # low level R to Java interface

# sparkR.init() is deprecated
sparkR.session(master = "local[*]",appName = "SparkR-RStudio", sparkConfig = list(spark.driver.memory = "2g"))
# where the master url value "local" means to run spark locally (if only "local" that means use spark within one thread with no parallelism at all). Use master="local[k]"to run Spark locally with K worker threads. (ideally, set this to the number of cores on your machine).



# Check the version
sparkR.version()

# you can monitor SparkR in localhost:4040

# convert R dataFrame into spark dataframe (using mtcars df from R datasets package)
sRmtcars <- as.DataFrame(mtcars)

# convert spark dataframe to R dataframe

Rmtcars <- as.data.frame(sRmtcars)
# If we can do some operations from spark using SparkDF, we can always convert it to R dataframe and can perform the necessary oprations.
# After cleaning and generating all the feature we can again convert it to SparkDF and can train a model.

# Reading files in other format lies in the data folder in working directory

# path <- paste(getwd(),"data",sep = "/")

# read.df(paste(path,"fileName",sep="/")) # Read SparkDF
# read.json(paste(path,"fileName.json",sep="/")) # Read .json file and return sparkDF
# read.parquet(paste(path,"fileName",sep="/")) # Read parquet file and return an sparkDF
# read.text(paste(path,"fileName.txt",sep="/")) # Read text file & return sparkDF

#--------Operations in spark data frame-----------

# Get basic information about the sparkDF
sRmtcars

# view the data
showDF(sRmtcars,10) # printing first 10 rows, by default 20 rows

# check the schema of the sparkDF
printSchema(sRmtcars)

# count the number of rows
count(sRmtcars)

# select only few columns
head(select(sRmtcars, "mpg", "cyl"))

# Filter the data frame
head(filter(sRmtcars, sRmtcars$cyl > 4))

# GroupBy, number of time same mpg appears
showDF(summarize(groupBy(sRmtcars, sRmtcars$mpg), count = n(sRmtcars$mpg)))

# Arrange : in ascending or descending order
head(arrange(sRmtcars, desc(sRmtcars$mpg))) # desc order

head(arrange(sRmtcars, sRmtcars$mpg)) # ascending order

#-----------Operating over columns------------
sRmtcars$wt100 <- sRmtcars$wt * 100
head(select(sRmtcars, "wt100"))

# Apply functions
df <- select(sRmtcars, "disp", "hp")

# define the schema
myschema <- structType(structField("disp", "double"), structField("hp", "double"), structField("disp_by_hp", "double"))

df1 <- dapply(df, function(x){ x <- cbind(x, x$disp/x$hp)},schema = myschema)
# schema is must for dapply
df1
head(collect(df1))
# ?????

# without schema 
df2 <- dapplyCollect(df, function(x){x <- cbind(x, "ratio" = x$disp/x$hp)})
head(df2)

# similarly gapply, gapplyCollect, spark.lappy etc functions can use
# we can also train and test different models, as well as save them for future predictions

# Stop/quit the spark session
sparkR.session.stop()