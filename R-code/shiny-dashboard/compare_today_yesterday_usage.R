compare_today_yesterday_usage <- function(dataid,date) {
  #date <- '2014-07-13'
  dt <- ymd(date)
  start_date <- ymd(date) - days(1)
  year <- substring(dt,1,4)
  month <- substring(dt,6,7)
  date <- substring(dt,9,10)
  yyear <- substring(start_date,1,4)
  ymonth <- substring(start_date,6,7)
  ydate <- substring(start_date,9,10)
  
  hour <- as.numeric(substring(as.character(Sys.time()),12,13))
  
  library(RPostgreSQL)
  
  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv,host='localhost',port='5432',dbname='postgres',user='rahul',password='uconserve')
  query <- paste(
    "
        select 
        100*(
        (
        select round(sum(usage)/60) 
        from electricity_per_hour 
        where dataid = '",dataid,"' 
        and year = '",year,"' 
        and month = '",month,"' 
        and day = '",date,"' 
        and cast(hour as int) between 0 and 17
        ) / 
        (
        select round(sum(usage)/60) 
        from electricity_per_hour 
        where dataid = '",dataid,"' 
        and year = '",yyear,"' 
        and month = '",ymonth,"' 
        and day = '",ydate,"' 
        and cast(hour as int) between 0 and 17) - 1) as pct_diff
    ",sep = "")
  query <- gsub("\n"," ",query)
  query <- gsub("\t"," ",query)
  #query
  rs <- dbSendQuery(con,query)
  data <- fetch(rs,n=-1)
  
  ### Disconnect from database
  dbDisconnect(con)
  dbUnloadDriver(drv)
  
  data$pct_diff
}

#compare_today_yesterday_usage('93','2014-07-16')