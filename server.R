
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
library(reticulate)
library(waiter)

reticulate::use_condaenv("synapse")
synapseclient <- import('synapseclient')

shinyServer(function(input, output, session) {
  syn <- synapseclient$Synapse()
  # clicking on the 'Log in' button will kick off the OAuth round trip
  # observeEvent(input$action, {
  access_token <- NULL
  if (is.null(access_token)) {
    print(access_token)
    session$sendCustomMessage("mymessage",
                              oauth2.0_authorize_url(api, app, scope = scope))
  #   return()
  # }
    #  


    # return()
  # })
  
    params <- parseQueryString(isolate(session$clientData$url_search))
    print(params)
    if (!has_auth_code(params)) {
      return()
    }
    url<-paste0(api$access, '?', 'redirect_uri=', APP_URL, '&grant_type=',
                'authorization_code' ,'&code=', params$code)
    # get the access_token and userinfo token
    req <- POST(url,
                encode = "form",
                body = '',
                authenticate(app$key, app$secret, type = "basic"),
                config = list())
    stop_for_status(req, task = "get an access token")
    token_response <-content(req, type = NULL)
    access_token<-token_response$access_token
    syn$login(authToken=access_token)
    waiter_update(
      html = tagList(
        img(src = "synapse_logo.png", height = "120px"),
        h3(sprintf("Welcome, %s!", syn$getUserProfile()$userName))
      )
    )
    print(access_token)
    return()
  }
  # print(access_token)

  # 
  

# 
#   session$sendCustomMessage(type="readCookie", message=list())
#   observeEvent(input$cookie, {
# 
#     ### login and update session; otherwise, notify to login to Synapse first
#     tryCatch({
#       syn$login(sessionToken = input$cookie, rememberMe = FALSE)
# 
#       ### update waiter loading screen once login successful
#       waiter_update(
#         html = tagList(
#           img(src = "synapse_logo.png", height = "120px"),
#           h3(sprintf("Welcome, %s!", syn$getUserProfile()$userName))
#         )
#       )
#       Sys.sleep(2)
#       waiter_hide()
#     }, error = function(err) {
#       Sys.sleep(2)
#       waiter_update(
#         html = tagList(
#           img(src = "synapse_logo.png", height = "120px"),
#           h3("Looks like you're not logged in!"),
#           span("Please ", a("login", href = "https://www.synapse.org/#!LoginPlace:0", target = "_blank"),
#                " to Synapse, then refresh this page.")
#         )
#       )
#     })
  # })

  output$distPlot <- renderPlot({

    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')

  })
})
