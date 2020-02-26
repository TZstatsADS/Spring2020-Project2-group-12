library(shiny)
library(dplyr)
library(tools)
library(tidyverse)
library(lubridate)
library(dbplyr)
library(dbplot)
library(DBI)
library(plotly)


# ================== Load Data ===================
# Load Data
# df_0 <- read.csv("../data/processed_df.csv")


# ================== Text Processing & Data cleaning ===================
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

#  =================== Load Cleaned Data ===================
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
load('../output/df.RData') 


#  =================== Grade ===================
# Extract grade
grade <- df %>%
  filter(grade %in% c('A', 'B', 'C', 'Z', 'P', 'N'))

graderA <- df[df$grade == "A",] 
graderB <- df[df$grade == "B",]
graderC <- df[df$grade == "C",]
graderZ <- df[df$grade == "Z",] 
graderP <- df[df$grade == "P",] 
graderN <- df[df$grade == "N",] 



## ============ Cuisine & Grade ===============
df_cuisine_grade <- df %>% group_by(cuisine,grade) %>% 
  dplyr::summarise(freq = n()) %>% 
  dplyr::arrange(desc(freq)) %>% 
  ungroup() %>% 
  group_by(cuisine) %>% 
  filter(cuisine %in% c("American", "Chinese", "Mexican", "Italian", "Japanese", "Caribbean", "Spanish"))  # top 11 most popular restaurants

ame_cuisine_grade <- df_cuisine_grade %>% filter(cuisine == "American") %>%
  dplyr::mutate(perc= freq / sum(freq)) %>% 
  arrange(desc(perc)) %>% 
  mutate(perc_cumsum=cumsum(perc), 
         ymin = c(0, head(perc_cumsum, n=-1)),
         midpoint = cumsum(perc) - perc / 2, 
         grade = factor(grade, levels = rev(as.character(grade))))

chn_cuisine_grade <- df_cuisine_grade %>% filter(cuisine == "Chinese") %>%
  dplyr::mutate(perc= freq / sum(freq)) %>% 
  arrange(desc(perc)) %>% 
  mutate(perc_cumsum=cumsum(perc), 
         ymin = c(0, head(perc_cumsum, n=-1)),
         midpoint = cumsum(perc) - perc / 2, 
         grade = factor(grade, levels = rev(as.character(grade))))

mexican_cuisine_grade <- df_cuisine_grade %>% filter(cuisine == "Mexican") %>%
  dplyr::mutate(perc= freq / sum(freq)) %>% 
  arrange(desc(perc)) %>% 
  mutate(perc_cumsum=cumsum(perc), 
         ymin = c(0, head(perc_cumsum, n=-1)),
         midpoint = cumsum(perc) - perc / 2, 
         grade = factor(grade, levels = rev(as.character(grade))))

jap_cuisine_grade <- df_cuisine_grade %>% filter(cuisine == "Japanese") %>%
  dplyr::mutate(perc= freq / sum(freq)) %>% 
  arrange(desc(perc)) %>% 
  mutate(perc_cumsum=cumsum(perc), 
         ymin = c(0, head(perc_cumsum, n=-1)),
         midpoint = cumsum(perc) - perc / 2, 
         grade = factor(grade, levels = rev(as.character(grade))))

carib_cuisine_grade <- df_cuisine_grade %>% filter(cuisine == "Caribbean") %>%
  dplyr::mutate(perc= freq / sum(freq)) %>% 
  arrange(desc(perc)) %>% 
  mutate(perc_cumsum=cumsum(perc), 
         ymin = c(0, head(perc_cumsum, n=-1)),
         midpoint = cumsum(perc) - perc / 2, 
         grade = factor(grade, levels = rev(as.character(grade))))

spn_cuisine_grade <- df_cuisine_grade %>% filter(cuisine == "Spanish") %>%
  dplyr::mutate(perc= freq / sum(freq)) %>% 
  arrange(desc(perc)) %>% 
  mutate(perc_cumsum=cumsum(perc), 
         ymin = c(0, head(perc_cumsum, n=-1)),
         midpoint = cumsum(perc) - perc / 2, 
         grade = factor(grade, levels = rev(as.character(grade))))

p <- plot_ly() %>% 
  add_pie(data = ame_cuisine_grade, labels = ~grade, values = ~perc,
          name = "American",
          marker = list(colors= c( "#56B4E9","#E69F00", "#009E73", "#CC79A7", "#D55E00")),
          domain = list(row = 0, column = 0),
          textinfo = 'label') %>% 
  add_pie(data = chn_cuisine_grade, labels = ~grade, values = ~perc,
          name = "Chinese",
          domain = list(row = 0, column = 1),
          textinfo = 'label')  %>% 
  add_pie(data = mexican_cuisine_grade, labels = ~grade, values = ~perc,
          name = "Mexican",
          domain = list(row = 0, column = 2),
          textinfo = 'label')  %>% 
  add_pie(data = jap_cuisine_grade, labels = ~grade, values = ~perc,
          name = "Japenese",
          domain = list(row = 1, column = 0),
          textinfo = 'label')  %>% 
  add_pie(data = carib_cuisine_grade, labels = ~grade, values = ~perc,
          name = "Caribbean",
          domain = list(row = 1, column = 1),
          textinfo = 'label')  %>% 
  add_pie(data = spn_cuisine_grade, labels = ~grade, values = ~perc,
          name = "Spanish",
          domain = list(row = 1, column = 2),
          textinfo = 'label')  %>% 
  layout(title = "Grades by Cuisine", showlegend = F,
         grid=list(rows=2, columns=3),
         annotations = list(
           list(x = 0.08 , y = 1, text = "American", showarrow = F, xref='paper', yref='paper'),
           list(x = 0.50 , y = 1, text = "Chinese", showarrow = F, xref='paper', yref='paper'),
           list(x = 0.90 , y = 1, text = "Mexican", showarrow = F, xref='paper', yref='paper'),
           list(x = 0.08 , y = 0.46, text = "Japenese", showarrow = F, xref='paper', yref='paper'),
           list(x = 0.50 , y = 0.46, text = "Caribbean", showarrow = F, xref='paper', yref='paper'),
           list(x = 0.90 , y = 0.46, text = "Spanish", showarrow = F, xref='paper', yref='paper'))) 
p


## =============== Bar Plot ===============
df <- df %>% 
  mutate(violation.short.desp = ifelse(str_detect(violation.code, "02"), "Food Temperature Prob",
                                       ifelse(str_detect(violation.code, "(03)|(09)"),"Food Source Questionable",
                                              ifelse(str_detect(violation.code, "(04[A-J])|(06)"),"Hygiene/Food Not Protected",
                                                     ifelse(str_detect(violation.code, "04[K-O]"), "Live Rats/Mice/Roaches/Flies...",
                                                            ifelse(str_detect(violation.code, "05"), "Facility Design Prob",
                                                                   ifelse(str_detect(violation.code, "08"), "Garbage Prob", "Facility Maintenance")
                                                            )
                                                     )
                                              )
                                       )
                                )
  )

borough <- df %>% 
  select(boro, violation.short.desp) %>% 
  group_by(boro, violation.short.desp) %>%
  count(name = "freq")
  # ungroup() %>% filter(violation.short.desp!= "NULL") %>% 
  # pivot_wider(names_from = boro, values_from = freq)
  
#borough$all <- rowSums(borough[,-1])  

