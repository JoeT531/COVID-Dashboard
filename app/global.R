library(tidycensus)
library(tidyverse)
library(leaflet)
library(sp)
library(sf)
library(viridis)
library(DT)
library(lubridate)
library(plotly)
options(tigris_use_cache = TRUE)

covid_data <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv")%>%
  filter(state == "Michigan")%>%
  group_by(county)%>%
  filter(date == max(date,na.rm = T))


cdc_social_vul<-read_csv("datafiles/county_cdc_social_vulnerability.csv")

cdc_cocial_vul_tract<-read_csv("datafiles/tract_cdc_social_vulnerability.csv")


cdc_cocial_vul_tract<-read_csv("datafiles/tract_cdc_social_vulnerability.csv")

#=================================
# Getting census county data
#census_api_key("2e813467b85f18e31859f48cefdd60a3ef4aa81e", install = TRUE)

#mi <- get_acs(geography = "county", 
#              variables = "B19013_001", 
#              geometry = TRUE,
#              state = 'MI',
#              year = 2018
            #  options(tigris_use_cache = TRUE)
#              )

#====================================
# Getting census tract data 
#mi_tract <- get_acs(geography = "tract", 
#              variables = "B19013_001", 
#              geometry = TRUE,
#              state = 'MI',
#              year = 2018
              #  options(tigris_use_cache = TRUE)
#)


#================
# LARA Data 
#================


lara<-read_csv("datafiles/LARA.csv")%>%
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



#=============================
# Join the three for county
#============================
map_data<-mi%>%
  left_join(covid_data, by = c("GEOID" = "fips"))%>%
  left_join(cdc_social_vul%>%mutate(FIPS = as.character(FIPS)), by = c("GEOID" = "FIPS"))%>%
  mutate(cases_per_10k = cases/(E_TOTPOP/10000))%>%
  select(GEOID,COUNTY,E_TOTPOP,cases,cases_per_10k,
         trans_crowding_pctle = RPL_THEME4,
         eld_singlHsHld = RPL_THEME2,
         geometry)%>%
  replace_na(list(cases_per_10k = 0))


#====================== 
# Join for tract 
#======================

#map_tract<-mi_tract%>%
#           left_join(cdc_cocial_vul_tract%>%mutate(FIPS = as.character(FIPS)), by = c("GEOID" = "FIPS"))%>%
#           select(GEOID,COUNTY,trans_crowding_pctle = RPL_THEME4)%>%
#           filter(COUNTY == 'Kent')

map_tract%>%
  st_transform(crs = "+proj=longlat +datum=WGS84") %>%
  leaflet(width = "100%") %>%
  addProviderTiles(providers$Stamen.TonerLite)%>%
  addPolygons()

# Making the map 

pal <- colorNumeric(palette = "viridis",
                    domain = covid_data$cases_per_10k)

binpal <- colorBin( viridis_pal(option = "A",direction = -1)(20),
                    bins = 40,domain = seq(0,40,na.rm = T),1)

binpal2 <- colorBin( viridis_pal(option = "A",direction = -1)(20),
                     bins = 4,domain = seq(0,40,na.rm = T),10)



#==========================
# County Projections 
#=========================
library(lubridate)








