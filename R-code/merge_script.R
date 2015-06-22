getwd()
setwd("C:/Berkeley MIDS/W210/Project/")
list.files()

data <- data.frame()
files <- list.files(pattern = " 2014-elec*",full.names = T)

for (x in files) {
  temp <- read.csv(x,header=T)
  data <- rbind(data,temp)
}

library(lubridate)
head(data)
data$date <- ymd(paste(data$year,data$month,data$day))
data$datetime <- ymd_hms(paste(data$year,data$month,data$day,data$hour,'00','00'))


write.csv(data,"full_2014_elec_data.csv")


sum_by_user_month <- aggregate(data$usage,by=list(data$dataid,data$month),sum, na.rm=T)
names(sum_by_user_month) <- c("dataid","month","usage")
sum_by_user_date <- aggregate(data$usage,by=list(data$dataid,data$date),sum, na.rm=T)
names(sum_by_user_date) <- c("dataid","date","usage")

avg_by_month <- aggregate(sum_by_user_month$usage,by=list(sum_by_user_month$month),mean)
names(avg_by_month) = c("month","avg_usage")


head(sum_by_user_month)
sum_by_month_187 <- subset(sum_by_user_month,dataid == "187")

### average usage of all users  by month
qplot(data=avg_by_month
      , x=avg_by_month$month
      , y=avg_by_month$avg_usage
      , size = 10)

qplot(data=avg_by_month
      , x=avg_by_month$month
      , y=avg_by_month$avg_usage
      , size = 2
      , geom=c("smooth"))


### comparing 187 to the average usage pattern over the year
month_compare <- rbind(avg_by_month,sum_by_month_187)
names(sum_by_month_187) <- c("dataid","month","avg_usage")

qplot(data=month_compare
      , x=month_compare$month
      , y=month_compare$avg_usage
      , size = 20
      , color = month_compare$dataid)

qplot(data=month_compare
      , x=month_compare$month
      , y=month_compare$avg_usage
      , size = 2
      , color = month_compare$dataid
      , geom=c("smooth"))
