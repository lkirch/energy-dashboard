## ui.R ##
library(shinydashboard)
#library(weatherData)

source("/Users/rbansal/Documents/Berkeley MIDS/W210/Project/uConserve_dashboard2/precip_prediction.R")
source("/Users/rbansal/Documents/Berkeley MIDS/W210/Project/uConserve_dashboard2/arima_elec_predict.R")
source("/Users/rbansal/Documents/Berkeley MIDS/W210/Project/uConserve_dashboard2/get_user_names.R")
source("/Users/rbansal/Documents/Berkeley MIDS/W210/Project/uConserve_dashboard2/get_current_temperature.R")
source("/Users/rbansal/Documents/Berkeley MIDS/W210/Project/uConserve_dashboard2/get_today_elec_usage.R")

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
      dateInput("date","Select the date",value="2014-01-01")
    )
  )

### Body content
body <-  dashboardBody(
  h3("Welcome back, Rahul!"),
  p(textOutput("date_string")),
  p("Your uConserve Dashboard will help you understand you resource
    consumption and give you easy-to-implement recommendations on how 
    you can start to conserve. Enjoy!"),
  fluidRow(
    valueBoxOutput("temp"),
    valueBoxOutput("today_usage"),
    valueBoxOutput("third_box")
  ),
  h4(textOutput("lawn_watering")),
  h4(textOutput("elec_predict"))
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
    next_day_elec_predict('93',as.character(input$date))
    #"place holder for electricity prediction"
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
      color = "yellow"
    )
  })
  output$third_box <- renderValueBox({
    valueBox(
      value = formatC(15.0, digits = 1, format = "f"),
      subtitle = "blah blah blah",
      icon = icon("lightbulb-o"),
      color = "yellow"
    )
  })
  
}

shinyApp(ui, server)
