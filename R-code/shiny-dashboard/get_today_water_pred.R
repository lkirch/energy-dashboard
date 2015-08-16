get_today_water_pred <- function(dataid,date) {
  start_date <- ymd(date)
  dt <- start_date
  year <- as.numeric(substring(dt,1,4))
  month <- as.numeric(substring(dt,6,7))
  date <- as.numeric(substring(dt,9,10))
  
  library(RPostgreSQL)
  
  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv,host='localhost',port='5432',dbname='postgres',user='rahul',password='uconserve')
  query <- paste("select prediction from water_predictions_per_day where dataid = '1185' and year = ",year," and month = ",month," and day = ",date,sep = "")
  query
  rs <- dbSendQuery(con,query)
  data <- fetch(rs,n=-1)
  
  ### Disconnect from database
  dbDisconnect(con)
  dbUnloadDriver(drv)
  
  data$prediction
}

#get_today_water_pred('93','2014-07-16')
