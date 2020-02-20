library(shiny)
library(dplyr)
library(lubridate)
setwd("/Users/little/Desktop/5243 ADS/Project 2")

# Load Data
df <- read.csv('./data/processed_df.csv')

# Extract grade
grade <- df %>%
  filter(grade %in% c('A', 'B', 'C', 'Z', 'P', 'N'))

# Extract the latitude and longitude
latlon <- data.frame(Lat = grade$latitude, Long = grade$longitude)[1:1000,]


