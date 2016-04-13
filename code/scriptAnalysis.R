df <- character_list5 %>%
  left_join(scriptLinks)

glimpse(df)

# colnames(df) <- c("script_id",                  "imdb_character_name" ,       "words",                      "gender",                     "age" ,                       "imdb_id" ,                  
# "title" ,                     "year"   ,                    "gross(adjusted)", "link")                      




gender <-  df %>%
  group_by(script_id, title, gender) %>%
  summarize(totWord = sum(words)) %>%
  spread(gender, totWord, fill = 0) %>%
  mutate(all = f + m,
         f_pc = round(100 * f / all, 1),
         m_pc = 100 - f_pc) %>%
  ungroup() %>%
  arrange(f_pc) %>%
  inner_join(scriptLinks)

colnames(gender) <- c("script_id" ,                 "title"  ,                    "?"  ,                        "f"    ,                      "m"     ,                     "all",                       
                       "f_pc" ,                      "m_pc"   ,                   "imdb_id"    ,                "year"   ,                    "gross_adjusted" ,"link"  )

gender$title <- as.character(gender$title)
gender$decade <-
  cut(
    gender$year,
    breaks = c(1920, 1929, 1939, 1949, 1959, 1969, 1979, 1989, 1999, 2009, 2019),
    labels = c(
      "1920s",
      "1930s",
      "1940s",
      "1950s",
      "1960s",
      "1970s",
      "1980s",
      "1990s",
      "2000s",
      "2010s"
    )
  )
glimpse(gender)



output$genderWordsTable <- renderPlotly({
  gender %>%
    select(title,all_Words=all,f_pc,year,gross_adjusted) %>% 
     DT::datatable(class='compact stripe hover row-border order-column',rownames=FALSE,options= list(paging = TRUE, searching = TRUE,info=FALSE))
})

output$genderWordsChart <- renderPlotly({
  gender %>%
    
    plot_ly(
      y = title,
      x = f_pc,
      mode = "markers",
      color = year,
      colors = c("#132B43", "#56B1F7"),
      hoverinfo = "text",
      text = paste(title, "<br>", year, "<br>", f_pc, "%"),
      source = "A"
    ) %>%
    # add_trace(x = c(st,end), y= c(50,50), mode = "lines", line = list(color = "red",width=2)) %>%
    layout(
      hovermode = "closest",
      title="Select Range to Zoom, Hover for details, Click for Cast List",
      xaxis = list(title = "%", titlefont = list(color = "blue")),
      yaxis = list(title = "Example Titles", titlefont = list(color =
                                                                "blue")),
      margin = list(l = 200)
    )   %>% 
    config(displayModeBar = F,showLink = F)
})


output$genderWordsTitle <- renderText({
  print("enter")
  if (is.null(event_data("plotly_click")))
    return()
  
  s <- event_data("plotly_click", source = "A")
  if (length(s) == 0)
    return()
  
  theTitle <- s[["y"]]
 
  # theYear <- scriptLinks[scriptLinks$title==theTitle,]$year ## could be duplicate titles
  # 
  # theTitle <- paste(theTitle," - ",theYear)
  theTitle
  
  
  
})

output$genderWordsMovie <- DT::renderDataTable({
  if (is.null(event_data("plotly_click")))
    return()
  
  s <- event_data("plotly_click", source = "A")
  if (length(s) == 0)
    return()
  
  # print(s) #with nothing else, this actually prints a table
  
  titleChoice = s[["y"]]
 # print(titleChoice)
  
  df <-  filmCharacters %>%
    filter(title == titleChoice) %>%
    
    
    select(character = imdb_character_name,
           actor = actorName,
           gender = gender.x,
           age,
           words)
    #print(df)
  df %>%
    DT::datatable(
      class = 'compact stripe hover row-border order-column',
      rownames = FALSE,
      options = list(
        paging = FALSE,
        searching = FALSE,
        info = FALSE
      )
    )
  
})