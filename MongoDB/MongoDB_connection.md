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

**First of all, lets call the `mongolite` package from R :**

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

**Run local MongoDB :**

-   Go-to ur MongoDB install path and open command prompt/or from command prompt go to your path: `eg: /usr/MongoDB/bin`
-   Start MongoDB by `mongod` from your shell or command line
-   Now your MongoDB is running locally in port `27017`

**Connect MongoDB local server :**

-   Initiate a connection to MogoDB Server.

``` r
# 1. Connection to Local Server initiated by mongod : 27017 is the port where mongodb server is running
connectionLocal <- mongo(url = "mongodb://localhost:27017")
print(connectionLocal)
```

    ## <Mongo collection> 'test' 
    ##  $aggregate(pipeline = "{}", options = "{\"allowDiskUse\":true}", handler = NULL, pagesize = 1000) 
    ##  $count(query = "{}") 
    ##  $distinct(key, query = "{}") 
    ##  $drop() 
    ##  $export(con = stdout(), bson = FALSE) 
    ##  $find(query = "{}", fields = "{\"_id\":0}", sort = "{}", skip = 0, limit = 0, handler = NULL, pagesize = 1000) 
    ##  $import(con, bson = FALSE) 
    ##  $index(add = NULL, remove = NULL) 
    ##  $info() 
    ##  $insert(data, pagesize = 1000, ...) 
    ##  $iterate(query = "{}", fields = "{\"_id\":0}", sort = "{}", skip = 0, limit = 0) 
    ##  $mapreduce(map, reduce, query = "{}", sort = "{}", limit = 0, out = NULL, scope = NULL) 
    ##  $remove(query, just_one = FALSE) 
    ##  $rename(name, db = NULL) 
    ##  $update(query, update = "{\"$set\":{}}", upsert = FALSE, multiple = FALSE)

``` r
# 2. Connecting to a remote server running in some host and port
# mongodb://[username:password@]host1[:port1][,host2[:port2],...[/[database][?options]]

# Let us consider we have a collection 'income-data' in 'people-database' running in a server (192.0.something.something or some-domain)

# connection <- mongo(url = "mongodb://my-username:my-password@somedomain:port")
# commented it, because I don't really have such user name and password

# Rather conncting to a public data-base
connection <- mongo("flights", url = "mongodb://readwrite:test@ds043942.mongolab.com:43942/jeroen_test")
# -> here collection is 'flights' and database 'jeroen_test'; username:readwrite; password:test; host?:ds043942.mongolab.com; port:jeroen_test
```

-   Create a collection and Insert Data

``` r
# Get some data from "nycflights" R package: Let "flights" data
data("flights", package = "nycflights13")
head(flights, 5)
```

    ##   year month day dep_time sched_dep_time dep_delay arr_time sched_arr_time
    ## 1 2013     1   1      517            515         2      830            819
    ## 2 2013     1   1      533            529         4      850            830
    ## 3 2013     1   1      542            540         2      923            850
    ## 4 2013     1   1      544            545        -1     1004           1022
    ## 5 2013     1   1      554            600        -6      812            837
    ##   arr_delay carrier flight tailnum origin dest air_time distance hour
    ## 1        11      UA   1545  N14228    EWR  IAH      227     1400    5
    ## 2        20      UA   1714  N24211    LGA  IAH      227     1416    5
    ## 3        33      AA   1141  N619AA    JFK  MIA      160     1089    5
    ## 4       -18      B6    725  N804JB    JFK  BQN      183     1576    5
    ## 5       -25      DL    461  N668DN    LGA  ATL      116      762    6
    ##   minute           time_hour
    ## 1     15 2013-01-01 05:00:00
    ## 2     29 2013-01-01 05:00:00
    ## 3     40 2013-01-01 05:00:00
    ## 4     45 2013-01-01 05:00:00
    ## 5      0 2013-01-01 06:00:00

``` r
# By default if we don't mention the collection & db while connecting MongoDB server it is taken as 'test' and 'test' : Lets define that in connectionLocal object 
connectionLocal <- mongo(collection = "fligts-data",db = "Rmongolite",url = "mongodb://localhost:27017")
# Insert AirQuality data
connectionLocal$insert(flights)
```

    ## List of 5
    ##  $ nInserted  : num 336776
    ##  $ nMatched   : num 0
    ##  $ nRemoved   : num 0
    ##  $ nUpserted  : num 0
    ##  $ writeErrors: list()

