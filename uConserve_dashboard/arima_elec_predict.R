next_day_elec_predict <- function(dataid,date) {
  library(RPostgreSQL)
  library(lubridate)
  #dataid <- '93'
  #date <- "2014-01-02"
  dt <- ymd(date)
  year <- substring(dt,1,4)
  month <- substring(dt,6,7)
  date <- substring(dt,9,10)
  

  drv <- dbDriver("PostgreSQL")
  con <- dbConnect(drv,host='localhost',port='5432',dbname='rbansal')
  query <- paste("select * from electricity_per_hour where dataid = '",dataid,"' and year || month || day <= '",paste(year,month,date,sep=""),"' and usage is not null order by year, month, day, hour",sep = "")
  query
  rs <- dbSendQuery(con,query)
  data <- fetch(rs,n=-1)
  
  #plot(data$usage, type = "l")
  #acf(data$usage)
  #pacf(data$usage)
  
  #ddata <- diff(data$usage)
  #ndifdata <- length(ddata)
  #plot(1:ndifdata,ddata)
  
  #acf(ddata)
  
  data.fit <- arima(data$usage,
                    order=c(1,1,0),
                    seasonal=list(order=c(1,1,0),period=24),
                    include.mean =F)
  #data.fit
  
  data.pred <- predict(data.fit,n.ahead = 24)
  #plot(data$usage,xlim = c(8600,8759), type = "l")
  #plot(data$usage, type = "l")
  #lines(data.pred$pred,col="blue")
  #lines(data.pred$pred + 1.96*data.pred$se,col="red")
  #lines(data.pred$pred - 1.96*data.pred$se,col="red")
  
  predicted_usage <- sum(data.pred$pred)
  predicted_usage <- predicted_usage/60
  
  ### Disconnect from database
  dbDisconnect(con)
  dbUnloadDriver(drv)
  
  rec <- paste("We anticipate that you will usage",round(predicted_usage,3),"kWh of power tomorrow. Can you cut it by 10% and use just",round(predicted_usage*.9,3),"kWh?")
  rec
}

next_day_elec_predict('93',"2014-01-02")
