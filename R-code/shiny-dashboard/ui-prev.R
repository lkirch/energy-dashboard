## ui.R ##
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
                  choices = names$full_name),
      dateInput("date","Select the date",value="2014-07-13",min="2014-07-01",max="2014-07-30")
    )
  )

### Body content
body <-  dashboardBody(
  h3(strong("Welcome back, Rahul!")),
  p(textOutput("date_string")),
  p("Your uConserve Dashboard will help you understand you resource
    consumption and give you easy-to-implement recommendations on how 
    you can start to conserve. Enjoy!"),
  fluidRow(
    valueBoxOutput("temp"),
    valueBoxOutput("today_usage"),
    valueBoxOutput("third_box")
  ),
  h4(strong("Tomorrow's Electricity Usage Prediction")),
  p(textOutput("elec_predict")),
  h4(strong("End-of-Month Bill Prediction")),
  p(textOutput("bill_predict")),
  h4(strong("Electricity Usage Breakdown")),
  plotOutput("time_status_plot",width = 400, height = 300),
  p("You can save money by shifting non-essential electricity usage to off-peak hours."),
  h4(strong("Lawn Watering Recommendation")),
  p(textOutput("lawn_watering"))
)


ui <- dashboardPage(header, sidebar, body)

server <- function(input, output) {
  output$date_string <- renderText({
    start_date <- ymd(as.character(input$date))
    dt <- start_date
    year <- substring(dt,1,4)
    date <- substring(dt,9,10)
    day <- wday(start_date, label=T, abbr=F)
    paste(day,", ",month(start_date,label = T,abbr=F)," ",date,", ",year,sep = "")
  })
  output$lawn_watering <- renderText({
    rec <- water_lawn_pred(as.character(input$date))
  })
  output$elec_predict <- renderText({
    start_date <- ymd(input$date)
    end_date <- start_date + days(1)
    prediction <- get_today_elec_pred('93',as.character(end_date))
    paste("Based on your usage pattern, we anticipate that you will use about",round(prediction,1),"kWh of power tomorrow. Can you cut it by 10% and use just",round(prediction*.9,0),"kWh?")
  })
  output$temp <- renderValueBox({
    temp <- get_current_temperature(as.character(input$date))
    valueBox(
      value = formatC(temp, digits = 1, format = "f"),
      subtitle = "degrees F",
      icon = icon("sun-o"),
      color = "yellow"
    )
  })
  output$today_usage <- renderValueBox({
    usage <- get_today_elec_usage(as.character(input$date))
    valueBox(
      value = formatC(usage, digits = 1, format = "f"),
      subtitle = "kWh used today",
      icon = icon("plug"),
      color = "green"
    )
  })
  output$third_box <- renderValueBox({
    prediction <- get_today_elec_pred('93',as.character(input$date))
    valueBox(
      value = formatC(prediction, digits = 1, format = "f"),
      subtitle = "today's kWh prediction",
      icon = icon("plug"),
      color = "red"
    )
  })
  
  output$time_status_plot <- renderPlot({
    data <- peak_times_breakdown('93',as.character(input$date))
    barplot(data$pct_usage
            , names.arg = data$peak_status
            , col="darkblue"
            , xlab = "Peak Status"
            , ylab = "% Usage"
            , ylim = c(0.0,1.0)
            , main = "Electricity Usage this Month by Peak Status")
  })
  
  output$bill_predict <- renderText({
    data <- bill_pred('93',as.character(input$date))
    tot_usage <- sum(data$usage)
    tot_bill <- sum(data$cost_dollars)
    paste("We ancticipate that you will use about ",round(tot_usage,0)," kWh of power this month for a total cost of $",round(tot_bill,2),".",sep="")
  })
  
}

shinyApp(ui, server)
