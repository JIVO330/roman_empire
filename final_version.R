
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
      "About",# About the app
      tags$audio(src = "music/rome2.mp3",type ="audio/mp3",autoplay = TRUE, controls = NA),
      br(),
      p("This shiny dashboard has been created with the intention of having fun, enjoying and expanding the knowledge about the Roman Empire over Jack Hanson's work."),
      br(),
      p("As stated, the core of this database is Jack Hanson's monograph and database - it tries to be a tribute of gratitude."),
      br(),
      h3("Bibliography"),
      p("- Hanson, J. W. (2016a). An Urban Geography of the Roman World, 100 B.C. to A.D. 300. University of Oxford D.Phil."),
      br(),
      p("- Hanson, J. W. (2016b). An Urban Geography of the Roman World, 100 B.C. to A.D. 300. Oxford: Archaeopress."),
      br(),
      p("- Hanson, J. W. (2016). Cities Database (OXREP databases). Version 1.0. Accessed (date): <http://oxrep.classics.ox.ac.uk/databases/cities/>. DOI: <https://doi.org/10.5287/bodleian:eqapevAn8>"),
      br(),
      h3("Useful Websites"),
      br(), 
      p(tags$a("The Oxford Roman Economy Project", href = "http://oxrep.classics.ox.ac.uk/")),
      br(),
      p(tags$a( "The music is part of the Game Caesar III, donwloaded from here", href = "https://www.gamepressure.com/download.asp?ID=775572")),
    ),
    tabPanel(
      "Provinces",
      tags$audio(src = "music/rome1.mp3",type ="audio/mp3",autoplay = TRUE, controls = NA),
      (fluidRow (
        
        column(4,
               selectInput("imperial_province", label = h3(tags$i("Imperial Province")), #h3 size phrase()
                           choices = imperial_province)
        ),
           leafletOutput("imperial_province"),
           plotOutput("city_plot"),
        
        br(),
        column(4,
               selectInput("country",label = h3(tags$i("Country")),
                           choices = country)
        ),
           leafletOutput("country"),
      
      )
    )
      
),
    tabPanel("Cities",
             tags$audio(src = "music/rome3.mp3",type = "audio/mp3", autoplay = TRUE, controls = NA),
             br(),
             br(),
             h3("Explore the different locations of the Roman cities. Choose a name from the list to display it on the map. Click the blue circle to discover its Roman name"),
             br(),
             selectInput("city",label = h3(tags$i("Modern City")),
                         choices = modern_city, selected = 1),
             leafletOutput("map_modern_city"),
             
             br(),
             h3('Pick up a few cities now... but, be careful, they are under their ancient toponym'),
             
             multiInput(    # pickup few cities but dont work properly
               inputId = "city_2", label = h3(tags$i("Imperial Cities")),
                choices = ancient_city,
                selected = "Abae", width = "400px",
                options = list(
                 enable_search = TRUE,
                 non_selected_header = "Add cities:",
                 selected_header = "Your cities (Click to remove):")
             ),
      
             leafletOutput("map_modern_city_2"),
             
             verbatimTextOutput(outputId = "res") ,
             
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
