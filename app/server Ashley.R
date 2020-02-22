library(shiny)
library(DT)
library(leaflet)
library(ggplot2)
library(RColorBrewer)

init.path = getwd()
data.path = paste0(init.path, '/global.R')
source(data.path)


# Define server logic to draw the map
shinyServer(function(input, output){
  
  # Create a leaflet map
  output$map <- renderLeaflet({
    
    # Set the view to the center of Manhatten
    map <-  leaflet() %>% 
      addTiles() %>% 
      setView(-73.9854, 40.7488, zoom = 12) %>%
      addResetMapButton()
    
    # Popup Content
    popup.content <- paste(sep = "<br/>",
                           paste("<font size=1.8>", "<font color=purple>", "<b>", df$dba, "</b>"),
                           paste0("<font size=1>", "<font color=black>", df$building[1], " ", df$street[1], ", ", df$boro[1], ", ", "NY ", df$zipcode[1]),     
                           paste0(""))
      

      paste0(,
                            "<br/>", "Grade: ", df$grade)
    
    
    content <- paste(sep = "<br/>",
                     paste("<font size=1.8>","<font color=green>","<b>",v3()$Hospital.Name,"</b>"),
                     paste("<font size=1>","<font color=black>",v3()$Address),
                     paste(v3()$City, v3()$State, v3()$ZIP.Code, sep = " "),  
                     paste("(",substr(v3()[ ,"Phone.Number"],1,3),") ",substr(v3()[ ,"Phone.Number"],4,6),"-",substr(v3()[ ,"Phone.Number"],7,10),sep = ""), 
                     paste("<b>","Hospital Type: ","</b>",as.character(v3()$Hospital.Type)),  
                     paste("<b>","Provides Emergency Services: ","</b>",as.character(v3()[ ,"Emergency.Services"])),
                     
                     paste("<b>","Overall Rating: ","</b>", as.character(v3()[ ,"Hospital.overall.rating"])),
                     paste("<b>","Personalized Ranking: ","</b>",v3()$Rank))
    
    # Markers
    leafletProxy("map", data = df) %>%
      addMarkers(lng = df$longitude, lat = df$latitude, 
                 clusterOptions = markerClusterOptions(),
                 popup = popup.content)
    
    map
  })
  
})

# phone# 
# address
# violation desc
map %>%
  addMarkers(lng = df$longitude, lat = df$latitude, 
                  clusterOptions = markerClusterOptions(),
                  popup = popup.content)
