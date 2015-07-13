setwd("/Users/rbansal/Documents/Berkeley MIDS/W210/Project/")
list.files()

source("precip_prediction.R")
source("arima_elec_predict.R")

water_lawn_pred("2014-01-07")



year <- substring(as.character(Sys.time()),1,4)
month <- substring(as.character(Sys.time()),6,7)
date <- substring(as.character(Sys.time()),9,10)
hour <- substring(as.character(Sys.time()),12,13)

library(RPostgreSQL)
dt <- date

paste(paste(year,month,date,sep="-")," ",hour,sep="")


drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv,host='localhost',port='5432',dbname='rbansal')
query <- paste("select temperatur from weather where localhour like '2014-01-07 19%'",sep = "")
query
rs <- dbSendQuery(con,query)
data <- fetch(rs,n=-1)