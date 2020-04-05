#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    
    ### Reactive Input
    org_input<-reactive(input$org)
    metric_input<-reactive(input$metric)
    
    

    ### UI Components
    
    output$CMH_PIHP<-renderUI({
        
        selectInput(inputId = "org",
                    label = "Org",
                    choices = c("pihp","cmhsp"),
                    selected = 'pihp')
        
    })
    
    
    
    output$metric<-renderUI({
        
        selectInput(inputId = "metric",
                    label = "metric",
                    choices = c("cost","units"),
                    selected = 'pihp')
        
    })
    
    
    
    ### Map
output$map<-renderLeaflet({
    
        #  req(data())
        map_data %>%
            st_transform(crs = "+proj=longlat +datum=WGS84") %>%
            leaflet(width = "100%") %>%
            addProviderTiles(providers$Stamen.TonerLite)%>%
            addPolygons(
                stroke = FALSE,
                smoothFactor = 0,
                fillOpacity = 0.5,
                color = ~ binpal(cases_per_10k),
                # color = border_col,
                dashArray = "3",
                layerId = ~COUNTY,
                highlight = highlightOptions(
                    weight = 5,
                    color = "#FF5500",
                    dashArray = "0.3",
                    fillOpacity = 0.7,
                    bringToFront = TRUE)
                
            )%>%
            addLegend("bottomright", 
                      pal = binpal2, 
                      values = ~ cases_per_10k,
                      title = "COVID Cases Per 10K",
                      opacity = 1) 
        
        
        
    })

## Table 

output$click_table <-renderText({
    
    d<-input$map_shape_click
   # e<-names(d)
    d<-d$id
    
    print(d)
    
    
})


output$cdc_table<-renderTable({
    
    d<-input$map_shape_click
    d<-data.frame(d$id)%>%
        pull()
        
    
    ds<-cdc_social_vul%>%
        filter(COUNTY == d)%>%
        select(COUNTY, `Low Trans./High Crowding ` = RPL_THEME4,
                `High Elderly/Single Hshld pop` = RPL_THEME2)
    
    
    
})




    
    
    
})
