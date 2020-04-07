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

output$tract_map <-renderLeaflet({
    
    d<-input$map_shape_click
    d<-data.frame(d$id)%>%
        pull()
    
    map_tract<-mi_tract%>%
        left_join(cdc_cocial_vul_tract%>%mutate(FIPS = as.character(FIPS)), by = c("GEOID" = "FIPS"))%>%
        select(GEOID,COUNTY,trans_crowding_pctle = RPL_THEME4)%>%
        filter(COUNTY == d)
    
    
    binpal_tract <- colorBin( viridis_pal(option = "A",direction = -1)(20),
                        bins = 20,domain = seq(0,1,na.rm = T),.1)
    
    binpal2_tract <- colorBin( viridis_pal(option = "A",direction = -1)(5),
                         bins = 4,domain = seq(0,1,na.rm = T),.25)
    
    map_tract%>%
        st_transform(crs = "+proj=longlat +datum=WGS84") %>%
        leaflet(width = "100%") %>%
        addProviderTiles(providers$Stamen.TonerLite)%>%
        addPolygons(   stroke = FALSE,
                       smoothFactor = 0,
                       fillOpacity = 0.5,
                       color = ~ binpal_tract(trans_crowding_pctle),
                       # color = border_col,
                       dashArray = "3",
                       highlight = highlightOptions(
                           weight = 5,
                           color = "#FF5500",
                           dashArray = "0.3",
                           fillOpacity = 0.7,
                           bringToFront = TRUE)
                       
        )%>%
        addLegend("bottomright", 
                  pal = binpal2_tract, 
                  values = ~ trans_crowding_pctle,
                  title = "Crowding",
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
