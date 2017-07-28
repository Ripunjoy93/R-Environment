Connecting MongoDB and querying data from R
================

According to the documentation MongoDB is a document database with the scalability and flexibility that you want with the querying and indexing that you need. It is a NoSQL based leading database.

> In this article I will be using MongoDB community edition installed in my 64 bit windows machine. If you want you can use your MongoDB database hosted in some server.

If you are new to MongoDB and want to know more go through the following links :

-   [Installation of community Edition](https://docs.mongodb.com/manual/installation/)
-   [Official documentation](https://docs.mongodb.com/manual/)
-   [Tutorials Point tutorial](https://www.tutorialspoint.com/mongodb/index.htm)

> As of now you are done with your installation locally

There are many MongoDB client for R. I will be using **mongolite**, which is fast and simple.

1.  First of all, lets call the **mongolite** package from R:

``` r
if(require(mongolite)){
    print("mongolite is loaded correctly")
} else {
    print("trying to install mongolite")
    install.packages("mongolite")
    if(require(mongolite)){
        print("mongolite installed and loaded")
    } else {
        stop("could not install mongolite")
    }
}
```

    ## [1] "mongolite is loaded correctly"

1.  Run local MongoDB:

-   Go-to ur MongoDB install path and open command prompt/or from command prompt go to your path: `eg: /usr/MongoDB/bin`
-   Start MongoDB by `mongod` from your shell or command line
-   Now your MongoDB is running locally in port `27017`
