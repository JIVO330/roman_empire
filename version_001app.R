

######VERSION 0001

library(shiny)
library(tidyverse)
library(ggplot2)
library(bslib)
#library(here)

roman_empire <- read_csv("re_data/roman_empire.csv")

roman_empire

imperial_province <- roman_empire%>% 
  distinct(province) %>% 
   arrange(province) %>% 
    pull()

status <- roman_empire %>% 
  distinct(civic_status) %>% 
  arrange(civic_status) %>% 
  pull()

modern_city <- roman_empire %>% 
  distinct(modern_toponym) %>% 
  arrange(modern_toponym) %>% 
  pull()

# here:here()
#  roman_empire <- read_csv(here("re_data/roman_empire"))


# Define UI for application 
ui <- fluidPage(

    # Application title
    titlePanel("THE ROMAN EMPIRE"),
     h2(tags$i("LUX MUNDI")),
     #theme = bs_theme(bootswatch ="slate", version = 5),  
    # creation of 3 spaces/tables
     tabsetPanel(
       tabPanel(
         "SPQR",
         tags$audio(src = "music/rome1.mp3",type ="audio/mp3",autoplay = TRUE, controls = NA),
         (fluidRow (
                
              column(4,
                   selectInput("imperial_province", label = h3("Imperial Province"), #h3 size phrase()
                               choices = imperial_province)
                  ),
            
            column(4,
                   selectInput("status",label = h3("Civic Status"),
                                choices = status)
                   ),
            plotOutput("city_plot"),
         )
       )
      
      ),
         tabPanel(
          "About",# About the app
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
          h3 (tags$a("The Oxford Roman Economy Project", href = "http://oxrep.classics.ox.ac.uk/"  ))
        )
    
     ), 




          #if you keep in this position, appear in all the tabs
        # This is the plot to show the cities of the Empire
        # mainPanel()
            
        
   )
  
 

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  # we want to knnow the distribution of cities by Province
  
      output$city_plot <- renderPlot(
      roman_empire %>%
      filter(province == input$imperial_province) %>%
      #filter(ModernToponym == input$city_input) %>%
      ggplot(aes(x = modern_toponym , y = province))+
      geom_col()
      )
    

    
}

# Run the application 
shinyApp(ui = ui, server = server)

# 
# output$city_plot <- renderPlot(
#   roman_empire %>%
#     filter(province == input$imperial_province) %>%
#     #filter(ModernToponym == input$city_input) %>%
#     ggplot(aes(x = province , y = modern_toponym, fill = status))+
#     geom_point()
# )
