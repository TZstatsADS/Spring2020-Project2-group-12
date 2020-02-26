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


## ============= Load Data =============== 
init.path = dirname(rstudioapi::getActiveDocumentContext()$path)
data.path = paste0(init.path, "/global.R")
source(data.path)


## =============  Define server logic to draw the map ============= 
shinyServer(function(input, output){
  
  ## Map
  filteredData <- reactive({
    if(is.null(input$grade1)){selected_grade = levels(df$grade)}
    else{selected_grade = input$grade1}
    
    if(is.null(input$boro1)){selected_boro = levels(df$boro)}
    else{selected_boro = input$boro1}
    
    if(is.null(input$cuisine1)){selected_boro = levels(df$cuisine)}
    else{selected_cuisine = input$cuisine1}
    
    df %>% 
      filter(grade %in% selected_grade) %>%
      filter(boro %in% selected_boro) %>%
      filter(cuisine %in% selected_cuisine)
  })
  
  output$mapMarker <- renderLeaflet({
    leaflet(options = leafletOptions(minZoom = 8, maxZoom = 18)) %>% 
      setView(-73.9252853, 40.7910694, zoom = 10) %>% 
      addTiles('http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png') %>%
      addMarkers(lng = df$longitude, lat = df$latitude,
                 #popup = content,
                 clusterOptions = markerClusterOptions(),
                 icon = list(iconUrl = 'https://github.com/TZstatsADS/Spring2020-Project2-group-12/blob/master/doc/restaurant_logo.png',
                             iconSize = c(25,25)))
  })
  
  
  observe({
    df.marker = filteredData()
    leafletProxy("mapMarker",data = df.marker) %>%
      fitBounds(lat1 = min(df.marker$latitude), 
                lng1 = min(df.marker$longitude), 
                lat2 = max(df.marker$latitude), 
                lng2 = max(df.marker$longitude))%>%
      clearMarkerClusters()%>%
      clearPopups() %>%
      clearMarkers() %>%
      addMarkers(lng = ~longitude, lat = ~latitude,
                       popup = ~paste(sep = "<br/>",
                                      paste("<font size=1.8>", "<font color=purple>", "<b>", dba, "</b>"),
                                      paste0("<font size=1>", "<font color=black>", address, "</b>"),     
                                      paste0(phone),
                                      paste0("Grade: ", grade),
                                      paste0("Violation Description: ", violation.description)),
                       clusterOptions = markerClusterOptions(),
                 icon = icon("home"))
  })
  
  ## Pie Chart
  output$plot <- renderPlotly(
    p
  )
  
  # Bar Plot
  # selected_cuisineInput <- reactive({
  #   switch(input$selected_borough,
  #          "American" = borough$American,
  #          "Brooklyn" = borough$Brooklyn,
  #          "Manhattan" = borough$Manhattan,
  #          "Queens" = borough$Queens,
  #          "Staten Island" = borough$`Staten Island`,
  #          "all"=borough$all)
  # })
  # 
  
  output$barplot <- renderPlotly({
    p <- ggplot(data = borough, aes(x = violation.short.desp, y = freq, fill = boro)) +
      geom_bar(stat="identity")
    
    ggplotly(p) %>% layout(height = 500, width = 500)

  })

  
  # output$barplot<- renderPlot({
  #   
  #   p <- ggplot(borough) + 
  #     geom_bar(aes(violation.short.desp, selected_cuisineInput(), fill="Number of Restaurants"), stat = "identity") + 
  #     geom_point(aes(violation.short.desp, borough$"all"/5), colour="black") +
  #     geom_line(aes(violation.short.desp, borough$"all"/5), group=1)+
  #     theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 0.5)) +
  #     labs(title = "Borough vs. Violation" )
  #   
  #   ggplotly(p) %>% layout(height = 700, width = 1000)
  #   #geom_line(aes(Month, weatherInput()*.8*min(crime_typeInput()/weatherInput()), group=1, colour="Weather")) + 
  #   #scale_colour_manual("", values=c("Number of Total Crimes"="grey", "Weather"="black")) +  
  #   #scale_fill_manual("",values="grey")+
  #   #scale_y_continuous(sec.axis = sec_axis(~./.8/min(crime_typeInput()/weatherInput()))) +
  #   # +
  #   #theme(legend.justification=c(1,1), legend.position=c(1,1), panel.grid.major =element_blank(), 
  #   #panel.grid.minor = element_blank(), panel.background = element_blank())
  # })
  
  
})


