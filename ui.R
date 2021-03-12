
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
# This interface has been modified to be used specifically on Sage Bionetworks Synapse pages
# to log into Synapse as the currently logged in user from the web portal using the session token.
#
# https://www.synapse.org

library(shiny)

ui <- fluidPage(
  # Application title
  titlePanel("title"),
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    # Sidebar with a slider input
    # Google chrome not showing sliders correctly
    sidebarPanel(
      sliderInput("obs",
                  "Number of observations:",
                  min = 0,
                  max = 1000,
                  value = 500)
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
)

uiFunc <- function(req) {
  if (!has_auth_code(parseQueryString(req$QUERY_STRING))) {
    authorization_url = oauth2.0_authorize_url(api, app, scope = scope)
    return(tags$script(HTML(sprintf("location.replace(\"%s\");",
                                    authorization_url))))
  } else {
    ui
  }
}
