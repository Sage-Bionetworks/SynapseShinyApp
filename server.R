
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
library(synapser)

# For testing against staging
PythonEmbedInR::pyExec("syn.setEndpoints(**synapseclient.client.STAGING_ENDPOINTS)")

shinyServer(function(input, output, session) {
  
  session$sendCustomMessage(type="readCookie",
                            message=list(name='org.sagebionetworks.security.user.login.token'))
  
  foo <- observeEvent(input$cookie, {
    
    synLogin(sessionToken=input$cookie)
    
    output$title <- renderUI({
      titlePanel(sprintf("Welcome, %s", synGetUserProfile()$userName))
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
