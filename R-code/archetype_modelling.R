### First analysis 
setwd("C:/Berkeley MIDS/W210/Project/")
list.files()

install.packages("numDeriv")
library(numDeriv)
library(ggplot2)

files <- list.files(pattern="2014-elec*", full.names=T, recursive=FALSE)
data <- data.frame()
#remove(data)

for(x in files){
  print(x)
  d <- read.csv(x,header=T)
  data <- rbind(d,data)
}

table(data$dataid)

head(data)

summary(data$usage)
table(data$hour)

### overall plot
plot(by(data$usage,data$hour,mean, na.rm= T))


by_hour <- group_by(data,dataid,hour)

table(usage_by_hour$dataid)

usage_by_hour$dataid <- as.factor(usage_by_hour$dataid)

subset(usage_by_hour,usage_by_hour$usage >= 200)

# dot plots
qplot(data=usage_by_hour
      , x=usage_by_hour$hour
      , y=usage_by_hour$usage
      , color=usage_by_hour$dataid
      , size=20)

# smoothed lines
qplot(data=usage_by_hour
      , x=usage_by_hour$hour
      , y=usage_by_hour$usage
      , color=usage_by_hour$dataid
      , geom=c("smooth"))


ubh222 <- subset(usage_by_hour,usage_by_hour$dataid ==222)

qplot(ubh222$hour,ubh222$usage)
qplot(ubh222$hour,ubh222$usage) + geom_smooth(method = "auto",se=F)

help(geom_smooth)

ss <- smooth.spline(ubh222$hour,ubh222$usage)
pred <- predict(ss)
plot(ubh222$hour,ubh222$usage)
lines(pred,col=2)

### first derivative
help(diff)
u.prime <- diff(ubh222$usage)/diff(ubh222$hour)
pred.prim <- predict(ss,deriv=1)

plot(u.prime)
lines(pred.prim$y,col=2)


### second derivative

help(predict)
u.prime.prime <- diff(u.prime)
pred.prim.prim <- predict(ss,deriv=2)




plot(u.prime.prime)
lines(pred.prim$y,col=2)

ids <- unique(usage_by_hour$dataid)
ids

u.sec.deriv <- data.frame()
#remove(u.sec.deriv)
remove(ubh)

for (i in ids) {
  ubh <- subset(usage_by_hour,usage_by_hour$dataid == i)
  u.prime <- diff(ubh$usage)/diff(ubh$hour)
  u.prime.prime <- diff(u.prime)
  
  u.sec.deriv <- rbind(u.sec.deriv,cbind(i,c(1:length(u.prime.prime)),u.prime.prime))
}

u.sec.deriv$u.prime.prime <- as.numeric(u.sec.deriv$u.prime.prime)
u.sec.deriv$V2 <- as.numeric(u.sec.deriv$V2)


summary(u.sec.deriv$u.prime.prime)

qplot(data=u.sec.deriv
      , x=u.sec.deriv$V2
      , y=u.sec.deriv$u.prime.prime
      , color=u.sec.deriv$i
      , geom = c("smooth"))
