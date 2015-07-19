library(lubridate)
library(dplyr)
library(data.table)
library("ggplot2", lib.loc="~/Library/R/3.0/library")
library(xts)
library(dygraphs)
library(htmlwidgets)

setwd("~/W210-R-analysis/data/raw")
getwd()

data6673 <-read.table("data6673.csv", sep=",", header=T)

dt <- data.table(data6673, key=c("year","month","day","hour"))

dt[,sum(use),by=c("year","month","day","hour")]
dt[,sum(use),by=c("year")]
dt[,sum(use),by=c("year","month")]
dtmonthly <- dt[,sum(use),by=c("year","month")]

# rename V1 to usage
names(dtmonthly)[names(dtmonthly) == 'V1'] <- 'Usage'
# break up into 2 timeseries
this_yr <-subset(dtmonthly, select = c(month, Usage), year==2014)
last_yr <-subset(dtmonthly, select = c(month, Usage), year==2013)
# timeseries
tslast <- ts((this_yr), start=c(2014,1),frequency=12)
tscurrent <- ts((last_yr), start=c(2014,1),frequency=12)
elec_usage <- cbind(tslast, tscurrent)

### Show all the colour schemes available
# display.brewer.all()

#the axis label is passed as a date, this function outputs only the month of the date
getMonth <- 'function(d){
               var monthNames = ["January", "February", "March", "April", "May", "June","July", "August", "September", "October", "November", "December"];
               return monthNames[d.getMonth()];
               }'

#the x values are passed as milliseconds, turn them into a date and extract month and day
getMonthDay <- 'function(d) {
               var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun","Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
               date = new Date(d);
               return monthNames[date.getMonth()] + " " +date.getUTCDate(); }'

dygraph(elec_usage, main="Your Electricity Consumption by Year",ylab="Usage (kwh)") %>%
  dySeries("tslast.Usage", label = "2013 Usage", color="blue") %>%
  dySeries("tscurrent.Usage", label = "2014 Usage", color="red") %>% 
  dyRangeSelector(dateWindow = c("2014-01-01", "2014-12-31"))    


