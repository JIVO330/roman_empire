

######VERSION 0001

library(shiny)
library(tidyverse)
library(ggplot2)
library(bslib)
library(here)

roman_empire <- read_csv("re_data/hanson_cities_reform.csv")

roman_empire


# here:here()
#  roman_empire <- read_csv(here("re_data/hanson_cities_reform.csv"))


# Define UI for application 
ui <- fluidPage(

    # Application title
    titlePanel("THE ROMAN EMPIRE"),
     h2(tags$i("LUX MUNDI")),
     #theme = bs_theme(bootswatch ="slate", version = 5),  
    # creation of 2 spaces/tables
     tabsetPanel(
       tabPanel(
         "SPQR",
         tags$audio(src = "music/rome1.mp3",type ="audio/mp3",autoplay = TRUE, controls = NA),
         (fluidRow
          (
            
            column(4,
                   selectInput("province_input", label = h3("Imperial Province"), #h3 size phrase()
                               choices = #roman_empire$province
                  ),
            column(4,
                   selectInput("city_input", label = h3("Modern city"), #h3 size phrase()
                               choices = #roman_empire$ModernToponym)
                  ),
            # column(4,
            #        radioButtons("rights_input",
            #                     "Civic Status",
            #                     choices = c("StatusA", "StatusB", "StatusC"))
            # 
            #       )
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
        )
    
     ), 





        # This is the plot to show the cities of the Empire
         mainPanel(
            plotOutput("city_plot")
        
)
)
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  # we want to knnow the distribution of cities by Province
  
      # output$city_plot <- renderPlot({
      # roman_empire %>%
      # filter(Province ==input$province_input) %>%
      # filter(ModernToponym == input$city_input) %>%
      # ggplot(aes(x = Province , y = ModernToponym))+
      # geom_point()
    
    

    
}

# Run the application 
shinyApp(ui = ui, server = server)


