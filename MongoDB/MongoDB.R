# Connecting MongoDB with R, and then analysisng data
require(mongolite)

# Reading data from local MongoDB database (To read from local, need to start mongo server locally)
#mongodb://[username:password@]host1[:port1][,host2[:port2],...[/[database][?options]]
ml_tripdata <- mongo(collection = "ml_trip",db = "carbook",url = "mongodb://localhost:27017")
ml_tripdata$count() #4803 records

# Reading data from test MongoDB database (user-profile collection)
data_test <- mongo(collection = "userprofile",db = "carbook", url = "mongodb://carbook:carbook#123#@192.168.2.202:27017")

# create data-frame from data_test object
df <- data_test$find()
# From the data frame itself we can perform operations, else we can write queries to extract exact data required instead of all fields.



#********************-----------------*************************#
# Queries

vehicledetails <- mongo(collection = "vehicledetails",db = "carbook", url = "mongodb://carbook:carbook#123#@192.168.2.202:27017")
vdf <- vehicledetails$find()

# 1.find where make=="Tata" and exShowroomPrice=="<500000"
vdfq1 <- vehicledetails$find('{"make":"Tata","price.exShowroomPrice" : {"$lt":500000}}')

# 2.filter fields (let _id,make, model, variant, price)
vdfq2 <- vehicledetails$find(
  query = '{"make":"Tata","price.exShowroomPrice" : {"$lt":500000}}',
  fields = '{"make":true, "model":true, "variant":true, "price.exShowroomPrice" : true}'
  )
# by default "_id" is included, if we don't want. We need to disable it like - "_id":false

# 3.Sort and limit : limit is for restrict the number of outputs, lets do it ascending order

vdfq3 <- vehicledetails$find(
  query = '{"make":"Tata","price.exShowroomPrice" : {"$lt":500000}}',
  fields = '{"_id" : false,"make":true, "model":true, "variant":true, "price.exShowroomPrice" :                  true}',
  sort = '{"price.exShowroomPrice" : 1}',
  limit = 10
  )

# 4.ITERATOR................
# perform query and return the iterator
it <- vehicledetails$iterate(
  query = '{"make":"Tata","price.exShowroomPrice" : {"$lt":500000}}',
  fields = '{"_id" : false,"make":true, "model":true, "variant":true, "price.exShowroomPrice" :                  true}',
  sort = '{"price.exShowroomPrice" : 1}',
  limit = 10
)

# read records from  the iterator
while(!is.null(x <- it$one())){
  qdf <- x$price.exShowroomPrice
}

### Date query, id based queries are also available


