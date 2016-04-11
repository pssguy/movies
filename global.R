library(shiny)
library(shinydashboard)

library(dplyr)
library(tidyr)
library(readr)
library(plotly)
library(DT)


# gender datafiles
actor_list <- read_csv("data/actor_list.csv")
box_office <- read_csv("data/box_office.csv")
meta_data7 <- read_csv("data/meta_data7.csv")
scriptLinks <- read_csv("data/scriptLinks.csv")
character_list5 <- read_csv("data/character_list5.csv")

filmCharacters <-
  character_list5 %>% 
  left_join(meta_data7) %>% 
  arrange(desc(words))

filmCharacters$age <- as.numeric(filmCharacters$age)