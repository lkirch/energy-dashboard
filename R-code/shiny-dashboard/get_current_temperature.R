get_current_temperature <- function(date) {
  start_date <- ymd(date)
  dt <- start_date
  year <- substring(dt,1,4)
  month <- substring(dt,6,7)
  date <- substring(dt,9,10)
  hour <- substring(as.character(Sys.time()),12,13)
  
  library(RPostgreSQL)
  
  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv,host='localhost',port='5432',dbname='postgres',user='rahul',password='uconserve')
  query <- paste("select temperature from weather where localhour like '",paste(paste(year,month,date,sep="-")," ",hour,sep=""),"%'",sep = "")
  query
  rs <- dbSendQuery(con,query)
  data <- fetch(rs,n=-1)
  
  ### Disconnect from database
  dbDisconnect(con)
  dbUnloadDriver(drv)
  
  data$temperature
}
