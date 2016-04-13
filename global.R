library(shiny)
library(shinydashboard)
library(markdown)
library(rmarkdown)

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
imdb_mapping <- read_csv("data/imdb_mapping.csv")

# original
# filmCharacters <-
#   character_list5 %>% 
#   left_join(meta_data7) %>% 
#   arrange(desc(words))

# enables actor name as well but lots missing although age provided
filmCharacters <-
  imdb_mapping %>% 
  left_join(meta_data7) %>% 
  arrange(desc(words)) %>% 
  left_join(actor_list,by=c("closest_imdb_character_id"= "actor_imdb_id")) %>% 
  rename(actorName=name)

filmCharacters$age <- as.numeric(filmCharacters$age)

print(glimpse(filmCharacters))