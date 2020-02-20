library(shiny)
library(DT)
library(leaflet)
library(ggplot2)
library(RColorBrewer)

init.path = getwd()
data.path = paste0(init.path, '/app/global.R')
source(data.path)


# Define server logic to draw the map
shinyServer(function(input, output){
  
  # Set the view to the center of Manhatten
  map <-  leaflet() %>% 
    addTiles() %>% 
    setView(-73.9854, 40.7488, zoom = 12) %>%
    addMarkers(lng = latlon$Long, lat = latlon$Lat, 
               clusterOptions = markerClusterOptions())

  # Create the leaflet map
  output$map <- renderLeaflet(map)
  
})
