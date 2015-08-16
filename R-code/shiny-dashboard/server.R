options(scipen=999)

shinyServer(function(input, output) {
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
  output$temp_string <- renderText({
    temp <- as.numeric(get_current_temperature(as.character(input$date)))
    paste("Today's temperature in Austin, TX: ",round(temp,1)," F",sep = "")
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
    pct_change <- compare_today_yesterday_usage(input$user,as.character(input$date))
    col <- "red"
    icon_select <- "arrow-up"
    if(pct_change == 0)
    {
      col <- "yellow"
    }
    if(pct_change < 0)
    {
      col <- "green"
      icon_select <- "arrow-down"
    }
    valueBox(
      value = formatC(pct_change, digits = 1, format = "f"),
      subtitle = "% change from yesterday",
      icon = icon(icon_select),
      color = col
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
      color = "green"
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
  
  output$carbon_footprint_box <- renderValueBox({
    data <- get_carbon_footprint(as.numeric(input$user))
    valueBox(
      value = formatC(data, digits = 1, format = "f"),
      subtitle = "metric tons CO2/yr",
      icon = icon("cloud"),
      color = "black"
    )
  })
  output$trees_box <- renderValueBox({
    data <- get_carbon_footprint(as.numeric(input$user))
    trees <- data/0.039
    valueBox(
      value = formatC(trees, digits = 0, format = "f"),
      subtitle = "trees to offset your footprint",
      icon = icon("tree"),
      color = "green"
    )
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
  output$elec_pred <- renderValueBox({
    start_date <- ymd(input$date)
    end_date <- start_date + days(1)
    prediction <- get_today_elec_pred(input$user,as.character(end_date))
    valueBox(
      value = formatC(prediction, digits = 1, format = "f"),
      subtitle = "predicted kWh tomorrow",
      icon = icon("plug"),
      color = "green"
    )
  })
  output$elec_pred_goal <- renderValueBox({
    start_date <- ymd(input$date)
    end_date <- start_date + days(1)
    prediction <- get_today_elec_pred(input$user,as.character(end_date))
    prediction <- prediction*.9
    valueBox(
      value = formatC(prediction, digits = 1, format = "f"),
      subtitle = "kWh goal, 10% reduction",
      icon = icon("leaf"),
      color = "green"
    )
  })
  output$elec_pred_goal_potential_savings <- renderValueBox({
    start_date <- ymd(input$date)
    end_date <- start_date + days(1)
    prediction <- get_today_elec_pred(input$user,as.character(end_date))
    goal <- prediction*.9
    dollars <- .12*(prediction-goal)
    valueBox(
      value = formatC(dollars, digits = 2, format = "f"),
      subtitle = "$, potential savings",
      icon = icon("money"),
      color = "green"
    )
  })
  output$bill_predict_usage <- renderValueBox({
    data <- bill_pred(input$user,as.character(input$date))
    tot_usage <- sum(data$usage)
    valueBox(
      value = formatC(tot_usage, digits = 1, format = "f"),
      subtitle = "kWh prediction",
      icon = icon("plug"),
      color = "green"
    )
  })
  output$bill_predict_money <- renderValueBox({
    data <- bill_pred(input$user,as.character(input$date))
    tot_bill <- sum(data$cost_dollars)
    valueBox(
      value = formatC(tot_bill, digits = 2, format = "f"),
      subtitle = "$ prediction",
      icon = icon("money"),
      color = "green"
    )
  })
  output$water_rec <- renderValueBox({
    rec <- water_rec(as.character(input$date))
    text <- "YES"
    col <- "green"
    if(nrow(rec) > 0)
    {
      text <- "NO"
      col <- "red"
    }
    valueBox(
      value = formatC(text, digits = 2, format = "f"),
      subtitle = "water lawn?",
      icon = icon("rain"),
      color = col
    )
  })
  output$water_user_fname <- renderText({
    paste("Welcome back, ",get_user_id(input$user),"!",sep="")
  })
  output$water_date_string <- renderText({
    start_date <- ymd(as.character(input$date))
    dt <- start_date
    year <- substring(dt,1,4)
    date <- substring(dt,9,10)
    day <- wday(start_date, label=T, abbr=F)
    paste(day,", ",month(start_date,label = T,abbr=F)," ",date,", ",year,sep = "")
  })
  output$water_temp_string <- renderText({
    temp <- as.numeric(get_current_temperature(as.character(input$date)))
    paste("Today's temperature in Austin, TX: ",round(temp,1)," F",sep = "")
  })
  output$water_today_usage <- renderValueBox({
    usage <- get_today_water_usage(input$user,as.character(input$date))
    valueBox(
      value = formatC(usage, digits = 0, format = "f"),
      subtitle = "gallons used today",
      icon = icon("tint"),
      color = "green"
    )
  })
  output$water_temp <- renderValueBox({
    pct_change <- water_compare_today_yesterday_usage(input$user,as.character(input$date))
    col <- "red"
    icon_select <- "arrow-up"
    if(pct_change == 0)
    {
      col <- "yellow"
    }
    if(pct_change < 0)
    {
      col <- "green"
      icon_select <- "arrow-down"
    }
    valueBox(
      value = formatC(pct_change, digits = 1, format = "f"),
      subtitle = "% change from yesterday",
      icon = icon(icon_select),
      color = col
    )
  })
  output$water_third_box <- renderValueBox({
    pred <- get_today_water_pred(input$user,as.character(input$date))
    valueBox(
      value = formatC(pred, digits = 0, format = "f"),
      subtitle = "today's gallons prediction",
      icon = icon("tint"),
      color = "green"
    )
  })
  output$water_tomorrow_pred <- renderValueBox({
    start_date <- ymd(input$date)
    end_date <- start_date + days(1)
    prediction <- get_today_water_pred(input$user,as.character(end_date))
    valueBox(
      value = formatC(prediction, digits = 0, format = "f"),
      subtitle = "tomorrow's gallons prediction",
      icon = icon("tint"),
      color = "green"
    )
  })
  output$water_tomorrow_goal <- renderValueBox({
    start_date <- ymd(input$date)
    end_date <- start_date + days(1)
    prediction <- get_today_water_pred(input$user,as.character(end_date))
    prediction <- prediction*.9
    valueBox(
      value = formatC(prediction, digits = 0, format = "f"),
      subtitle = "gallons goal, 10% reduction",
      icon = icon("leaf"),
      color = "green"
    )
  })
  output$days_compare <- renderPlot({
    data <- print_date_comparison_graph(input$user,as.character(input$date),input$n)
    plot(data$usage_2014
         , type = "l"
         , xlab = "Date"
         , ylab = "Usage, kWh"
         , main = "Comparing to Last Year"
         , ylim = c(20, 150)
         , col = "blue"
         , xaxt = "n")
    axis(1,at=1:input$n, labels=data$display_date)
    legend("topright", title = "Year", c("2014","2013"), fill = c("blue","black"))
    lines(data$usage_2013)
  })
  output$weeks_compare <- renderPlot({
    data <- print_week_comparison_graph(input$user,as.character(input$date),input$n)
    #data <- print_week_comparison_graph('5357','2014-07-13',10)
    #data
    plot(data$usage_2014
         , type = "l"
         , xlab = "Week Starting"
         , ylab = "Usage, kWh"
         , main = "Comparing to Last Year"
         , ylim = c(0,1000)
         , col = "blue"
         , xaxt = "n")
    axis(1,at=1:nrow(data), labels=data$display_date)
    legend("topright", title = "Year", c("2014","2013"), fill = c("blue","black"))
    lines(data$usage_2013)
  })
})