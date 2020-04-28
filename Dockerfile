FROM rocker/shiny-verse:3.6.1

RUN apt-get update
RUN apt-get install -y libudunits2-dev 
RUN apt-get install -y libgdal-dev

RUN R -e 'install.packages("devtools");'

RUN R -e 'library("devtools"); install_github("LHaferkamp/httpuv")'

#RUN R -e 'remotes::install_github("r-quantities/units")'
RUN apt-get update && apt-get install -y \ 
    libssl-dev \
    ## clean up
    && apt-get clean \ 
    && rm -rf /var/lib/apt/lists/ \ 
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

RUN install2.r tidyverse sf lubridate shiny DT shinythemes scales hrbrthemes stringi leaflet forcats plotly ggthemes viridis leaflet.extras\
    ## clean up
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

#RUN chown shiny:shiny /var/lib/shiny-server
# Docker file in the root directory 
COPY . /srv/shiny-server/ 
# Shiny app in the app_folder

COPY /app /srv/shiny-server/

EXPOSE 3838

USER shiny
