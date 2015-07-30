get_elec_current_year <- function(dataid, date) {
  
  library(lubridate)
  library(RPostgreSQL)
  
  source("get_start_of_time_frame.R")
    
  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv,host='localhost',port='5432',dbname='postgres',user='rahul',password='uconserve')
  
  end_date <- date
  start_date <- getStartOfTimeFrame(as.Date(end_date, format='%Y-%m-%d'),'year')
  
  query <- paste("select month, round(sum(usage)/60) as usage from electricity_per_hour where dataid='",dataid,"' and DATE(year || '-' || month || '-' || day) >= DATE('",start_date,"') and DATE(year || '-' || month || '-' || day) < DATE('",end_date,"') group by month order by month;",sep="")
  #print(query)
  query
  rs <- dbSendQuery(con,query)
    
  data <- fetch(rs,n=-1)
  
  ### Disconnect from database
  dbDisconnect(con)
  dbUnloadDriver(drv)
  
  data$current_year_electricity
}
