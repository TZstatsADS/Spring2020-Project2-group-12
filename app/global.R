library(shiny)
library(dplyr)
library(tools)
library(tidyverse)
library(lubridate)
library(dbplyr)
library(dbplot)
library(DBI)
library(plotly)
library(tidyr)
library(ggplot2)
library(gganimate)
library(gifski)
library(hexbin)


#  =================== Load Cleaned Data ===================
load('df.RData') 
load('new_data.Rda')


##  =================== Data Overview ===================
df_display <- df %>% 
  select(dba, boro, grade, grade.date, violation_score=score, critical.flag,inspection_date=format_inspection_date,violation.description, phone, address)


##  =================== Data: Mao ===================
df.map <- df %>%
  mutate(violation.description = na_if(as.character(violation.description), "")) %>%
  mutate(violation.description = str_replace(violation.description, "\"\"Wash hands” sign not posted at hand wash facility.",
                                         '"Wash hands” sign not posted at hand wash facility.')) %>%
  filter(!is.na(violation.description)) 


## =============== Bar Plot 1: Boro ===============
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
  dplyr::count(name = "freq") %>%
  ungroup() %>%
  filter(violation.short.desp!= "NULL") %>%
  pivot_wider(names_from = boro, values_from = freq)

borough$all <- rowSums(borough[,-1])

## =============== Bar Plot 2: Cuisine ===============

cuisine <- df %>% filter(violation.short.desp!= "NULL") %>% 
  select(cuisine, violation.short.desp) %>% 
  #filter(cuisine %in%  c("American","Chinese","Mexican","Japanese","Caribbean","Spanish")) %>% 
  group_by(cuisine, violation.short.desp) %>%
  dplyr::count(name = "freq") %>% 
  ungroup() %>% 
  #mutate(freq=ifelse(is.na(freq), 0, freq)) %>% 
  pivot_wider(names_from = cuisine, values_from = freq)

cuisine$all <- rowSums(cuisine[,-1], na.rm = T)
cuisine <- cuisine %>%  select("violation.short.desp","American","Chinese","Mexican","Italian", "Japanese","Caribbean","Spanish", "all") 


## ============ Donut: Cuisine & Grade ===============
df_cuisine_grade <- df %>% group_by(cuisine,grade) %>% 
  dplyr::summarise(freq = n()) %>% 
  dplyr::arrange(desc(freq)) %>% 
  ungroup() %>% 
  group_by(cuisine) %>% 
  filter(cuisine %in% c("American", "Chinese", "Mexican", "Italian", "Japanese", "Caribbean", "Spanish"))  # top 11 most popular restaurants


## =============== Bar Plot 3: Score ===============
# Analysis who are the worst offenders and draw plots later. 
df_critical <- df %>% filter(critical.flag=="Y") %>%
  group_by(dba) %>% 
  dplyr::summarise(sum.score=sum(score)) %>% 
  arrange(desc(sum.score)) %>% 
  mutate(dba = gsub(".*, ","",dba)) %>% head(15)

df_critical$dba <- factor(df_critical$dba, levels = unique(df_critical$dba)[order(df_critical$sum.score, decreasing = TRUE)])

name <- df_critical$dba
score <- df_critical$sum.score
data_critical <- data.frame(score[1:50], name[1:50])  
short <- data_critical
df.bar <- short[order(short$score,decreasing = FALSE),]
par(mar = c(5.1, 7, 4.1, 2.1))


popular <- df %>% 
  filter(critical.flag=="Y") %>% 
  group_by(dba) %>% 
  summarise(branch.no=n(), total_score=sum(score)) %>% 
  arrange(desc(branch.no)) %>%
  head(15) %>% 
  ungroup() %>% 
  mutate(dba = gsub(".*, ","",dba)) %>% 
  mutate(average_score=total_score/branch.no) %>% arrange(desc(average_score))

popular$dba <- factor(popular$dba, levels = unique(popular$dba)[order(popular$average_score, decreasing = TRUE)])



## =============== Bar Plot 4: Year =============== 
load('timeTrend.RData') 

year_data <- tt %>%
  filter(grade %in% c('A','B','C')) %>%
  group_by(inspection_year,boro,grade) %>% 
  summarize(count = n()) %>%
  transmute(grade, percent =(count/sum(count)))

year_perc <- ggplot(year_data, aes(x = factor(inspection_year), y = percent*100, fill = factor(grade))) +
  geom_bar(stat="identity", width = 0.7) +
  labs(x = "Year", y = "percent", fill = "grade") +
  theme_minimal(base_size = 14) 










