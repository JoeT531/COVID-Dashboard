library(DBI)

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
                             
                             "select distinct
                             a.CountyID
                             ,FacilityName
                             ,a.fcltylat as lat
                             ,a.fcltylon as lon
                             ,a.Licensee as parent_org
                             ,a.Capacity
                             ,b.county_name
                             ,a.Expiration
                             ,a.Fcltyaddress
                             ,a.address
                             from [MSHN_TBD].[dbo].[lara_geocoded] as a
                             left join  mshn_bi.dbo.mi_county_codes as b 
                             on a.CountyID = b.mi_number")

lara<-read_csv("app/datafiles/LARA.csv")%>%
mutate(Expiration = ymd(Expiration))%>%
filter(Expiration >= ymd(Sys.Date()))%>%
distinct()%>%
mutate(NAME = str_to_sentence(county_name))


    
    
county_only<-mi%>%
              ungroup()%>%
              select(GEOID,NAME)%>%
              mutate(CountyID = as.numeric(str_sub(GEOID,-2,-1)))

lara_county<-lara%>%
      left_join(county_only, by = "NAME")

  
  
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


#============================
# Projections dataset 
#============================

  
  proj_5<-read_csv("app/datafiles/Projection_5%mobility.csv")%>%
    mutate(state = str_squish(substr(county,nchar(county)-2,nchar(county))),
           date = ymd(as.Date(Date,"%m/%d/%Y")),
           county = str_squish(str_remove_all(county,"County MI")),
           group =  "5%"
           
    )%>%
    filter(state == "MI",
           date > ymd(Sys.Date()))%>%
    select(fips,county,date,report_median,group)
  
  
  proj_50<-read_csv("app/datafiles/Projection_50%transmissibility.csv")%>%
    mutate(state = str_squish(substr(county,nchar(county)-2,nchar(county))),
           date = ymd(as.Date(Date,"%m/%d/%Y")),
           county = str_squish(str_remove_all(county,"County MI")),
           group = "50%")%>%
    filter(state == "MI",
           date > ymd(Sys.Date()))%>%
    select(fips,county,date,report_median,group)


write_csv(proj_5,"app/datafiles/proj_5.csv")
  






