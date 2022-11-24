


######VERSION 0003.1MAP

library(shiny)
library(tidyverse)
library(ggplot2)
library(bslib)
library(maps)
library(leaflet)
library(shinyWidgets)
#library(here)

roman_empire <- read_csv("re_data/roman_empire.csv")

roman_empire

modern_city <- roman_empire %>% 
  distinct(modern_toponym) %>% 
  arrange(modern_toponym) %>% 
  pull()

ancient_city <- roman_empire %>% 
  distinct(ancient_toponym) %>% 
  arrange(ancient_toponym) %>% 
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
      (fluidRow(
        
        column(3,
               selectInput("modern_top_input", label = h3("Modern Toponym"), #h3 size phrase()
                           choices = list("Alejandria" = 1, "Tiro" = 2, "Cartago" = 3), 
                           selected = 1)
        ),
        column(3,
               selectInput("Province_input", label = h3("Imperial Province"), #h3 size phrase()
                           choices = list("Germania" = 1, "Panonia" = 2, "Judea" = 3), 
                           selected = 1)
        ),
        column(3,
               selectInput("country_input", label = h3("Modern Country"), #h3 size phrase()
                           choices = list("Spain" = 1, "Tunisia" = 2, "Egipt" = 3), 
                           selected = 1)
        ),
        column(3,
               selectInput("rights_input", label = h3("Civic Status"), #h3 size phrase()
                           choices = list("Athenas" = 1, "Esparta" = 2, "Corinto" = 3), 
                           selected = 1)
        )
        
       )
      
      )
    ),
    tabPanel("Map",
             tags$audio(src = "music/rome3.mp3",type = "audio/mp3", autoplay = TRUE, controls = NA),
             br(),
             br(),
             h3("Here you can explore the different locations of the Roman cities. Choose a name from the list and it will be displayed in the map. If you click in the blue circle, you will see its Roman name"),
             br(),
             selectInput(
             inputId = "city",
             label = h3("Modern City"),
             choices = modern_city,
             selected = 1 ),
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
      br(),
      h3("This shiny dashboar have been created with the intention of fun, enjoy and expand the knowledge over the base of the work of Jack Hanson."),
      br(),
      h4("As we said, the core of this Database are the monograph of Jack Hanson and his own database - try to be thankfully homenage-"),
      br(),
      h4("Hanson, J. W. (2016a). An Urban Geography of the Roman World, 100 B.C. to A.D. 300. University of Oxford D.Phil."),
      br(),
      h4("Hanson, J. W. (2016b). An Urban Geography of the Roman World, 100 B.C. to A.D. 300. Oxford: Archaeopress."),
      br(),
      h4("Hanson, J. W. (2016). Cities Database (OXREP databases). Version 1.0. Accessed (date): <http://oxrep.classics.ox.ac.uk/databases/cities/>. DOI: <https://doi.org/10.5287/bodleian:eqapevAn8>"),
      br(),
      br(),
      h4("Also, you can visit the website :"),
      br(), 
      br(),
      h3 (tags$a("The Oxford Roman Economy Project", href = "http://oxrep.classics.ox.ac.uk/"  )),
      br(),
      br(),
      h4("The music is part of the Game Caesar III, donwloaded from"),
    ), 
    
    ), 
  
  
  
  
  # # This is the plot to show the cities of the Empire
  # mainPanel(
  #   plotOutput("city_plot")
  # )
  
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  
  output$map_modern_city <- renderLeaflet({
  roman_empire %>%
    filter(modern_toponym == input$city) %>%
    leaflet() %>%
    addTiles() %>%
    addCircleMarkers(lat = ~latitude_y, lng = ~longitude_x, popup = ~ ancient_toponym)
  })
    # second map for choose your city multiple options
  output$map_modern_city_2<- renderLeaflet({
    #input$city_2 %>% 
    roman_empire %>% 
      filter(ancient_toponym == input$city_2) %>% 
      leaflet("res") %>% 
      addTiles() %>%
      addCircleMarkers(lat = ~latitude_y, lng = ~longitude_x, popup = ~ modern_toponym)
  })
 
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
