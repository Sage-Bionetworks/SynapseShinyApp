
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
# This server has been modified to be used specifically on Sage Bionetworks Synapse pages
# to log into Synapse as the currently logged in user from the web portal using the session token.
#
# https://www.synapse.org

library(shiny)
library(synapseClient)

shinyServer(function(input, output, session) {

  foo <- observe({
    
    r <- httr::GET("https://staging.synapse.org/Portal/sessioncookie")
    
    if (r$status_code == 200) {
      synapseLogin(sessionToken=r$content)
    }
    
    output$title <- renderUI({
      titlePanel(sprintf("Welcome, %s", synGetUserProfile()@userName))
    })
    
    output$distPlot <- renderPlot({
      
      # generate bins based on input$bins from ui.R
      x    <- faithful[, 2]
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      
      # draw the histogram with the specified number of bins
      hist(x, breaks = bins, col = 'darkgray', border = 'white')
      
    })
  })    
})
