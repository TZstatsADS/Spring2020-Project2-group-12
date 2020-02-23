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
# df_0 <- read.csv("../data/processed_df.csv")


# ================== Text Processing ===================
# https://rstudio-pubs-static.s3.amazonaws.com/408658_512da947714740b99253228f084a08a9.html
# to.upper <- function(word){
#   string <- strsplit(as.character(word), " ")[[1]]
#   s <- paste(substring(string, 1,1), tolower(substring(string, 2)), sep="", collapse=" ")
#   str_replace(s, " \\(.*\\)", "")
# }
# 
# number.to.phone <- function(number){
#   first <- substring(number,1,3)
#   second <- substring(number, 4,6)
#   third <- substring(number, 7, 9)
#   paste0("(", first, ") ", second, "-", third)
# }
# 
# address <- function(building, street, boro, zipcode){
#   if(boro == "Manhattan") boro = "New York"
#   paste0(building, " ", street, ", ", boro, ", ", "NY ", zipcode) 
# }


#  =================== Data cleaning ===================
ViolationType <- list(
  "04"= "Evidence of Mice/Roches/Flies",
  "02"= "Food Temperature",
  "06"= "Food Contact Surfaces Not Clean and Sanitized",
  "08"= "Pest Related Facility Use",
  "10"= "Non-food Contact Surfaces/Facility Improperly Constructed")

# df <- df_0 %>%
#   filter(grade %in% c('A', 'B', 'C', 'Z', 'P', 'N') &
#            !is.na(latitude) & !is.na(longitude)) %>%
#   mutate(dba = map_chr(dba, function(x) to.upper(x)),
#          building = map_chr(building, function(x) to.upper(x)),
#          street = map_chr(street, function(x) to.upper(x)),
#          phone = map_chr(phone, function(x) number.to.phone(x)),
#          boro = as.character(boro),
#          address = address(building, street, boro, zipcode))%>% 
#   mutate(violation.short.desp = ViolationType[substring(violation.code, 0, 2)])
# 
# 
# save(df, file="../output/df.RData")

load('../output/df.RData') 

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








#Statistics Analysis Global Enviroment 

#Loading the required data:

# load("data_finale.RData")
# 
# p <- plot_ly() %>%
#   add_pie(data = crime_sex, labels = ~sex, values = ~amount,
#           name = "The Crime Victim Sex Distribution Chart",
#           marker = list(colors=c("#ff427b","#42e3ff")),
#           domain = list(row = 0, column = 0)) %>%
#   add_pie(data = crime_race, labels = ~race, values = ~ amount,
#           name = "The Crime Victim Race Distribution Chart",
#           
#           domain = list(row = 0, column = 1)) %>%
#   add_pie(data = crime_num, labels = ~type, values = ~ amount,
#           title = "The Crime Severity Distribution Chart",
#           marker = list(colors=c("#ff0000","#ff7017","#ffff00")),
#           domain = list(row = 0, column = 2)) %>%
#   layout(title = "Pie Chart Summary of Crime Data", showlegend = F,
#          grid=list(rows=1, columns=3),
#          xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
#          yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
# 
# plot_muliti_crime <-ggplot(crime_hour_boro, aes(hour, crime_weighted, color = boro)) + geom_line() +
#   ggtitle("Danger Index Per Hour in each Borough") +
#   labs (x = "Time", y = "Danger Index") +
#   theme_grey(16) +
#   theme(legend.title = element_blank())+
#   scale_x_continuous(breaks = round(seq(0, 23, by = 1),1)) 

df_cuisine_grade <- df %>% group_by(cuisine,grade) %>% 
  dplyr::summarise(freq = n()) %>% 
  dplyr::arrange(desc(freq)) %>% 
  ungroup() %>% 
  group_by(cuisine) %>% 
  dplyr::mutate(perc=100*round(freq / sum(freq))) %>% 
  filter(cuisine %in% c("American", "Chinese", "Café/Coffee/Tea", "Pizza", "Mexican", "Italian", "Japanese"))  # top 10 most popular restaurants

df_cuisine_grade %>% ggplot(aes(x=0, y=freq, fill=cuisine)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = freq), position = position_stack(vjust = 0.5)) +
  scale_x_continuous(expand = c(0,0)) +
  coord_polar("y") + 
  facet_wrap(~cuisine) +
  labs(title = 'Deaths', subtitle = 'in perventages') +
  theme_minimal()
