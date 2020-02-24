library(shiny)
library(leaflet)
library(dplyr)
library(DT)
library(leaflet.extras)


# Choices for drop-downs
GradeLevel <- c(
  "A" = "A",
  "B" = "B",
  "C" = "C",
  "Z" = "Z",
  "P" = "P",
  "N" = "N"
)

ViolationType <- c(
  "Evidence of Mice/Roches/Flies" = 04,
  "Food Temperature" = 02,
  "Food Contact Surfaces Not Clean and Sanitized" = 06,
  "Pest Related Facility Use" = 08,
  "Non-food Contact Surfaces/Facility Improperly Constructed" = 10
)

shinyUI(navbarPage("Restaurant Inspection", id="nav",
                   
                   tabPanel("Restaurant Map",
                            div(class="outer",
                                
                                tags$head(
                                  # Include our custom CSS
                                  includeCSS("../app/styles.css"),
                                  includeScript("../app/gomap.js")
                                ),
                                
                                leafletOutput("map", width="100%", height="100%"),
                                absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                              draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                              width = 330, height = "auto",
                                              selectizeInput("grade","Inspection Grade:",
                                                                 choices = c("A","B","C","P","C","N"),
                                                                 selected = c("A")),
                                              selectizeInput("boro", "Borough Selection:",
                                                             choices = c("Bronx","Brooklyn","Manhattan","Queens","Staten Island"),
                                                             selected = c("Manhattan"))
                                ),
                                absolutePanel(id="graphstuff",class = "panel panel-default", fixed=TRUE,
                                              draggable = TRUE, top=60,left=10,right="auto", bottom="auto",width=300,
                                              height=200, style="opacity:0.85",
                                              # div(style="padding: 8px; border-bottom: 1px solid #CCC; background: #FFFFEE;"),
                                              # h2("Crime around this Restroom"),
                                              h6(textOutput("totalcrime")),
                                              plotOutput("circ_plot",height=200)
                                              )
                                )
                            ),
                   
                   
                   tabPanel("Statistical Analysis",
                            titlePanel("Summary Statistics"),
                            wellPanel(tabsetPanel(type="tabs",
                                                  tabPanel(title="Title 1",
                                                           br(),
                                                           div( align="center")
                                                           
                                                  ),
                                                  tabPanel(title="Title 2",
                                                           br(),
                                                           div(align="center")
                                                           
                                                  ),
                                                  tabPanel(title="Title 3")
                            )
                            
                            
                            )
                   ),
                   
                   tabPanel("Data Search",
                            div(width = 12,
                                h1("whole dataset"), # title for data tab
                                br(),
                                dataTableOutput('table1')),
                            # footer
                            div(class="footer", em(a("Data from NYC Open Data",href="https://opendata.cityofnewyork.us")))
                            
                   )
                   
                   
                   )
        )
