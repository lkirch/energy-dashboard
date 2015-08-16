get_elec_year_comparison <- function(dataid, date) {
  
  library(lubridate)
  library(RPostgreSQL)
  
  source("get_start_of_time_frame.R")
  source("get_elec_current_year.R")
  source("get_elec_prev_year.R")

  # get the current year data
  curr <- get_elec_current_year(dataid, date)
  # get the previous year data
  prev <- get_elec_prev_year(dataid, date)
  
  ### TODO: determine if the graph goes here or in the shiny files ###

}
