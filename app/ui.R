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
                          fluidRow(
                            column(3,wellPanel(
                                p("use the below to filter counties to tracts"),
                                leafletOutput("county_map"),
                                           br(),
                                        p("Data for country level cases is taken from
                                          the New York times and allows")
                                         )),
                          
                            column(9,
                                   fluidRow(
                                             column(12,div(style = "height:240px",
                                                           p("county stats"),
                                                           plotlyOutput("county_graph")))),
                                   fluidRow(column(12,div(style = "height:25px",  wellPanel(style = "padding: .5px;")
                                                                                            
                                                                                            ))),
                                   fluidRow( column(12,
                                                    column(8,leafletOutput("tract_map")),
                                                    column(4,plotlyOutput("tract_graph")))),
                                 #  tableOutput("cdc_table"),
                                #     fluidRow(column(12,offset=4,htmlOutput("Click_bounds")))
                                   # verbatimTextOutput("click_table")
                          )),
                          fluidRow(column(12,div(style = "height:1px",
                                         # tags$img(src = 'NewYorkTimes_Logo.png',width = '200px'),
                                          tags$img(src = 'tbd_logo.png', width = "200px", 
                                                                 align = "center"),
                                         # tags$img(src = 'CDC-logo.png',width = '70px',height = '50px')
                                                                                              
                          )))),
                 tabPanel("Component 2"),
                 tabPanel("Component 3")
)
