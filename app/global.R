library(shiny)
library(dplyr)
library(tools)
library(tidyverse)
library(lubridate)

library(dbplyr)
library(dbplot)
library(DBI)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


# ================== Load Data ===================
# Load Data
df_0 <- read.csv("../data/processed_df.csv")


# ================== Text Processing ===================
# https://rstudio-pubs-static.s3.amazonaws.com/408658_512da947714740b99253228f084a08a9.html
to.upper <- function(word){
  string <- strsplit(as.character(word), " ")[[1]]
  s <- paste(substring(string, 1,1), tolower(substring(string, 2)), sep="", collapse=" ")
  str_replace(s, " \\(.*\\)", "")
}

number.to.phone <- function(number){
  first <- substring(number,1,3)
  second <- substring(number, 4,6)
  third <- substring(number, 7, 9)
  paste0("(", first, ") ", second, "-", third)
}

address <- function(building, street, boro, zipcode){
  if(boro == "Manhattan") boro = "New York"
  paste0(building, " ", street, ", ", boro, ", ", "NY ", zipcode) 
}


#  =================== Data cleaning ===================
ViolationType <- list(
  "04"= "Evidence of Mice/Roches/Flies",
  "02"= "Food Temperature",
  "06"= "Food Contact Surfaces Not Clean and Sanitized",
  "08"= "Pest Related Facility Use",
  "10"= "Non-food Contact Surfaces/Facility Improperly Constructed")

df <- df_0 %>%
  filter(grade %in% c('A', 'B', 'C', 'Z', 'P', 'N') &
           !is.na(latitude) & !is.na(longitude)) %>%
  mutate(dba = map_chr(dba, function(x) to.upper(x)),
         building = map_chr(building, function(x) to.upper(x)),
         street = map_chr(street, function(x) to.upper(x)),
         phone = map_chr(phone, function(x) number.to.phone(x)),
         boro = as.character(boro),
         address = address(building, street, boro, zipcode))%>% 
  mutate(violation.short.desp = ViolationType[substring(violation.code, 0, 2)])


# Extract grade
grade <- df %>%
  filter(grade %in% c('A', 'B', 'C', 'Z', 'P', 'N'))

graderA <- df[df$grade == "A",] 
graderB <- df[df$grade == "B",]
graderC <- df[df$grade == "C",]
graderZ <- df[df$grade == "Z",] 
graderP <- df[df$grade == "P",] 
graderN <- df[df$grade == "N",] 

# %>% filter(!is.na(latitude) | (!is.na(longitude)))

