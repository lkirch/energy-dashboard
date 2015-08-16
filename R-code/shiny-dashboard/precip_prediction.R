water_lawn_pred <- function(dt) {
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

### build the recommendation
rec <- ""
if(nrow(data) > 0)
{
  rec <- "We recommend that you don't water your lawn today. The forecast shows\n"
  for(i in 1:nrow(data)) 
  {
    row <- data[i,]
    rec <- paste(rec,row$hours_of_rain,"hour(s) with 75% likelihood of rain on",row$date,"\n")
  }
}

rec
}

#water_lawn_pred("2014-01-07")


