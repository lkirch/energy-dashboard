print_date_comparison_graph <- function(dataid, date, n) 
{
  #date <- '2014-07-13'
  #dataid <-'5357'
  end_date <- ymd(date) - days(1)
  end_date
  substring(end_date,1,10)
  start_date <- end_date - days(n-1)
  start_date
  
  smonth <- substring(start_date,6,7)
  sdate <- substring(start_date,9,10)
  emonth <- substring(end_date,6,7)
  edate <- substring(end_date,9,10)
  start_date_2013 <- paste("2013",smonth,sdate,sep = "-")
  end_date_2013 <- paste("2013",emonth,edate,sep = "-")
  
  library(RPostgreSQL)
  
  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv,host='localhost',port='5432',dbname='postgres',user='rahul',password='uconserve')
  query <- paste(
    "
    select ty.display_date
    , ty.usage_2014
    , ly.usage_2013
    from (
    select year || '-' || month || '-' || day as nk, month || '/' || day as display_date, round(sum(usage)/60) as usage_2014
    from electricity_per_hour 
    where dataid = '",dataid,"' 
    and DATE(year || '-' || month || '-' || day) >= DATE('",substring(start_date,1,10),"')
    and DATE(year || '-' || month || '-' || day) <= DATE('",substring(end_date,1,10),"')
    group by year, month, day
    ) ty
    join
    (
    select year || '-' || month || '-' || day as nk, month || '/' || day as display_date, round(sum(usage)/60) as usage_2013
    from electricity_per_hour 
    where dataid = '",dataid,"' 
    and DATE(year || '-' || month || '-' || day) >= DATE('",start_date_2013,"')
    and DATE(year || '-' || month || '-' || day) <= DATE('",end_date_2013,"')
    group by year, month, day
    ) ly on ty.display_date = ly.display_date
    order by ty.nk
    ",sep = "")
  query <- gsub("\n"," ",query)
  query <- gsub("\t"," ",query)
  query
  rs <- dbSendQuery(con,query)
  data <- fetch(rs,n=-1)
  
  ### Disconnect from database
  dbDisconnect(con)
  dbUnloadDriver(drv)

  data
}

#n <- 5
#data <- print_date_comparison_graph('5357','2014-07-13',n)
#data

#plot(data$usage_2014
#     , type = "l"
#     , xlab = "Date"
#     , ylab = "Usage, kWh"
#     , main = "Comparing to Last Year"
#     , ylim = c(50, 150)
#     , col = "blue"
#     , xaxt = "n")
#axis(1,at=1:n, labels=data$display_date)
#legend("topright", title = "Year", c("2014","2013"), fill = c("blue","black"))
#lines(data$usage_2013)
