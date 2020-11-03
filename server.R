
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
# Waiter creates a loading screen in shiny
library(waiter)


shinyServer(function(input, output, session) {
  
  session$sendCustomMessage(type="readCookie", message=list())

  observeEvent(input$cookie, {
    # If there's no session token, prompt user to log in
    if (input$cookie == "unauthorized") {
      waiter_update(
        html = tagList(
          img(src = "synapse_logo.png", height = "120px"),
          h3("Looks like you're not logged in!"),
          span("Please ", a("login", href = "https://www.synapse.org/#!LoginPlace:0", target = "_blank"),
               " to Synapse, then refresh this page.")
        )
      )
    } else {
      ### login and update session; otherwise, notify to login to Synapse first
      tryCatch({
        synLogin(sessionToken = input$cookie, rememberMe = FALSE)

        ### update waiter loading screen once login successful
        waiter_update(
          html = tagList(
            img(src = "synapse_logo.png", height = "120px"),
            h3(sprintf("Welcome, %s!", synGetUserProfile()$userName))
          )
        )
        Sys.sleep(2)
        waiter_hide()
      }, error = function(err) {
        Sys.sleep(2)
        waiter_update(
          html = tagList(
            img(src = "synapse_logo.png", height = "120px"),
            h3("Login error"),
            span(
              "There was an error with the login process. Please refresh your Synapse session by logging out of and back in to",
              a("Synapse", href = "https://www.synapse.org/", target = "_blank"),
              ", then refresh this page."
            )
          )
        )

      })

      # Any shiny app functionality that uses synapse should be within the
      # input$cookie observer
      output$title <- renderUI({
        titlePanel(sprintf("Welcome, %s", synGetUserProfile()$userName))
      })
    }
  })

  output$distPlot <- renderPlot({

    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')

  })

})
