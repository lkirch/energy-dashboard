get_elec_day_comparison <- function(dataid, date) {
  
  library(lubridate)
  library(RPostgreSQL)
  
  source("~/shiny-server/take3/get_start_of_time_frame.R")
  source("~/shiny-server/take3/get_elec_current_day.R")
  source("~/shiny-server/take3/get_elec_prev_day.R")
  
  dataid
  date
  
  # get the current day data
  get_elec_current_day(dataid, date)
  # get the previous day data
  get_elec_prev_day(dataid, date)
  
  ### TODO: determine if the graph goes here or in the shiny files ###
  
}