``` r
# If you want to put same data again in the same collection (just to check): you can just write the above command again

# We successfully inserted the data
# Now you can view the data in the DB and Collection in MongoDB management tolls like 'Robomongo'

# Check How many rows are available to varify (I am running the same code again and again; so the count may be original(ie.336776)*somenumber(1 or 2 or more))
connectionLocal$count()
```

    ## [1] 336776

-   Query data from MongoDB : you can query all the available data in a collection or query specific subset of data from the collection. (MongoDB uses **JSON based Syntax** to query data)

``` r
# 1. Get all the from a collection: our flights collection is connected by ConnectionLocal object
#connectionLocal$find()
# OR : empty '{}' means get all the data
#connectionLocal$find('{}')

# 2. Read all the Data into R (create a R DataFrame)
df <- connectionLocal$find()
head(df,5)
```

    ##   year month day dep_time sched_dep_time dep_delay arr_time sched_arr_time
    ## 1 2013     1   1      517            515         2      830            819
    ## 2 2013     1   1      533            529         4      850            830
    ## 3 2013     1   1      542            540         2      923            850
    ## 4 2013     1   1      544            545        -1     1004           1022
    ## 5 2013     1   1      554            600        -6      812            837
    ##   arr_delay carrier flight tailnum origin dest air_time distance hour
    ## 1        11      UA   1545  N14228    EWR  IAH      227     1400    5
    ## 2        20      UA   1714  N24211    LGA  IAH      227     1416    5
    ## 3        33      AA   1141  N619AA    JFK  MIA      160     1089    5
    ## 4       -18      B6    725  N804JB    JFK  BQN      183     1576    5
    ## 5       -25      DL    461  N668DN    LGA  ATL      116      762    6
    ##   minute           time_hour
    ## 1     15 2013-01-01 10:30:00
    ## 2     29 2013-01-01 10:30:00
    ## 3     40 2013-01-01 10:30:00
    ## 4     45 2013-01-01 10:30:00
    ## 5      0 2013-01-01 11:30:00

``` r
# 3. Query by using some logical expression. Get the data where : carrier=="UA" and distnace>1000
dfq1 <- connectionLocal$find('{"carrier":"UA","distance" : {"$gt":1000}}')
head(dfq1,5)
```

    ##   year month day dep_time sched_dep_time dep_delay arr_time sched_arr_time
    ## 1 2013     1   1      517            515         2      830            819
    ## 2 2013     1   1      533            529         4      850            830
    ## 3 2013     1   1      558            600        -2      924            917
    ## 4 2013     1   1      558            600        -2      923            937
    ## 5 2013     1   1      559            600        -1      854            902
    ##   arr_delay carrier flight tailnum origin dest air_time distance hour
    ## 1        11      UA   1545  N14228    EWR  IAH      227     1400    5
    ## 2        20      UA   1714  N24211    LGA  IAH      227     1416    5
    ## 3         7      UA    194  N29129    JFK  LAX      345     2475    6
    ## 4       -14      UA   1124  N53441    EWR  SFO      361     2565    6
    ## 5        -8      UA   1187  N76515    EWR  LAS      337     2227    6
    ##   minute           time_hour
    ## 1     15 2013-01-01 10:30:00
    ## 2     29 2013-01-01 10:30:00
    ## 3      0 2013-01-01 11:30:00
    ## 4      0 2013-01-01 11:30:00
    ## 5      0 2013-01-01 11:30:00

``` r
# 4. Filter Fields : Get only few required fields (let: arr_delay,carrier,origin,dest,distance) combine with the previous query
dfq2 <- connectionLocal$find(
  query = '{"carrier":"UA","distance" : {"$gt":1000}}',
  fields = '{"arr_delay":true, "carrier":true, "origin":true, "dest" : true, "distance":true}'
  )
head(dfq2,5)
```

    ##                        _id arr_delay carrier origin dest distance
    ## 1 59806e7c7cbd0c35a8005304        11      UA    EWR  IAH     1400
    ## 2 59806e7c7cbd0c35a8005305        20      UA    LGA  IAH     1416
    ## 3 59806e7c7cbd0c35a8005310         7      UA    JFK  LAX     2475
    ## 4 59806e7c7cbd0c35a8005311       -14      UA    EWR  SFO     2565
    ## 5 59806e7c7cbd0c35a8005314        -8      UA    EWR  LAS     2227

