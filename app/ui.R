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
                                p("County mapping is shaded based on the total number of 
                                  reported cases per 10K of the population. Click on a county 
                                  to see daily case projections through the summer and zoom in 
                                  on tract data and see which AFC's belong to particularly 
                                  vulnerable neighborhoods"),
                                leafletOutput("county_map"),
                                br(),
                                     #   tags$ul(
                                    #      "COVID Cases updated daily from data 
                                    #       collected by the New York Times (embed link).")
                                      #    tags$li("Social Vulnerability provided by the CDC ")
                                      #    
                                        ),

                            tags$img(src = 'tbd_logo.png', width = "200px", 
                                     align = "center")),
                          
                            column(9,
                                   fluidRow(
                                             column(12,div(style = "height:225px",
                                                      #     p("county stats"),
                                                           plotlyOutput("county_graph")))),
                                   fluidRow(column(12,div(style = "height:25px",  wellPanel(style = "padding: .5px;")
                                                                                            
                                                                                            ))),
                                   fluidRow( column(12,
                                                    column(8,leafletOutput("tract_map")),
                                                    column(4,plotlyOutput("tract_graph")))),
                                 #  tableOutput("cdc_table"),
                                #     fluidRow(column(12,offset=4,htmlOutput("Click_bounds")))
                                   # verbatimTextOutput("click_table")
                          ))
                         # fluidRow(column(12,div(style = "height:1px",
                                         # tags$img(src = 'NewYorkTimes_Logo.png',width = '200px'),
                           #               tags$img(src = 'tbd_logo.png', width = "200px", 
                          #                                       align = "center"),
                                         # tags$img(src = 'CDC-logo.png',width = '70px',height = '50px')
                                                                                              
                          ),
                 tabPanel("This is a pipelines test"),
                 tabPanel("Component 3")
)
