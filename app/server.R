library(shiny)
library(shinyWidgets)
library(shinythemes)

library(DT)
library(leaflet)
library(ggplot2)
library(RColorBrewer)

library(dplyr)
library(tools)
library(tidyverse)
library(lubridate)
library(dbplyr)
library(dbplot)
library(DBI)
library(plotly)
library(dplyr)
library(tidyr)
library(ggplot2)
library(gganimate)
library(gifski)
library(rsconnect)



## ============= Load Data =============== 
#init.path = dirname(rstudioapi::getActiveDocumentContext()$path)
#data.path = paste0(init.path, "/global.R")
source("global.R")


## =============  Define server logic to draw the map ============= 
shinyServer(function(input, output){
  
  ## Introduction
  output$guide0 <- renderText({"Introduction"})
  output$guide1 <- renderText({"Eating in New York can be very enjoyable, but there are also potential health risks. With the huge number of restaurants in New York, supervising the restaurants became a tough task. Our shiny app is about the inspection results of restaurants in the five boroughs. The data comes from the Health Department."})
  output$guide2 <- renderText({"Our target consumers are mainly the restaurant supervisors, who’s job duties are maintaining the overall quality control and ensure customer satisfaction. Using our app, they can explore different types of violations, where are they concentrated and what cuisines are highly potential to have certain violations, etc. According to this they can choose where they  are interested to work and help getting better."})  
  output$guide3 <- renderText({"Individuals like residents or travelers are also welcomed to use the app. They can get some references when choosing the next place to eat and enjoy."})
  output$guide4 <- renderText({"User Guide"})
  output$guide5 <- renderText({"Map: This map contains the information of restaurants which are inspected in 2019 or 2020. Include restaurants’ name, phone number, address and violation description. On the top there are three filters: borough, grade and cruising. Users can select their interested field to explore."})
  output$guide6 <- renderText({"Summary Statistics: The summary includes analyses of violation score and borough differences, and grade distributions by cuisine."})

  
  output$team0 <- renderText({"About Team"})
  output$team1 <- renderText({"This app is developed by:"})
  
  output$datatable <- renderDataTable({
    df_display
  })
  
  ## Map
  filteredData <- reactive({
    if(is.null(input$grade1)){selected_grade = levels(df.map$grade)}
    else{selected_grade = input$grade1}
    
    if(is.null(input$boro1)){selected_boro = levels(df.map$boro)}
    else{selected_boro = input$boro1}
    
    if(is.null(input$cuisine1)){selected_boro = levels(df.map$cuisine)}
    else{selected_cuisine = input$cuisine1}
    
    df.map %>% 
      filter(grade %in% selected_grade) %>%
      filter(boro %in% selected_boro) %>%
      filter(cuisine %in% selected_cuisine)
  })
  
  icons <- makeIcon("restaurant_logo.png", iconWidth = 25, iconHeight = 25)
  
  output$mapMarker <- renderLeaflet({
    leaflet(options = leafletOptions(minZoom = 8, maxZoom = 18)) %>% 
      setView(-73.9252853, 40.7910694, zoom = 10) %>% 
      addTiles('http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png') %>%
      addMarkers(lng = df$longitude, lat = df$latitude,
                 #popup = content,
                 clusterOptions = markerClusterOptions(),
                 icon = icons
                 )
  })
  
  observe({
    df.marker = filteredData()
    leafletProxy("mapMarker", data = df.marker) %>%
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
                                #paste0("<b>", "Yelp Rating: ", "</b>", rating),
                                paste0("<b>", "Inspection Grade: ", "</b>", grade),
                                paste0("<b>", "Violation Description: ", "</b>", violation.description)),
                 clusterOptions = markerClusterOptions(),
                 icon = icons
                 )
  })
  

  
  ## Bar Plot1: Boro
  selected_boroughInput <- reactive({
    switch(input$selected_borough,
           "Bronx"="Bronx",
           "Brooklyn"="Brooklyn",             
           "Manhattan"="Manhattan",            
           "Queens"="Queens",              
           "Staten Island"="Staten Island",
           "all"="all")
  })
  
  output$barplot1 <- renderPlotly({
    borough %>% 
      select(violation.short.desp, count=selected_boroughInput()) %>% 
      plot_ly(., x = ~violation.short.desp, y = ~count, type = 'bar', name = "Counts(Borough)") %>%
      layout(title = "Number of Restaurants Per Violation Type By Borough",
             xaxis = list(title = "Violation")) %>% 
       add_trace(x = ~violation.short.desp, y = ~borough$all/6, type = 'scatter', mode = 'lines', name = 'All Restaurants Trend/6',
                 line = list(color = '#66B2FF'),
                 hoverinfo = "text")
  })
    
  ## Bar Plot2: Cuisine
  selected_cuisineInput <- reactive({
    switch(input$selected_cuisine,
           "American" = "American",
           "Chinese" = "Chinese",
           "Mexican" = "Mexican",
           "Italian" = "Italian",
           "Japanese" = "Japanese",
           "Caribbean" = "Caribbean",
           "Spanish" = "Spanish",
           "all"="all")
  })
  
  output$barplot2 <- renderPlotly({
    cuisine %>% 
      select(violation.short.desp, count=selected_cuisineInput()) %>%
      plot_ly(., x = ~violation.short.desp, y = ~count, type = 'bar', name = "Counts(Cuisine)") %>%
      layout(title = "Number of Restaurants Per Violation Type By Cuisine",
             xaxis = list(title = "Cuisine")) #%>%
      #add_trace(x = ~violation.short.desp, y = ~cuisine$all/5, type = 'scatter', mode = 'lines', name = 'All Restaurants Trend/5',
      #          line = list(color = '#66B2FF'),
      #          hoverinfo = "text")
  })
  
  ## Donut
  selected_cuisine <- reactive({
    switch(input$Grade,
           "American" = "American",
           "Chinese" = "Chinese",
           "Mexican" = "Mexican",
           "Italian" = "Italian",
           "Japanese" = "Japanese",
           "Caribbean" = "Caribbean",
           "Spanish" = "Spanish"
    )
  })
  
  output$donut <- renderPlotly({
    df_cuisine_grade %>%
      filter(cuisine == selected_cuisine()) %>%
      plot_ly(labels = ~grade, values = ~freq) %>%
      add_pie(hole = 0.4) %>%
      layout(title = "Donut Charts of the Six Most Popular Cuisines", showlegend = F)
  })
  
  
  ## Bar Plot3: Score
  output$barplot3 <- renderPlot({
    barplot(df.bar$score,names.arg = df$name,  horiz = TRUE,cex.names=1, las=1,
                  main="Violation Score Rank of Fast Foods",
                  xlab="Violation Total Scores",
                  yaxis = list(range = c(0, 30000)))
    
  })
  
  ## Bar Plot4: Year
  # output$barplot3 <- renderImage({
  #   # A temp file to save the output.
  #   # This file will be removed later by renderImage
  #   outfile <- tempfile(fileext='.gif')
  #   
  #   anim_save("outfile.gif", animate(year_perc))
  #   
  #   # Return a list containing the filename
  #   list(src = "outfile.gif",
  #        contentType = 'image/gif'
  #        # width = 400,
  #        # height = 300,
  #        # alt = "This is alternate text"
  #   )}, deleteFile = TRUE)
  
  output$barplot4 <- renderPlot({
    year_perc
  })
  
})


