get_elec_week_comparison <- function(dataid, date) {
  
  library(lubridate)
  library(RPostgreSQL)
  
  source("~/shiny-server/take3/get_start_of_time_frame.R")
  source("~/shiny-server/take3/get_elec_current_week.R")
  source("~/shiny-server/take3/get_elec_prev_week.R")
  
  dataid
  date
  
  # get the current week data
  get_elec_current_week(dataid, date)
  # get the previous week data
  get_elec_prev_week(dataid, date)

  ### TODO: determine if the graph goes here or in the shiny files ###
  
}