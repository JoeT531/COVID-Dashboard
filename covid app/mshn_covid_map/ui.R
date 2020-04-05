#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building application#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("COVID Map"),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel("CDC Vulnerability Index",
        tableOutput("cdc_table")
        ),
        # Show a plot of the generated distribution
        mainPanel(leafletOutput("map"),
                  verbatimTextOutput("click_table")
                #  renderDataTable("cdc_stats")
                  
        )
    )
))



