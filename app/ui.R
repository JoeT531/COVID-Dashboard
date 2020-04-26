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
ui <- navbarPage("COVID19",
                 tabPanel("COVID 19 - AFC Montitoring",
                          tags$style(
                              type = "text/css",
                              ".shiny-output-error { visibility: hidden; }",
                              ".shiny-output-error:before { visibility: hidden; }"
                          ),
                          sidebarLayout(
                              sidebarPanel(leafletOutput("county_map"),
                                           br(),
                                         #  plotlyOutput("county_graph")
                                         ),
                              mainPanel(
                                   fluidRow(
                                             column(12,div(style = "height:225px",
                                                           plotlyOutput("county_graph")))),
                                   fluidRow( column(12,
                                                    column(8,leafletOutput("tract_map")),
                                                    column(4,plotlyOutput("tract_graph")))),
                                 #  tableOutput("cdc_table"),
                                     fluidRow(column(12,offset=4,htmlOutput("Click_bounds")))
                                   # verbatimTextOutput("click_table")
                          ))),
                 tabPanel("Component 2"),
                 tabPanel("Component 3")
)
