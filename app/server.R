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
output$county_map<-renderLeaflet({
    
        #  req(data())
        map_data %>%
            st_transform(crs = "+proj=longlat +datum=WGS84") %>%
            leaflet(width = "100%") %>%
            setView(-85.70214763,43.95043432,zoom = "6")%>%
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
                      position = "bottomleft",
                      values = ~ cases_per_10k,
                      title = "Cases Per 10K",
                      opacity = 1) 
        
        
        
    })

output$tract_map <-renderLeaflet({
    
    d<-input$county_map_shape_click
    d<-data.frame(d$id)%>%
        pull()
    
    map_tract<-mi_tract%>%
        left_join(cdc_cocial_vul_tract%>%mutate(FIPS = as.character(FIPS)), by = c("GEOID" = "FIPS"))%>%
        select(GEOID,NAME,COUNTY,`Vulnerability Index` = RPL_THEMES)%>%
        filter(COUNTY == d)
    
    
    binpal_tract <- colorBin( viridis_pal(option = "A",direction = -1)(20),
                        bins = 20,domain = seq(0,1,na.rm = T),.1)
    
    binpal2_tract <- colorBin( viridis_pal(option = "A",direction = -1)(5),
                         bins = 4,domain = seq(0,1,na.rm = T),.25)
    
    lara_only_one_county<-lara_county%>%
    filter(NAME == d)
    
    #========
    # Popup
    #========
    popup<-paste(
      "<div>",
      "<h3>",
     lara$FacilityName,
      "</h3>",
      "Address: ",
      lara$address,
     "<br>",
     "Capacity: ",
     lara$Capacity,
     "<br>",
     "Parent Org: ",
     lara$parent_org
     
    )
    
    
    
    map_tract%>%
        st_transform(crs = "+proj=longlat +datum=WGS84") %>%
        leaflet(width = "100%") %>%
       #  setView(input$map_click[[2]], input$map_click[[1]], zoom = 8.5)%>%
        addProviderTiles(providers$Stamen.TonerLite)%>%
        addPolygons(   stroke = FALSE, data = map_tract,
                       smoothFactor = 0,
                       fillOpacity = 0.5,
                       color = ~ binpal_tract(`Vulnerability Index`),
                       # color = border_col,
                       dashArray = "3",
                       layerId = ~NAME,
                       highlight = highlightOptions(
                           weight = 5,
                           color = "#FF5500",
                           dashArray = "0.3",
                           fillOpacity = 0.7,
                           bringToFront = F)
                       
        )%>%
        addCircles(data =  lara_only_one_county,
                   lat = ~lat,
                   lng = ~lon,
                   weight = ~ log(Capacity),
                   radius = 4,
                   color = "blue",
                   popup = ~popup
        )%>%
        addLegend("bottomleft", 
                  pal = binpal2_tract, 
                  values = ~ `Vulnerability Index`,
                  title = "Vulnerability Index",
                  opacity = 1) 

    
    
    
    
    
    
})

#input$mymap_shape_click$lng
## Table 

output$click_table <-renderText({
    
    d<-input$county_map_shape_click
   # e<-names(d)
    d<-d$id
    
    print(d)
    
    
})

### Testing 
output$Click_bounds <-renderText({
    
    d<- input$tract_map_shape_mouseover[[1]]
# e<-names(d)
  #  d<-d$id
    
#    print(d)
    
    
})



output$cdc_table<-renderTable({
    
    d<-input$county_map_shape_click
    d<-data.frame(d$id)%>%
        pull()
        
    
    ds<-cdc_social_vul%>%
        filter(COUNTY == d)%>%
        select(COUNTY, `Low Trans./High Crowding ` = RPL_THEME4,
                `High Elderly/Single Hshld pop` = RPL_THEME2)
    
    
    
})

library(hrbrthemes)
library(gganimate)

output$county_graph<-renderPlotly({
  
  county_click<-input$county_map_shape_click
  county_click<-data.frame(county_click$id)%>%
    pull()
  
  #county_click<-"Kent"
  
df<-proj_5%>%
    filter(!county == county_click)

df1<-proj_5%>%
  filter(county == county_click)


p<-df %>%
  ggplot( aes(x=date, y=report_median, group = county)) +
  geom_line( color = 'lightgrey') +
  ggtitle("County Projections at various rate") +
  theme_ipsum() +
  theme(
    legend.position="none",
    plot.title = element_text(size=10)
  )

pp<-p+geom_line(data = df1, aes(x=date, y=report_median, group = county),color = "salmon", size = .75)

ggplotly(pp)%>%layout(autosize = F, width = 1000, height = 300)








  
})



output$tract_graph<-renderPlotly({
  
  mouseover_event <- input$tract_map_shape_mouseover[[1]]
  
  df<-cdc_cocial_vul_tract%>%
      filter(LOCATION == 	mouseover_event)%>%
      select(LOCATION, Socioeconomic = RPL_THEME1,
                      `Household Comp.` = RPL_THEME2,
                      `Minority/Languge` = RPL_THEME3,
                      `Housing/Transportation` = RPL_THEME4,
             )%>%
    pivot_longer(cols = 2:5)%>%
    mutate(name = fct_reorder(as.factor(name),value),
           value = value * 100)
  
  title <-as.character(max(df$LOCATION))
  
p<-ggplot(df,aes(x = name, y = value))+
  geom_bar(stat="identity", position=position_dodge(), alpha = .8,
                                                  color="black")+
  theme_minimal()+
  xlab("CDC Vulnerability Index Components")+
 ylab('State Percentile')+

  theme(axis.text.x=element_text(angle=45, hjust=1)
        ,plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5)
      # , text=element_text(size=16, family="Comic Sans MS")
        
  )

ggplotly(p)
  
  
  
})








})
