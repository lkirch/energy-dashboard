## cleaning_script.R
## ingest and clean data from Pecan Street per minute egauge dataset

install.packages("lubridate")
install.packages("dplyr")

library(lubridate)
library(dplyr)

files <- list.files(pattern="2014-elec*", full.names=T, recursive=FALSE)
files

### setting directory
setwd("C:/GitHub/energy-dashboard/data")
list.files()

getwd()

lapply(files,sum_by_hour)

sum_by_hour <- function(x) {

  ### reading in the dataset
  data6673 <- read.table(x,sep = ";",header = T)
  
  ### creating time chunk variables
  data6673$year <- year(data6673$localminute)
  data6673$month <- month(data6673$localminute)
  data6673$day <- day(data6673$localminute)
  data6673$hour <- hour(data6673$localminute)
  data6673$min <- minute(data6673$localminute)
  data6673$day_of_week <- wday(data6673$localminute,label=T,abbr=T)
    
  set_weekday <- function(day_of_week) {
    if(day_of_week == "Mon" ||
         day_of_week == "Tues" ||
         day_of_week == "Wed" ||
         day_of_week == "Thurs" || 
         day_of_week == "Fri") {
      return(1)
      }
    else {
      return(0)
      }
  }  
  
  data6673$weekday <- lapply(data6673$day_of_week,set_weekday)
  data6673$weekday <- as.numeric(data6673$weekday)
  
  ### Diagnostics to make sure that all worked
  #table(data6673$day_of_week,data6673$weekday)
  #head(data6673)
  
  by_hour <- group_by(data6673,dataid,year,month,day,weekday,hour)
  usage_by_hour <- summarise(by_hour,
            usage = sum(use))
  
  ### average usage by hour of day across all days in 2013
  #head(usage_by_hour)
  write.csv(usage_by_hour,paste("C:/Berkeley MIDS/W210/Project/",substr(x,3,100)))
}
  


plot(by(usage_by_hour$usage,usage_by_hour$hour,mean))

usage_by_hour_weekday <- filter(usage_by_hour, weekday == 1)
usage_by_hour_weekend <- filter(usage_by_hour, weekday == 0)

### average usage by hour of day divided up into weekdays and weekends
plot(by(usage_by_hour_weekday$usage, usage_by_hour_weekday$hour,mean))
plot(by(usage_by_hour_weekend$usage, usage_by_hour_weekend$hour,mean))


### looking at seasons
