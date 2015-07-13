options(scipen=999)

shinyServer(function(input, output) {
  
  output$enterprise_owned <- renderText({
    revenue_owned <- input$price_per_space*input$num_spaces*input$rev_share_own[1]*input$events_own+input$license_own
    paste("$",revenue_owned)
  })
  
  output$enterprise_acquired <- renderText({
    revenue_acquired <- input$rev_after_garage*input$num_txns*input$rev_share_acq[1]*input$events_acq + input$license_acq
    paste("$",revenue_acquired)
  })
  
  output$community <- renderText({
    rev_hosts <- input$num_hosts*input$monthly_fee*12
    rev_parkers <- input$price_per_hr*input$hrs*input$parkers_per_wk*input$txn_rev[1]
    total_rev <- rev_hosts + rev_parkers
    paste("$",total_rev)
  })
  
})