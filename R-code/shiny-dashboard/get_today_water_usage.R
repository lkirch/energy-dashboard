get_today_water_usage <- function(dataid,date) {
  start_date <- ymd(date)
  dt <- start_date
  year <- substring(dt,1,4)
  month <- substring(dt,6,7)
  date <- substring(dt,9,10)
  hour <- as.numeric(substring(as.character(Sys.time()),12,13))
  
  library(RPostgreSQL)
  
  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv,host='localhost',port='5432',dbname='postgres',user='rahul',password='uconserve')
  query <- paste("select round(sum(usage)) from water_per_hour where dataid = '1185' and year = '",year,"' and month = '",month,"' and day = '",date,"' and cast(hour as int) between 0 and ",hour,sep = "")
  query
  rs <- dbSendQuery(con,query)
  data <- fetch(rs,n=-1)
  
  ### Disconnect from database
  dbDisconnect(con)
  dbUnloadDriver(drv)
  
  data$round
}

#get_today_water_usage('1185','2014-07-03')
