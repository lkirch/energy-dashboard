get_elec_current_day <- function(dataid, date) {
  
  library(lubridate)
  library(RPostgreSQL)
#  library(stringr)
  
  source("~/shiny-server/take3/get_start_of_time_frame.R")
  
  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv,host='localhost',port='5432',dbname='postgres',user='rahul',password='uconserve')
  
  # need to go back 2 days for the data since we are looking for the previous day
  end_date <- getStartOfTimeFrame(as.Date(date, format='%Y-%m-%d'),'day')
  start_date <- getStartOfTimeFrame(as.Date(end_date, format='%Y-%m-%d'),'day')
  
  ### TODO: Remove whitespace from around dates after variable substitution ###
  query <- paste("select day, hour, round(sum(usage)/60) as usage from electricity_per_hour where dataid=",dataid," and DATE(year || '-' || month || '-' || day) >= DATE('"start_date"') and DATE(year || '-' || month || '-' || day) < DATE('"end_date"') group by day, hour order by day, hour;",sep="")
  query
  rs <- dbSendQuery(con,query)
  
  data <- fetch(rs,n=-1)
  
  ### Disconnect from database
  dbDisconnect(con)
  dbUnloadDriver(drv)
  
  data$prev_day_electricity
}