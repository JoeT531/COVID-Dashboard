

con_mshn_tbd <- 
  DBI::dbConnect(
    odbc::odbc(),
    Driver = "SQL Server",
    Server = Sys.getenv("mshn_server_address"),
    Database = "MSHN_TBD",
    UID      = Sys.getenv("mshn_server_uid"),
    PWD      = Sys.getenv("mshn_server_pw"),
    Port     = 1433
  )



LARA_addresses <- dbGetQuery(con_mshn_tbd, 
                             "select * from [dbo].[lara_geocoded]")

    lara<-read_csv("app/datafiles/LARA.csv")%>%
    mutate(Expiration = ymd(Expiration))%>%
       filter(Expiration >= ymd(Sys.Date()))%>%
      select(FacilityName,Fcltyaddress,Capacity,lat = FcltyLat, lon = FcltyLon, parent_org = Licensee)%>%
      distinct()

names(lara)

map<-
  
  
  map_data%>%
  st_transform(crs = "+proj=longlat +datum=WGS84") %>%
  leaflet(width = "100%") %>%
  addProviderTiles(providers$Stamen.TonerLite)%>%
  addPolygons(data = map_data)%>%
  addCircles(data = lara,
                   lat = ~lat,
                   lng = ~lon,
                   weight = ~ log(Capacity),
                   radius = 4,
                   color = "blue"
                   )


f
  addCircleMarkers()









