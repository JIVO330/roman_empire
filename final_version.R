
######FINAL VERSION. ALLL THE STUFF THAT WORKS

library(shiny)
library(tidyverse)
library(ggplot2)
library(bslib)
library(maps)
library(leaflet)
#library(here)

roman_empire <- read_csv("re_data/roman_empire.csv")

roman_empire

imperial_province <- roman_empire%>% 
  distinct(province) %>% 
  arrange(province) %>% 
  pull()

modern_city <- roman_empire %>% 
  distinct(modern_toponym) %>% 
  arrange(modern_toponym) %>% 
  pull()

ancient_city <- roman_empire %>% 
  distinct(ancient_toponym) %>% 
  arrange(ancient_toponym) %>% 
  pull()

status <- roman_empire %>% 
  distinct(civic_status) %>% 
  arrange(civic_status) %>% 
  pull()

country <- roman_empire %>% 
  distinct(country) %>% 
  arrange(country) %>% 
  pull()


# Define UI for application 
ui <- fluidPage(
  
  # Application title
  titlePanel("THE ROMAN EMPIRE"),
  h2( tags$i("LUX MUNDI")),
  theme = bs_theme(bootswatch = "sketchy" ),  
  # creation of 2 spaces/tables
  tabsetPanel(
    tabPanel(
      "SPQR",
      tags$audio(src = "music/rome1.mp3",type ="audio/mp3",autoplay = TRUE, controls = NA),
      (fluidRow (
        
        column(4,
               selectInput("imperial_province", label = h3("Imperial Province"), #h3 size phrase()
                           choices = imperial_province)
        ),
        leafletOutput("imperial_province"),
        plotOutput("city_plot"),
        
        br(),
        column(4,
               selectInput("country",label = h3("Country"),
                           choices = country)
        ),
        leafletOutput("country"),
      
      )
    )
      
),
    tabPanel("Map",
             tags$audio(src = "music/rome3.mp3",type = "audio/mp3", autoplay = TRUE, controls = NA),
             br(),
             br(),
             h3("Here you can explore the different locations of the Roman cities. Choose a name from the list and it will be displayed in the map. If you click in the blue circle, you will see its Roman name"),
             br(),
             selectInput("city",label = h3("Modern City"),
                         choices = modern_city, selected = 1),
             leafletOutput("map_modern_city"),
             
             br(),
             h3('Now, you can pick up few cities ... but they are under their ancient toponym'),
             
             multiInput(    # pickup few cities but dont work properly
               inputId = "city_2", label = h3("Imperial Cities"),
               choices = ancient_city,
               selected = "Abae", width = "400px",
               options = list(
                 enable_search = TRUE,
                 non_selected_header = "Pick few cities:",
                 selected_header = "Are you sure?:")
             ),
             #verbatimTextOutput(outputId = "res") ,
             
             leafletOutput("map_modern_city_2"),
             
             verbatimTextOutput(outputId = "res") ,
             
    ),
      tabPanel(
      "About",# About the app
      tags$audio(src = "music/rome2.mp3",type ="audio/mp3",autoplay = TRUE, controls = NA),
      br(),
      h3("This shiny dashboar have been created with the intention of having fun, enjoying and expanding the knowledge about the Roman Empire over the base o Jack Hanson's work."),
      br(),
      h4("As stated, the core of this database are  Jack Hanson's monograph and his own database - it tries  to be a tribute of gratitude-"),
      br(),
      h4("Hanson, J. W. (2016a). An Urban Geography of the Roman World, 100 B.C. to A.D. 300. University of Oxford D.Phil."),
      br(),
      h4("Hanson, J. W. (2016b). An Urban Geography of the Roman World, 100 B.C. to A.D. 300. Oxford: Archaeopress."),
      br(),
      h4("Hanson, J. W. (2016). Cities Database (OXREP databases). Version 1.0. Accessed (date): <http://oxrep.classics.ox.ac.uk/databases/cities/>. DOI: <https://doi.org/10.5287/bodleian:eqapevAn8>"),
      br(),
      h4("Also, you can visit the website :"),
      br(), 
      h3 (tags$a("The Oxford Roman Economy Project", href = "http://oxrep.classics.ox.ac.uk/"  )),
      br(),
      h4 (tags$a( "The music is part of the Game Caesar III, donwloaded from here", href = "https://www.gamepressure.com/download.asp?ID=775572")),
    ), 
   
  ), 
  
  
  
  
  
  # # This is the plot to show the cities of the Empire. Here you will see in all the 'pages'
  #mainPanel()
  
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  #SPQR TAB
  output$imperial_province <- renderLeaflet({
    roman_empire %>%
      filter(province == input$imperial_province) %>%
      leaflet() %>%
      addTiles() %>%
      addCircleMarkers(lat = ~latitude_y, lng = ~longitude_x, popup = ~ modern_toponym)
  })
  
  
  
  #SPQR TAB
  output$city_plot <- renderPlot(
      roman_empire %>%
      filter(province == input$imperial_province) %>%
      #filter(ModernToponym == input$city_input) %>%
      ggplot(aes(x = modern_toponym , y = province , fill = civic_status))+
      geom_col()+
      theme(axis.text.x = element_text(angle = 45, hjust = 1, face = 'italic'))+
        labs(x = "Actual Name",
             y = "Roman Province") 
  ) 
  
  output$country <- renderLeaflet({
    roman_empire %>%
      filter(country == input$country) %>%
      leaflet() %>%
      addTiles() %>%
      addCircleMarkers(lat = ~latitude_y, lng = ~longitude_x, popup = ~ ancient_toponym)
  })
  
  #Top map in MAP tab
  output$map_modern_city <- renderLeaflet(
      roman_empire %>% 
      filter(modern_toponym == input$city) %>% 
      leaflet() %>% 
      addTiles() %>%
      addCircleMarkers(lat = ~latitude_y, lng = ~longitude_x, popup = ~ ancient_toponym)
  )
  
  # second map for choose your city multiple options
  output$map_modern_city_2<- renderLeaflet({
    #input$city_2 %>% 
    roman_empire %>% 
      filter(ancient_toponym %in% input$city_2) %>% 
      leaflet("res") %>% 
      addTiles() %>%
      addCircleMarkers(lat = ~latitude_y, lng = ~longitude_x, popup = ~ modern_toponym)
  })
  
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
