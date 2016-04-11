df <- character_list5 %>% 
  left_join(scriptLinks)

glimpse(df)



gender <-  df %>% 
  group_by(script_id,title,gender) %>% 
  summarize(totWord=sum(words)) %>% 
  spread(gender,totWord,fill=0) %>% 
  mutate(all=f+m,f_pc=round(100*f/all,1),m_pc=100-f_pc) %>% 
  ungroup() %>% 
  arrange(f_pc) %>% 
  inner_join(scriptLinks)

gender$title <- as.character(gender$title)
gender$decade <-cut(gender$year, breaks=c(1920,1929,1939,1949,1959,1969,1979,1989,1999,2009,2019), labels=c("1920s","1930s","1940s","1950s","1960s","1970s","1980s","1990s","2000s","2010s"))


output$genderWordsChart <- renderPlotly({
gender %>% 
  #  group_by(decade) %>% 
  
  plot_ly(y=title,x=f_pc,mode="markers",color = year,colors = c("#132B43", "#56B1F7"),
          hoverinfo = "text",
          text = paste(title,"<br>",year,"<br>",f_pc,"%"),
          source="A") %>% 
  # add_trace(x = c(st,end), y= c(50,50), mode = "lines", line = list(color = "red",width=2)) %>% 
  layout(hovermode = "closest",
         #title="Percent words spoken by female characters<br>(Select Range to Zoom and hover for details)",
         xaxis=list(title="%",titlefont=list(color="blue")),
         yaxis=list(title="Example Titles",titlefont=list(color="blue")),
         margin = list(l = 200)
  )
})


output$genderWordsTitle <- renderText({
  print("enter")
  if(is.null(event_data("plotly_click"))) return()
  
  s <- event_data("plotly_click", source="A")
  if (length(s)==0) return()
  
 title <- s[["y"]]
 print("title")
 print(title)
 
 title
  
  
  
})

output$genderWordsTable <- DT::renderDataTable({
  if(is.null(event_data("plotly_click"))) return()
  
  s <- event_data("plotly_click", source="A")
  if (length(s)==0) return()
  
 # print(s) #with nothing else, this actually prints a table
  
  titleChoice=s[["y"]]
  

  filmCharacters %>%
    #ungroup() %>%
    filter(title==titleChoice) %>%
    #arrange(desc(created)) %>%
    select(character=imdb_character_name,gender,age,words) %>%

    DT::datatable(class='compact stripe hover row-border order-column',rownames=FALSE,options= list(paging = FALSE, searching = FALSE,info=FALSE))
  
})