get_elec_current_week <- function(dataid, date) {
  
  library(lubridate)
  library(RPostgreSQL)
#  library(stringr)
  
  source("~/shiny-server/take3/get_start_of_time_frame.R")
  
  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv,host='localhost',port='5432',dbname='postgres',user='rahul',password='uconserve')
  
  end_date <- as.Date(date)
  start_date <- getStartOfTimeFrame(as.Date(end_date, format='%Y-%m-%d'),'week')
  
  ### TODO: Remove whitespace from around dates after variable substitution ###
  query <- paste("select month, day, hour, round(sum(usage)/60) as usage from electricity_per_hour where dataid=",dataid," and DATE(year || '-' || month || '-' || day) >= DATE('"start_date"') and DATE(year || '-' || month || '-' || day) < DATE('"end_date"') group by month, day, hour order by month, day, hour;")
  query
  rs <- dbSendQuery(con,query)
  
  data <- fetch(rs,n=-1)
  
  ### Disconnect from database
  dbDisconnect(con)
  dbUnloadDriver(drv)
  
  data$current_week_electricity
}