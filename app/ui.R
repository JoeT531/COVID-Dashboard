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
ui <- navbarPage("My Application",
                 tabPanel("Component 1",
                          sidebarLayout(
                              sidebarPanel(leafletOutput("map"),
                                           br(),
                                           plotlyOutput("county_graph")),
                              mainPanel(
                                     tableOutput("cdc_table"),
                                     leafletOutput("tract_map"))
                          )),
                 tabPanel("Component 2"),
                 tabPanel("Component 3")
)
