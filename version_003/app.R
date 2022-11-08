



######VERSION 0003

library(shiny)
library(tidyverse)
library(ggplot2)
library(bslib)
#library(here)

# Define UI for application 
ui <- fluidPage(
  
  # Application title
  titlePanel("THE ROMAN EMPIRE"),
  #subtitlepA("LUX MUNDI"),
  #theme = bs_theme(bootswatch =" " ),  
  # creation of 2 spaces/tables
  tabsetPanel(
    tabPanel(
      "SPQR",
      (fluidRow(
        column(2,
               selectInput("old_top_input", label = h3("Ancient Toponym"), #h3 size phrase()
                           choices = list("Athenas" = 1, "Esparta" = 2, "Corinto" = 3), 
                           selected = 1)
        ),
        column(2,
               selectInput("modern_top_input", label = h3("Modern Toponym"), #h3 size phrase()
                           choices = list("Alejandria" = 1, "Tiro" = 2, "Cartago" = 3), 
                           selected = 1)
        ),
        column(2,
               selectInput("Province_input", label = h3("Imperial Province"), #h3 size phrase()
                           choices = list("Germania" = 1, "Panonia" = 2, "Judea" = 3), 
                           selected = 1)
        ),
        column(2,
               selectInput("country_input", label = h3("Modern Country"), #h3 size phrase()
                           choices = list("Spain" = 1, "Tunisia" = 2, "Egipt" = 3), 
                           selected = 1)
        ),
        column(2,
               selectInput("rights_input", label = h3("Civic Status"), #h3 size phrase()
                           choices = list("Athenas" = 1, "Esparta" = 2, "Corinto" = 3), 
                           selected = 1)
        )
        
        
        
      )
      
      )),
    
    
    
    
    
    
    
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
    ), 
    tabPanel("Map")
    
  ), 
  
  
  
  
  
  # Show a plot of the generated distribution
  # mainPanel(
  #    plotOutput("distPlot")
  # )
  
)


# Define server logic required to draw a histogram
server <- function(input, output) {
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
