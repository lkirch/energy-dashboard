bill_pred <- function(dataid,date) {
  #date <- '2014-07-13'
  start_date <- ymd(date)
  dt <- start_date
  year <- substring(dt,1,4)
  month <- substring(dt,6,7)
  date <- substring(dt,9,10)
  
  library(RPostgreSQL)
  
  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv,host='localhost',port='5432',dbname='postgres',user='rahul',password='uconserve')
  query <- paste(
    "
with projection as 
(
    select dataid, sum(usage) as projected_usage
    from
    (
    select dataid
    ,sum(eph.usage)/60 as usage
    from electricity_per_hour eph
    join peak_times pt on eph.month = pt.month and cast(eph.hour as int) = pt.hour
    join electricity_rates er on pt.month = er.month and pt.peak_status = er.peak_status
    where eph.dataid = '",dataid,"'
    and eph.year = '",year,"'
    and eph.month = '",month,"'
    and eph.day < '",date,"'
    group by dataid
    
    UNION ALL
    
    select dataid
    , sum(prediction) projected_usage
    from electricity_predictions_per_day 
    where dataid = '",dataid,"' 
    and year = ",year," 
    and month = ",as.numeric(month)," 
    and day >= ",as.numeric(date),"
    group by dataid
    ) x
    group by dataid
  )
    
    
    select eph.dataid
    ,sum(eph.usage)/60 as usage
    , sum(eph.usage*
    case
    when p.projected_usage between 0 and 500 then er.range_0_500
    when p.projected_usage between 501 and 1000 then er.range_501_1000
    when p.projected_usage between 1001 and 1500 then er.range_1001_1500
    when p.projected_usage between 1501 and 2500 then er.range_1501_2500
    else er.range_2501
    end	
    )/60/100 as cost_dollars
    , 'actual' as type
    from electricity_per_hour eph
    join projection p on eph.dataid = p.dataid
    join peak_times pt on eph.month = pt.month and cast(eph.hour as int) = pt.hour
    join electricity_rates er on pt.month = er.month and pt.peak_status = er.peak_status
    where eph.dataid = '",dataid,"'
    and eph.year = '",year,"'
    and eph.month = '",month,"'
    and eph.day < '",date,"'
    group by eph.dataid
    
    union all
    
    select pred.dataid
    ,avg(pred.projected_usage) as usage
    , sum(pred.projected_usage*breakdown.pct_usage*
    case
    when p.projected_usage between 0 and 500 then breakdown.range_0_500
    when p.projected_usage between 501 and 1000 then breakdown.range_501_1000
    when p.projected_usage between 1001 and 1500 then breakdown.range_1001_1500
    when p.projected_usage between 1501 and 2500 then breakdown.range_1501_2500
    else breakdown.range_2501
    end	
    )/100 as cost_dollars
    , 'pred' as type
    from (
    select pred.dataid
    , pred.month as month
    , sum(pred.prediction) projected_usage
    from electricity_predictions_per_day pred
    where dataid = '",dataid,"' 
    and pred.year = ",year," 
    and pred.month = ",as.numeric(month),"
    and pred.day >= ",as.numeric(date),"
    group by pred.dataid, pred.month
    ) pred
    join (
    select er.peak_status
    , usage/month_total as pct_usage
    , er.*
    from (
    select pt.peak_status
    , eph.month
    , sum(eph.usage)/60 as usage
    , (
    select sum(usage)/60
    from electricity_per_hour
    where dataid = eph.dataid
    and year = eph.year
    and month = eph.month
    and cast(day as int) between 1 and ",as.numeric(date),"
    ) as month_total
    from electricity_per_hour eph 
    join peak_times pt on eph.month = pt.month and cast(eph.hour as int) = pt.hour 
    where eph.dataid = '",dataid,"' 
    and eph.year = '",year,"' 
    and eph.month = '",month,"' 
    and cast(eph.day as int) between 1 and ",as.numeric(date),"
    group by pt.peak_status, eph.month,
    (
    select sum(usage)/60
    from electricity_per_hour
    where dataid = eph.dataid
    and year = eph.year
    and month = eph.month
    and cast(day as int) between 1 and ",as.numeric(date),"
    )
    ) pct_usage
    join electricity_rates er on pct_usage.month = er.month and pct_usage.peak_status = er.peak_status
    ) breakdown
    on pred.month = cast(breakdown.month as int)
    join projection p on pred.dataid = p.dataid
    group by pred.dataid
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

#bill_pred('93','2014-07-13')
#bill_pred('93','2014-07-14')
