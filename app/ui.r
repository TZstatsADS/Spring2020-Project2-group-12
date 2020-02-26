library(shiny)
library(shinydashboard)
library(leaflet)
library(dplyr)
library(DT)
library(leaflet.extras)
library(rsconnect)

## =========== Dashboard Header ===========
header <- dashboardHeader(title = 'NYC Restaurant Inspection')

## =========== Dashboard Sidebar ===========
sidebar <- dashboardSidebar(sidebarMenu(
  menuItem("Home", tabName = "Home", icon = icon("home")),
  menuItem("Introduction", tabName = "Introduction", icon = icon("clipboard"),
           menuSubItem("Guide", tabName = "Guide", icon = icon("arrow-alt-circle-right")),
           menuSubItem("Data Overview", tabName = "Source", icon = icon("arrow-alt-circle-right")),
           menuSubItem("About Team", tabName = "Team", icon = icon("arrow-alt-circle-right"))),
  menuItem("Map", tabName = "Map", icon = icon("map")),
  menuItem("Summary Statistics", tabName = "Statistics", icon = icon("pie-chart")))
)

## =========== Dashboard Body ===========
## Home
body.home <- tabItem(tabName = "Home",
                         fluidPage(
                           fluidRow(
                             box(width = 15, title = "Home",
                                 solidHeader = TRUE, 
                                 h4("NYC Restaurant Health Inspection"),
                                 h5("Eating in New York can be very enjoyable, but there are also potential health risks. With the huge number of restaurants in New York, supervising the restaurants became a tough task. Our shiny app is about the inspection results of restaurants in the five boroughs. The data comes from the Health Department."),
                                 h5("Our target consumers are mainly the restaurant supervisors, who’s job duties are maintaining the overall quality control and ensure customer satisfaction. Using our app, they can explore different types of violations, where are they concentrated and what cuisines are highly potential to have certain violations, etc. According to this they can choose where they are interested to work and help getting better."),  
                                 h5("Individuals like residents or travelers are also welcomed to use the app. They can get some references when choosing the next place to eat and enjoy.")
                                 )
                             )
                     ))
## Introduction - Guide
body.guide <- tabItem(tabName = "Guide",
                      fluidPage(
                        fluidRow(
                          box(width = 15, 
                                h4(textOutput("guide0")),
                                h5(textOutput("guide1")),
                                h5(textOutput("guide2")),
                                h5(textOutput("guide3"))),
                          box(width = 15,
                              h4(textOutput("guide4")),
                              h5(textOutput("guide5")))
                        )
                      ))


## Introduction - Source
body.source <- tabItem(tabName = "Source",
                       mainPanel(
                         dataTableOutput("datatable")
                      ))

## Introduction - Team
body.team <- tabItem(tabName = "Team",
                     mainPanel(
                       h3(textOutput("team0")),
                       h5(textOutput("team1"))
                     ))

## Map
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
                                              selected = c("American"), multiple = T))),
                      fluidRow(column(12, leafletOutput("mapMarker"))
                      )
                    ))

## Statistics
body.statistics <- tabItem(tabName = "Statistics",
                           fluidRow(
                             tabBox(width = 12,
                                    tabPanel(title = "Boro & Violation", 
                                             width = 12, 
                                             (selectInput("selected_borough",
                                                          label = "Choose a Boro",
                                                          choices = c("Brooklyn","Bronx","Manhattan","Queens","Staten Island", "all"))),
                                             plotlyOutput("barplot1", height = 500)),
                                    
                                    tabPanel(title = "Cuisine & Violation",
                                             width = 12,
                                             (selectInput("selected_cuisine",
                                                          label = "Choose a Cuisine",
                                                          choices = c("American", "Chinese", "Mexican", "Italian", "Japanese", "Caribbean", "Spanish", "all"))),
                                             plotlyOutput("barplot2", height = 500)),
                                    
                                    tabPanel(title = "Grade by Cuisine",
                                             width = 12,
                                             (selectInput("Grade",
                                                         label = "Choose a cuisine",
                                                         choices = c("American", "Chinese", "Mexican", "Italian", "Japanese", "Caribbean", "Spanish"))),
                                             (plotlyOutput("donut", height = 400))),
                                    
                                    tabPanel(title = "Violation Score",
                                             width = 12,
                                             plotOutput("barplot3", height = 500)),
                                    
                                    tabPanel(title = "Year Changes",
                                             width = 12,
                                             plotOutput("barplot4", height = 500))
                             )
                           ))

body <- dashboardBody(
  tabItems(
    body.home,
    body.guide,
    body.source,
    body.team,
    body.map,
    body.statistics
  )
)


## =========== UI Interface ===========
ui <- dashboardPage(
  skin = "purple",
  header,
  sidebar,
  body
)

