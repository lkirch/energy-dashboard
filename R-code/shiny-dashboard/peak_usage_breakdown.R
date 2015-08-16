peak_times_breakdown <- function(dataid, date) {
  start_date <- ymd(date)
  dt <- start_date
  #dataid='93'
  #dt <- "2014-07-13"
  year <- substring(dt,1,4)
  month <- substring(dt,6,7)
  date <- as.numeric(substring(dt,9,10))
  
  library(RPostgreSQL)
  #library(plotly)
  #install.packages("plotly")
  
  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv,host='localhost',port='5432',dbname='postgres',user='rahul',password='uconserve')
  query <- paste("select pt.peak_status, sum(usage)/60 as usage from electricity_per_hour eph join peak_times pt on eph.month = pt.month and cast(eph.hour as int) = pt.hour where eph.dataid = '",dataid,"' and eph.year = '",year,"' and eph.month = '",month,"' and cast(eph.day as int) between 1 and ",date," group by pt.peak_status order by pt.peak_status",sep = "")
  query
  rs <- dbSendQuery(con,query)
  data <- fetch(rs,n=-1)
  data$pct_usage <- data$usage/sum(data$usage)  
  #plot(data$peak_status,data$pct_usage)
  #barplot(c(data$peak_status,data$pct_usage))
  
  ### Disconnect from database
  dbDisconnect(con)
  dbUnloadDriver(drv)
  
  data
}


#data <- peak_times_breakdown('93','2014-07-13')

#barplot(data$pct_usage
 #       , names.arg = data$peak_status
  #      , col="darkblue"
   #     , xlab = "Peak Status"
    #    , ylab = "% Usage"
     #   , ylim = c(0.0,1.0)
      #  , main = "Electricity Usage by Peak Status")
