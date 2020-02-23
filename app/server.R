packages.used=c("dplyr", "plotly", "shiny", "leaflet", "scales", 
                "lattice", "htmltools", "maps", "data.table", 
                "dtplyr", "mapproj", "randomForest", "ggplot2", "rpart")

# check packages that need to be installed.
packages.needed=setdiff(packages.used, 
                        intersect(installed.packages()[,1], 
                                  packages.used))
# install additional packages
if(length(packages.needed)>0){
  install.packages(packages.needed, dependencies = TRUE)
}
library(shiny)
library(DT)
library(leaflet)
library(ggplot2)
library(RColorBrewer)

init.path = getwd()
data.path = paste0(init.path, "/global.R")
source(data.path)

# Define server logic to draw the map
shinyServer(function(input, output){
      
  output$map <- renderLeaflet({
    m <- leaflet() %>%
      addProviderTiles("CartoDB.Positron", 
                       options = providerTileOptions(noWrap = TRUE)) %>%
      setView(-73.9252853,40.7910694,zoom = 13) %>%
      addResetMapButton()
    
    rtype <- reactive({
      r <- df
      if(input$grade == TRUE){r <- filter(r, grade == "Yes")}
      r
    })
    
      leafletProxy("map", data = graderA) %>%
      addMarkers(lng = graderA$longitude, lat = graderA$latitude, group = "graderA",
                                                       clusterOptions = markerClusterOptions())
      leafletProxy("map", data = graderB) %>%
      addMarkers(lng = graderB$longitude, lat = graderB$latitude,group = "graderB",
                                                       clusterOptions = markerClusterOptions())
      leafletProxy("map", data = graderC) %>%
      addMarkers(lng = graderC$longitude, lat = graderC$latitude,group = "graderC",
                                                       clusterOptions = markerClusterOptions())
      leafletProxy("map", data = graderP) %>%
      addMarkers(lng = graderP$longitude, lat = graderP$latitude,group = "graderP",
                                                       clusterOptions = markerClusterOptions())
      leafletProxy("map", data = graderZ) %>%
      addMarkers(lng = graderZ$longitude, lat = graderZ$latitude,group = "graderZ",
                                                       clusterOptions = markerClusterOptions())
      leafletProxy("map", data = graderN) %>% 
      addMarkers(lng = graderN$longitude, lat = graderN$latitude,group = "graderN",
                                                       clusterOptions = markerClusterOptions())
    m
    })
  
    observeEvent(input$grade, {
    if("A" %in% input$grade) leafletProxy("map") %>% showGroup("graderA")
    else{leafletProxy("map") %>% hideGroup("graderA")}
    if("B" %in% input$grade) leafletProxy("map") %>% showGroup("graderB")
    else{leafletProxy("map") %>% hideGroup("graderB")}
    if("C" %in% input$grade) leafletProxy("map") %>% showGroup("graderC")
    else{leafletProxy("map") %>% hideGroup("graderC")}
    if("P" %in% input$grade) leafletProxy("map") %>% showGroup("graderP")
    else{leafletProxy("map") %>% hideGroup("graderP")}
    if("Z" %in% input$grade) leafletProxy("map") %>% showGroup("graderZ")
    else{leafletProxy("map") %>% hideGroup("graderZ")}
    if("N" %in% input$grade) leafletProxy("map") %>% showGroup("graderN")
    else{leafletProxy("map") %>% hideGroup("graderN")}
  }, ignoreNULL = FALSE)
    
})

