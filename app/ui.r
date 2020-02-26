library(shiny)
library(shinydashboard)
library(devtools)
#install_github("nik01010/dashboardthemes")
library(dashboardthemes)
library(leaflet)
library(leaflet.extras)
library(DT)
library(rsconnect)
library (png)


## =========== Dashboard Header ===========
header <- dashboardHeader(title = 'NYC Restaurant Inspection',
                          titleWidth = 265)


## =========== Dashboard Sidebar ===========
sidebar <- dashboardSidebar(
  width = 265,
  
  # tags$head(tags$style(HTML('.logo {
  #                             background-color: #8565c4 !important;
  #                           }
  #                           .navbar {
  #                           background-color: #8565c4 !important;
  #                           }
  #                           '))),
  # uiOutput("userpanel"),
  
  sidebarMenu(
  menuItem("Home", tabName = "Home", icon = icon("home")),
  menuItem("Introduction", tabName = "Introduction", icon = icon("clipboard"),
           menuSubItem("Guide", tabName = "Guide", icon = icon("arrow-alt-circle-right")),
           menuSubItem("Data Overview", tabName = "Source", icon = icon("arrow-alt-circle-right"))),
  menuItem("Map", tabName = "Map", icon = icon("map")),
 # menuItem("Heatmap", tabName = "Heatmap", icon = icon("map")),
  menuItem("Summary Statistics", tabName = "Statistics", icon = icon("pie-chart")),
  menuItem("About Team", tabName = "Team", icon = icon("address-card")))
)


## =========== Dashboard Body ===========
## Home


body.home <- tabItem(tabName = "Home",
                     fluidPage(
                       fluidRow(
                         column(3, valueBox("Area", 'New York City', icon("home"), color = 'purple', width = 15)),
                         column(3, valueBox("Data", "86004 Restaurants", icon("hamburger"), color = 'purple', width = 15)),
                         column(3, valueBox("Goal", "Restaurant Violation Inspection", icon("table"), color = 'purple', width = 20))),
                       
                       fluidRow(column(3, img(src = "home_page.png", height = 500, width = 800)))
                       )
                     )



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
                       h5(textOutput("team1")),
                       h5(textOutput("team2")),
                       h5(textOutput("team3")),
                       h5(textOutput("team4")),
                       h5(textOutput("team5")),
                       h5(textOutput("team6"))
                     ))

## Map
body.map <- tabItem(tabName = "Map",
                    fluidPage(
                      fluidRow(column(3, 
                                      selectizeInput("boro1", "Choose the Borough",
                                                     choices = c("Choose Boro(s)" = "",
                                                                 "Bronx", "Brooklyn",
                                                                 "Manhattan", "Queens",
                                                                 "Staten Island"),
                                                     #selected = c("Manhattan"),
                                                     multiple = T)),
                               column(3, 
                                      selectizeInput("grade1", "Choose the Grade",
                                                     choices = c("Choose Grade(s)" = "",
                                                                 "A", "B", "C",
                                                                 "P", "N", "Z"),
                                                     selected = c("A"),
                                                     multiple = T)),
                               column(3, 
                                      selectizeInput("cuisine1", "Cuisine Selection:",
                                              choices = c("American", "Chinese", "Mexican", "Italian", "Japanese", "Caribbean", "Spanish"),
                                              selected = c("American"), multiple = T))),
                      fluidRow(column(12, leafletOutput("mapMarker"))
                      )
                    ))

## Heatmap
body.heatmap <- tabPanel(tabName = "Heatmap",

         sidebarLayout(

           mainPanel(
             leafletOutput("heatMap",width="100%",height=700)),

           sidebarPanel(
             # Input: Slider for time of the day ----
             sliderInput(inputId = "score",
                         label = "Select score:",
                         min = 0,
                         max = 100,
                         value = 50)
           )
         )
         # fluidPage(
         #   fluidRow(leafletOutput("mapAct", height = "800px")),
         #   fluidRow(absolutePanel(top = 150, right = 20,
         #                          sliderInput("animation", "Time(30 minutes)", min = 0, 
         #                                      max = 47, value = 0, step = 1, 
         #                                      animate = animationOptions(interval = 500, loop = FALSE)))),
         #   fluidRow(absolutePanel(plotOutput("line"), top = 80, left = 300,
         #                          width = 360, height = 300, draggable = TRUE)))),
)

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
                                    
                                    # tabPanel(title = "Violation Score",
                                    #          width = 12,
                                    #          plotOutput("barplot3", height = 500)),
                                    
                                    # tabPanel(title = "Total Violation Score", width = 12,
                                    #          plotlyOutput("barplot4", height = 500)),
                                    
                                    tabPanel(title = "Average Violation Score", width = 12,
                                             plotlyOutput("barplot5", height = 500)),
                                    
                                    tabPanel(title = "Year Changes",
                                             width = 12,
                                             plotOutput("barplot6", height = 500))
                             )
                           ))

body.team <- tabItem(tabName = "Team",
                     mainPanel(
                       h3(textOutput("team0")),
                       h5(textOutput("team1")),
                       h5(textOutput("team2")),
                       h5(textOutput("team3")),
                       h5(textOutput("team4")),
                       h5(textOutput("team5")),
                       h5(textOutput("team6"))
                     ))


body <- dashboardBody(
  #changing theme
  shinyDashboardThemes(
    theme = "purple_gradient"),
  
  # UI tabs
  tabItems(
    body.home,
    body.guide,
    body.source,
    body.map,
    #body.heatmap,
    body.statistics,
    body.team
  )
)


## =========== UI Interface ===========
ui <- dashboardPage(
  #skin = "purple",
  header,
  sidebar,
  body
)



