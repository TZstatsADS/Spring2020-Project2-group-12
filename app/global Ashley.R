library(shiny)
library(dplyr)
library(tools)
library(tidyverse)
library(lubridate)


# Load Data
df_0<- read.csv("../data/processed_df.csv")

# Text Processing
# https://rstudio-pubs-static.s3.amazonaws.com/408658_512da947714740b99253228f084a08a9.html
address <- function(word){
  string <- strsplit(as.character(word), " ")[[1]]
  s <- paste(substring(string, 1,1), tolower(substring(string, 2)), sep="", collapse=" ")
  str_replace(s, " \\(.*\\)", "")
}

number.to.phone <- function(number){}

df$phone[1][1:3,]

# Data cleaning
df <- df_0 %>%
  filter(grade %in% c('A', 'B', 'C', 'Z', 'P', 'N') &
           !is.na(latitude) & !is.na(longitude)) %>%
  mutate(dba = map_chr(dba, function(x) address(x)),
         building = map_chr(building, function(x) address(x)),
         street = map_chr(street, function(x) address(x)))
  
str_replace(df$street[1], " \\(.*\\)", "")

# test for small sample
df = df[1:100,]



