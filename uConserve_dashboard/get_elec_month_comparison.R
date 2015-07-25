get_elec_month_comparison <- function(dataid, date) {
  
  library(lubridate)
  library(RPostgreSQL)
  
  source("~/shiny-server/take3/get_start_of_time_frame.R")
  source("~/shiny-server/take3/get_elec_current_month.R")
  source("~/shiny-server/take3/get_elec_prev_month.R")
  
  dataid
  date
  
  # get the current month data
  get_elec_current_month(dataid, date)
  # get the previous month data
  get_elec_prev_month(dataid, date)

  ### TODO: determine if the graph goes here or in the shiny files ###
  
}