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
shinyUI(
    fluidPage(
        fluidRow(
       column(width = 12,div(style = "height:50px;background-color: grey;", "title")),
 #   fluidRow(
          column(width = 4,div(style = "height:50px;background-color: lightblue;"),
                   fluidRow(
                    column(10,offset = 1,tags$style(type = "text/css", "html, body {width:100%; height:100%}"),
                           
                           leafletOutput("map")),
                    column(10,offset = 1,
                           div(style = "height:250px;background-color: grey;",plotlyOutput("county_graph")))
                       
                   )),
             column(width = 8,
                        fluidRow(
                            column(12,tableOutput("cdc_table")),
                            column(12,leafletOutput("tract_map")),
                        )),
    
            ),
    
    hr(),
    fluidRow(column(12,div(style = "height:50px;background-color: grey;", "title")))
    ))


