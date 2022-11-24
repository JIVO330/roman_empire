
library("shiny")
library("shinyWidgets")
   library(leaflet)


 ui <- fluidPage(
   # Load libraries
  
   # Make data with several positions
   data_red=data.frame(LONG=42+rnorm(10), LAT=23+rnorm(10), PLACE=paste("Red_place_",seq(1,10))),
   data_blue=data.frame(LONG=42+rnorm(10), LAT=23+rnorm(10), PLACE=paste("Blue_place_",seq(1,10))),
   
   # Initialize the leaflet map:
   leaflet() %>% 
     setView(lng=42, lat=23, zoom=8 ) %>%
     # Add two tiles
     addProviderTiles("Esri.WorldImagery", group="background 1") %>%
     addTiles(options = providerTileOptions(noWrap = TRUE), group="background 2") %>%
     # Add 2 marker groups
     addCircleMarkers(data=data_red, lng=~LONG , lat=~LAT, radius=8 , color="black",  fillColor="red", stroke = TRUE, fillOpacity = 0.8, group="Red") %>%
     addCircleMarkers(data=data_blue, lng=~LONG , lat=~LAT, radius=8 , color="black",  fillColor="blue", stroke = TRUE, fillOpacity = 0.8, group="Blue") %>%
     # Add the control widget
     addLayersControl(overlayGroups = c("Red","Blue") , baseGroups = c("background 1","background 2"), options = layersControlOptions(collapsed = FALSE)),
   
   
   
   
 ) 
   

 server <- function(input, output, session) {
  
 }

 shinyApp(ui = ui, server = server)

# app = shinyApp(
#   ui = fluidPage(
#     sidebarLayout(
#       sidebarPanel( sliderInput("Height",
#                                 "Height in Pixels:",
#                                 min = 100,
#                                 max = 2000,
#                                 value = 500)
#       ),
#       
#       mainPanel(
#         uiOutput("leaf")
#         
#       )
#     )
#   ),
#   server = function(input, output) {
#     output$leaf=renderUI({
#       leafletOutput('myMap', width = "200%", height = input$Height)
#     })
#     
#     output$myMap = renderLeaflet(leaflet() %>% addTiles() %>% setView(-93.65, 42.0285, zoom = 17))
#   }
# )
