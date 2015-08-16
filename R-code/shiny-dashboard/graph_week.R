print_week_comparison_graph <- function(dataid, date, n) 
{
  #date <- '2014-07-13'
  #dataid <-'5357'
  #n <- 5
  end_date <- ymd(date) - days(1)
  end_date
  substring(end_date,1,10)
  start_date <- end_date - days(7*(n-1))
  start_date
  
  smonth <- substring(start_date,6,7)
  sdate <- substring(start_date,9,10)
  emonth <- substring(end_date,6,7)
  edate <- substring(end_date,9,10)
  start_date_2013 <- paste("2013",smonth,sdate,sep = "-")
  end_date_2013 <- paste("2013",emonth,edate,sep = "-")
  start_date_2013
  end_date_2013
  
  library(RPostgreSQL)
  
  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv,host='localhost',port='5432',dbname='postgres',user='rahul',password='uconserve')
  query <- paste(
    "
    select ty.display_date
    , ty.usage_2014
    , ly.usage_2013
    from (
    select dw.week
    , min(e.month || '/' || e.day) as display_date
    , round(sum(e.usage)/60) as usage_2014
    from electricity_per_hour e
    join date_weeks dw on e.year || '-' || e.month || '-' || e.day = dw.date
    where 1=1
    and e.dataid = '",dataid,"' 
    and DATE(e.year || '-' || e.month || '-' || e.day) >= DATE('",substring(start_date,1,10),"')
    and DATE(e.year || '-' || e.month || '-' || e.day) <= DATE('",substring(end_date,1,10),"')
    group by dw.week
    order by dw.week
    ) ty 
    join 
    (
    select dw.week
    , min(e.month || '/' || e.day) as display_date
    , round(sum(e.usage)/60) as usage_2013
    from electricity_per_hour e
    join date_weeks dw on '2014' || '-' || e.month || '-' || e.day = dw.date
    where 1=1
    and e.dataid = '",dataid,"' 
    and DATE(e.year || '-' || e.month || '-' || e.day) >= DATE('",start_date_2013,"')
    and DATE(e.year || '-' || e.month || '-' || e.day) <= DATE('",end_date_2013,"')
    group by dw.week
    order by dw.week
    ) ly on ty.display_date = ly.display_date
    order by ty.week
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

#n <- 10
#data <- print_week_comparison_graph('5357','2014-07-13',n)
#data
#nrow(data)
