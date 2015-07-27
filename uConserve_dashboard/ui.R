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
source("get_carbon_footprint.R")
source("get_user_id.R")

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
      menuItem("Recommendations",tabName = "rec"),
      menuItem("Historical Analysis",tabName = "history")
    )
  )

### Body content
body <-  dashboardBody(
  tabItems(
  tabItem("rec",
  h3(strong(textOutput("user_fname"))),
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
  p(textOutput("lawn_watering")),
  h4(strong("Your Carbon Footprint")),
  p(textOutput("get_carbon_footprint"))
  ),
  tabItem("history",
  p("The graphs below analyze your electricity usage from 2013. See how you compare to your peers of homes of similar size, age,  and population."),
      h4(strong("Overall Usage")),
      imageOutput("img_yearly_usage"),
      imageOutput("img_appliance_breakdown"),  
      h4(strong("Correlating your Electricity Usage with Temperature")),
      imageOutput("img_temp_coeff"),
      imageOutput("img_temp_graph"),  
      h4(strong("Seasonal Breakdown")),
      imageOutput("img_season_breakdown"),
      h4(strong("Breaking down your Day and Weeks")),
      imageOutput("img_day_of_week"),
      imageOutput("img_hour_of_day")
  )
  )
)


ui <- dashboardPage(header, sidebar, body)

server <- function(input, output) {
  output$user_fname <- renderText({
    paste("Welcome back, ",get_user_id(input$user),"!",sep="")
  })
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
    prediction <- get_today_elec_pred(input$user,as.character(end_date))
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
    usage <- get_today_elec_usage(input$user,as.character(input$date))
    valueBox(
      value = formatC(usage, digits = 1, format = "f"),
      subtitle = "kWh used today",
      icon = icon("plug"),
      color = "green"
    )
  })
  output$third_box <- renderValueBox({
    prediction <- get_today_elec_pred(input$user,as.character(input$date))
    valueBox(
      value = formatC(prediction, digits = 1, format = "f"),
      subtitle = "today's kWh prediction",
      icon = icon("plug"),
      color = "red"
    )
  })
  
  output$time_status_plot <- renderPlot({
    data <- peak_times_breakdown(input$user,as.character(input$date))
    barplot(data$pct_usage
            , names.arg = data$peak_status
            , col="darkblue"
            , xlab = "Peak Status"
            , ylab = "% Usage"
            , ylim = c(0.0,1.0)
            , main = "Electricity Usage this Month by Peak Status")
  })
  
  output$bill_predict <- renderText({
    data <- bill_pred(input$user,as.character(input$date))
    tot_usage <- sum(data$usage)
    tot_bill <- sum(data$cost_dollars)
    paste("We ancticipate that you will use about ",round(tot_usage,0)," kWh of power this month for a total cost of $",round(tot_bill,2),".",sep="")
  })
  
  output$get_carbon_footprint <- renderText({
    data <- get_carbon_footprint(as.numeric(input$user))
    #cat(data)
    co2tons <- data
    #cat(co2tons)
    paste("Your current carbon footprint is ",round(as.numeric(co2tons),2)," metric tons CO2/year.",sep="")
  })

  output$img_appliance_breakdown <- renderImage({
    outfile <- paste("/srv/shiny-server/take3/www/2013_",input$user,"_appliance_usage.png",sep="")
    
    list(src = outfile,
    	 contentType = 'image/png',
	 width=450,
	 height=300,
	 alt = "No appliance breakdown available for this ID")
  }, deleteFile = FALSE)

  output$img_yearly_usage <- renderImage({
    outfile <- paste("/srv/shiny-server/take3/www/2013_",input$user,"_total_usage.png",sep="")

    list(src = outfile,
         contentType = 'image/png',
         width=450,
         height=300,
         alt = "No appliance breakdown available for this ID")
  }, deleteFile = FALSE)

  output$img_temp_coeff <- renderImage({
    outfile <- paste("/srv/shiny-server/take3/www/2013_",input$user,"_temp_coeff.png",sep="")

    list(src = outfile,
         contentType = 'image/png',
         width=450,
         height=300,
         alt = "No appliance breakdown available for this ID")
  }, deleteFile = FALSE)

  output$img_temp_graph <- renderImage({
    outfile <- paste("/srv/shiny-server/take3/www/2013_",input$user,"_yearly_usage.png",sep="")

    list(src = outfile,
         contentType = 'image/png',
         width=450,
         height=300,
         alt = "No appliance breakdown available for this ID")
  }, deleteFile = FALSE)

  output$img_hour_of_day <- renderImage({
    outfile <- paste("/srv/shiny-server/take3/www/2013_",input$user,"_dayofhour_usage.png",sep="")

    list(src = outfile,
         contentType = 'image/png',
         width=450,
         height=300,
         alt = "No appliance breakdown available for this ID")
  }, deleteFile = FALSE)

  output$img_day_of_week <- renderImage({
    outfile <- paste("/srv/shiny-server/take3/www/2013_",input$user,"_dayofweek_usage.png",sep="")

    list(src = outfile,
         contentType = 'image/png',
         width=450,
         height=300,
         alt = "No appliance breakdown available for this ID")
  }, deleteFile = FALSE)

  output$img_season_breakdown <- renderImage({
    outfile <- paste("/srv/shiny-server/take3/www/2013_",input$user,"_seasonal_usage.png",sep="")

    list(src = outfile,
         contentType = 'image/png',
         width=450,
         height=300,
         alt = "No appliance breakdown available for this ID")
  }, deleteFile = FALSE)
}

shinyApp(ui, server)
