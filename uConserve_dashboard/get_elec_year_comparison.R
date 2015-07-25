get_elec_year_comparison <- function(dataid, date) {
  
  library(lubridate)
  library(RPostgreSQL)
  
  source("~/shiny-server/take3/get_start_of_time_frame.R")
  source("~/shiny-server/take3/get_elec_current_yr.R")
  source("~/shiny-server/take3/get_elec_prev_yr.R")

  dataid
  date

  # get the current year data
  get_elec_current_yr(dataid, date)
  # get the previous year data
  get_elec_prev_yr(dataid, date)
  
  ### TODO: determine if the graph goes here or in the shiny files ###

}