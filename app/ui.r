library(shiny)
library(shinydashboard)
library(leaflet)
library(dplyr)
library(DT)
library(leaflet.extras)

## =========== Header ===========
header <- dashboardHeader(title = 'NYC Restaurant Inspection')

## ===========  Sidebar ===========
sidebar <- dashboardSidebar(sidebarMenu(
  menuItem("Home", tabName = "Home", icon = icon("home")),
  menuItem("Summary", tabName = "Summary", icon = icon("clipboard")),
  menuItem("Map", tabName = "Map", icon = icon("map")),
  menuItem("Summary Statistics", tabName = "Statistics", icon = icon("pie-chart")))
)

## =========== Body ===========
# Home
body.home <- tabItem(tabName = "Home",
                         fluidPage(
                           fluidRow(
                             box(width = 15, title = "Introduction", 
                                 solidHeader = TRUE, 
                                 h3("NYC Restaurant Violation Map"))
                             )
                     ))
# Map
body.map <- tabItem(tabName = "Map",
                    fluidPage(
                      fluidRow(column(4, 
                                      selectizeInput("boro1", "Choose the Borough",
                                                     choices = c("Choose Boro(s)" = "",
                                                                 "Bronx", "Brooklyn",
                                                                 "Manhattan", "Queens",
                                                                 "Staten Island"),
                                                     selected = c("Manhattan"),
                                                     multiple = T)),
                               column(4, 
                                      selectizeInput("grade1", "Choose the Grade",
                                                     choices = c("Choose Grade(s)" = "",
                                                                 "A", "B", "C",
                                                                 "P", "N", "Z"),
                                                     selected = c("A"),
                                                     multiple = T)),
                               column(4, 
                                      selectizeInput("cuisine1", "Cuisine Selection:",
                                              choices = c("American", "Chinese", "Mexican", "Italian", "Japanese", "Caribbean", "Spanish"),
                                              selected = c("American"), multiple = TRUE))),
                      fluidRow(column(12, leafletOutput("mapMarker"))
                      )
                    ))

# Statistics
body.statistics <- tabItem(tabName = "Statistics",
                           fluidRow(
                             tabBox(width = 12,
                                    tabPanel(title = "Barplot", 
                                             width = 12, 
                                             plotlyOutput("barplot", height = 500)),
                                    tabPanel(title = "Pie Chart",
                                             width = 12,
                                             plotlyOutput("plot", height = 500))
                             )
                           ))


body <- dashboardBody(
  tabItems(
    body.home,
    body.map,
    body.statistics
  )
)

# body.statistics <- tabItem(tabName = "Statistics",
#                            fluidPage(
#                              fluidRow(column(12, box(plotlyOutput("plot")))
#                              )))


## =========== UI Interface ===========
ui <- dashboardPage(
  skin = "purple",
  header,
  sidebar,
  body
)

