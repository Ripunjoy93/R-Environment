Available Datasets in R
================

For learning or testing purpose many a time we need some data in our R working environment. There are lots of built in data sets available with base R as well as the R packages we installed. We can view the list of data available in each packages as well as can make use of it.

> I am showing the packages available in my enviroment. You might or might not have these packages. Try to follow the steps with refer to your available packages.

``` r
  #First check the list of data sets available in base R in the package datasets
  data()
  # Datasets available in all the installed packages
  data(package = .packages(all.available = TRUE))

  # Datasets in a particular package
  data(package = "caret")

  # Load data from base R package datasets
  data("mtcars")

  # Read description about the dataset
  ?mtcars
```

``` r
# The data frame
  head(mtcars)
```

    ##                    mpg cyl disp  hp drat    wt  qsec vs am gear carb
    ## Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
    ## Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
    ## Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
    ## Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
    ## Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
    ## Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1

``` r
# OR
  df <- mtcars

  # OR df <- packagename::dataset_name
  df <- datasets::mtcars


  # Data from caret package
  data("dhfr",package = "caret")
```

Sometimes there might be difficulties while making a dataframe from some packages when the object is loaded as value.

``` r
  data("gadmCHE",package = "leaflet")
  # Then create dataFrame using following
  df <- as.data.frame(gadmCHE)
```
