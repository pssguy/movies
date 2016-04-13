


dashboardPage(
  skin = "yellow",
  dashboardHeader(title = "Movies"),
  
  dashboardSidebar(
    title = "Movies",
    includeCSS("custom.css"),
    # uiOutput("a"),
    
    sidebarMenu(
      id = "sbMenu",
      
      menuItem("Script Analysis",
               tabName = "gender"),
               
              
               
               
               tags$hr(),
               menuItem(
                 text = "",
                 href = "https://mytinyshinys.shinyapps.io/dashboard",
                 badgeLabel = "All Dashboards and Trelliscopes (14)"
               ),
               tags$hr(),
               
               tags$body(
                 a(
                   class = "addpad",
                   href = "https://twitter.com/pssGuy",
                   target = "_blank",
                   img(src = "images/twitterImage25pc.jpg")
                 ),
                 a(
                   class = "addpad2",
                   href = "mailto:agcur@rogers.com",
                   img(src = "images/email25pc.jpg")
                 ),
                 a(
                   class = "addpad2",
                   href = "https://github.com/pssguy",
                   target = "_blank",
                   img(src = "images/GitHub-Mark30px.png")
                 ),
                 a(
                   href = "https://rpubs.com/pssguy",
                   target = "_blank",
                   img(src = "images/RPubs25px.png")
                 )
               )
      )
    ),
    
    dashboardBody(tabItems(tabItem(
      "gender",
      fluidRow(column(
        width = 6,
        box(width = 12,
            includeMarkdown("about/scriptAnalysis.md")),
        
        box(
          width = 12,
          status = "success",
          solidHeader = TRUE,
          collapsible = T,
          collapsed = F,
          title = "Percent words spoken by female characters",
          footer = "Gross Adjusted is US takings at 2016 dollars",
          plotlyOutput("genderWordsChart"),
          DT::dataTableOutput("genderWordsTable")
          
          
        )
      ),
      column(
        width = 6,
      box(
        width = 12,
        status = "success",
        solidHeader = TRUE,
        collapsible = T,
        collapsed = F,
        title = "Major Characters",
        
        h3(textOutput("genderWordsTitle")),
        DT::dataTableOutput("genderWordsMovie")
        
        
      )
      )
      )
    ))
    
    
    
    
    # tabItem("info",includeMarkdown("info.md"))
    
  )
)
  