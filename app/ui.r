library(shiny)
library(leaflet)
library(dplyr)
library(DT)
library(leaflet.extras)

#init.path = getwd()
#data.path = paste0(getwd(), '/app/global.R')
# # Define an UI page
# shinyUI(
#   fluidPage(
#   
#   mainPanel(
#     leafletOutput(outputId = "map")
#     
# )))


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
                                  includeCSS("app/styles.css"),
                                  #includeScript("gomap.js")
                                ),
                                
                                leafletOutput("map", width="100%", height="100%"),
                                # Shiny versions prior to 0.11 should use class="modal" instead.
                                absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                              draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                              width = 330, height = "auto",
                                              ### Create a third level header
                                              h3("Restaurant Violations"),
                                              selectInput("grade", "Grade", GradeLevel, selected = "A"),
                                              selectInput("violationtype", "Violation Type", ViolationType, selected = "Food Temperature")
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
                            
                            
                            
                   )))