``` r
# while filtering random UUID will be created automatically, If you don't want it need to explicitly mention -> "_id" : false

# 5. Sort and limit : limit is for restrict the number of outputs(let 10), lets sort in desscending order
dfq3 <- connectionLocal$find(
  query = '{"carrier":"UA","distance" : {"$gt":1000}}',
  fields = '{"_id":false,"arr_delay":true, "carrier":true, "origin":true, "dest" : true, "distance":true}',
  sort = '{"distance" : -1}',
  limit = 15
  )
# Check the dimension of the DataFrame
dim(dfq3)
```

    ## [1] 15  5

``` r
head(dfq3,5)
```

    ##   arr_delay carrier origin dest distance
    ## 1        21      UA    EWR  HNL     4963
    ## 2        -4      UA    EWR  HNL     4963
    ## 3        31      UA    EWR  HNL     4963
    ## 4        -3      UA    EWR  HNL     4963
    ## 5       -45      UA    EWR  HNL     4963

``` r
# 6. Select by Date : greater than 2013-08-25T18:00:00Z
dfq4 <- connectionLocal$find(
  query = '{"time_hour": { "$gte" : { "$date" : "2013-08-25T18:00:00Z" }}}',
  fields = '{"time_hour" : true, "carrier" : true, "origin":true, "_id": false}'
)
head(dfq4,5)
```

    ##   carrier origin           time_hour
    ## 1      US    EWR 2013-10-01 10:30:00
    ## 2      UA    EWR 2013-10-01 10:30:00
    ## 3      AA    JFK 2013-10-01 10:30:00
    ## 4      UA    LGA 2013-10-01 10:30:00
    ## 5      B6    JFK 2013-10-01 10:30:00

``` r
# Many other operations like indexing, iterating are also can be performed -> explore yourself :)
```

-   Aggregation of data using aggregate() method

``` r
dfagr1 <- connectionLocal$aggregate(
  '[{"$group":{"_id":"$carrier", "count": {"$sum":1}, "average":{"$avg":"$distance"}}}]',
  options = '{"allowDiskUse":true}'
)

head(dfagr1,5)
```

    ##   _id count   average
    ## 1  UA 58665 1529.1149
    ## 2  WN 12275  996.2691
    ## 3  AA 32729 1340.2360
    ## 4  B6 54635 1068.6215
    ## 5  DL 48110 1236.9012

-   MapReduce : map and reduce operations by giving custom functions in JavaScript

``` r
dfmr1 <- connectionLocal$mapreduce(
  map = "function(){emit(Math.floor(this.distance/100)*100, 1)}", 
  reduce = "function(id, count){return Array.sum(count)}"
)
colnames(dfmr1) <- c("scale_distance", "counts")
head(dfmr1,5)
```

    ##   scale_distance counts
    ## 1              0   1633
    ## 2            100  16017
    ## 3            200  33637
    ## 4            300   7748
    ## 5            400  21182

\*There are many more functionalities we can perform in MongoDB from R. &gt; Drop database/collection : connectionLocal*d**r**o**p*() &gt; *R**e**m**o**v**e**s**o**m**e**r**o**w**s* : *c**o**n**n**e**c**t**i**o**n**L**o**c**a**l*remove('{"Carrier":"UA"}') &gt; Remove only one row : connectionLocal$remove('{"Carrier":"UA"}', just\_one = TRUE) &gt; Remove all records but not the collection : connectionLocal$remove() &gt; We can also import, expoer **JSON, BSON** files &gt; Update a single row/document : connectionLocal$update('{"carrier":"UA"}', '{"$set":{"distance": 1111}}') &gt; Update entire rows/documents : connectionLocal$update('{}','{"carrier":"UA"}', '{"$set":{"distance": 1111}}',multiple = TRUE) &gt; Add if no matches found : connectionLocal$update('{"carrier":"UA"}', '{"$set":{"distance": 1111}}', upsert = TRUE)
