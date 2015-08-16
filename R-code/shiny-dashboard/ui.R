## ui.R ##
library(shiny)
library(shinydashboard)
library(lubridate)
library(dygraphs)
library(dplyr)
library(xts)

source("precip_prediction.R")
source("arima_elec_predict.R")
source("get_user_names.R")
source("get_current_temperature.R")
source("get_today_elec_usage.R")
source("get_today_elec_prediction.R")
source("peak_usage_breakdown.R")
source("end_of_month_bill_pred.R")
source("get_carbon_footprint.R")
source("get_user_id.R")
source("compare_today_yesterday_usage.R")
source("water_rec.R")
source("get_today_water_usage.R")
source("get_today_water_pred.R")
source("water_compare_today_yesterday_usage.R")
source("graph.R")
source("graph_week.R")

names <- get_user_names()

### Header content
header <- dashboardHeader(
  title = "uConserve"
)

### Sidebar content
sidebar <-  dashboardSidebar(
    sidebarMenu(
      selectInput("user", 
                  "Select the user",
                  choices = names$id),
      dateInput("date","Select the date",value="2014-07-14",min="2014-07-01",max="2014-07-30"),
      menuItem("Electricity",tabName = "rec"),
      menuItem("Water",tabName = "history")
    )
)

### Body content
body <-  dashboardBody(
  tabItems(
  tabItem("rec",
  h3(strong(textOutput("user_fname"))),
  p(textOutput("date_string")),
  p(textOutput("temp_string")),
  h4(strong("Today")),
  fluidRow(
    valueBoxOutput("today_usage"),
    valueBoxOutput("temp"),
    valueBoxOutput("third_box")
  ),
  h4(strong("Tomorrow")),
  fluidRow(
    valueBoxOutput("elec_pred"),
    valueBoxOutput("elec_pred_goal"),
    valueBoxOutput("elec_pred_goal_potential_savings")
  ),
  h4(strong("End-of-Month")),
  fluidRow(
    valueBoxOutput("bill_predict_usage"),
    valueBoxOutput("bill_predict_money")
  ),
  h4(strong("Your Carbon Footprint")),
  fluidRow(
    valueBoxOutput("carbon_footprint_box"),
    valueBoxOutput("trees_box"),
    p("This calculation is based on households similar to yours")
  ),
  h4(strong("Trend Charts")),
  p("See how you compare against your usage last year within a given time interval!"),
  fluidRow(
    sidebarPanel(
      selectInput('time_frame', 'Time Frame', c("Days","Weeks")),
      sliderInput('n', 'Number of Units', min = 1, max = 14, value = 7)
    ),
    mainPanel(
      conditionalPanel(
        condition = "input.time_frame == \"Days\"",
        plotOutput("days_compare")
      ),
      conditionalPanel(
        condition = "input.time_frame == \"Weeks\"",
        plotOutput("weeks_compare")
      )
    )
  ),
  h4(strong("Electricity Usage Breakdown")),
  p("During the summer time in Austin, TX, utility companies raise rates during heavy use hours. If you can shift your electricity consumption away from these peak price hours, you can save a significant amount of money. Here is how your electricity usage this month breaks out into the different pricing levels."),
  p("* 6 AM - 2 PM: $0.071/kWh (Mid-Peak)"),
  p("* 2 PM - 8 PM: $0.122/kWh (High-Peak)"),
  p("* 8 PM - 10 PM: $0.072/kWh (Mid-Peak)"),
  p("* 10 PM - 6 AM: $0.022/kWh (Off-Peak)"),
  plotOutput("time_status_plot",width = 400, height = 300),
  p("You can save money by shifting non-essential electricity usage to off-peak hours.")
  ),
  tabItem("history",
  h3(strong(textOutput("water_user_fname"))),
  p(textOutput("water_date_string")),
  p(textOutput("water_temp_string")),
  h4(strong("Today")),
  fluidRow(
    valueBoxOutput("water_today_usage"),
    valueBoxOutput("water_temp"),
    valueBoxOutput("water_third_box")
  ),
  h4(strong("Tomorrow")),
  fluidRow(
    valueBoxOutput("water_tomorrow_pred"),
    valueBoxOutput("water_tomorrow_goal")
  ),
  h4(strong("Lawn Watering Recommendation")),
  fluidRow(
    valueBoxOutput("water_rec"),
    p(textOutput("lawn_watering"))
  )  
  )
  )
)


ui <- dashboardPage(header, sidebar, body)


#shinyApp(ui, server, options = list(height="1000"))
