getStartOfTimeFrame <- function(date, type) {
  switch(type,
      day = {date},
      week = {date -7},
      month = {date - 30},
      year = {date - 365}
  )
}

## for testing ##
#print(getStartOfTimeFrame(as.Date('2014-07-06', format='%Y-%m-%d'),'day'))
#print(getStartOfTimeFrame(as.Date('2014-07-06', format='%Y-%m-%d'),'week'))
#print(getStartOfTimeFrame(as.Date('2014-07-06', format='%Y-%m-%d'),'month'))
#print(getStartOfTimeFrame(as.Date('2014-07-06', format='%Y-%m-%d'),'year'))