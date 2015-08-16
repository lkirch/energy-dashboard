water_rec <- function(dt) {
  ### Define libraries
  library(RPostgreSQL)
  library(lubridate)
  
  ### Connect to database
  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv,host='localhost',port='5432',dbname='postgres',user='rahul',password='uconserve')
  
  ### read in date parameter and calculate date range
  date <- dt
  start_date <- ymd(date)
  end_date <- start_date + days(4)
  
  ### define query
  query <- paste("
                 SELECT 
                 to_date(SUBSTRING(localhour,1,19),'YYYY-MM-DD') AS date
                 , count(*) AS hours_of_rain
                 FROM weather
                 WHERE to_date(SUBSTRING(localhour,1,19),'YYYY-MM-DD HH24:MI:SS')
                 BETWEEN to_date(SUBSTRING('",as.character(start_date),"',1,19),'YYYY-MM-DD HH24:MI:SS')
                 AND to_date(SUBSTRING('",as.character(end_date),"',1,19),'YYYY-MM-DD HH24:MI:SS')
                 AND cast(precip_probability as float) >= .75
                 GROUP BY to_date(SUBSTRING(localhour,1,19),'YYYY-MM-DD')
                 ORDER BY 1
                 LIMIT 2"
  )
  query <- gsub("\n"," ",query)
  query <- gsub("\t"," ",query)
  
  ### execute query and fetch data
  rs <- dbSendQuery(con,query)
  data <- fetch(rs,n=-1)
  
  ### Disconnect from database
  dbDisconnect(con)
  dbUnloadDriver(drv)
  
  data
}
