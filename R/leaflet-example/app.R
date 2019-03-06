#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(spData)
library(dplyr)

# Define UI for application that filters map points based on year and minimum population
ui <- fluidPage(
   
   # Application title
   titlePanel("World Population Over Time"),
   
   # Sidebar with a slider input for year, numeric input for population 
   sidebarLayout(
      sidebarPanel(

         sliderInput("year",
                     "Year",
                     min = 1950,
                     max = 2030,
                     step = 5,
                     sep = "",
                     value = 1950),
         
         numericInput("pop_min",
                      "Minimum Population (in millions)",
                      min = 1,
                      max = 20,
                      value = 10)
      ),
      
      # Show the map and table
      mainPanel(
         # plotOutput("distPlot"),
         leafletOutput("map"),
         dataTableOutput("table")
      )
   )
)

# Define server logic required to draw a map and table
server <- function(input, output) {

   
   output$map <- renderLeaflet({
     
     pop_by_year <- filter(urban_agglomerations, 
                           year == input$year,
                           population_millions > input$pop_min)
     
     leaflet(data = pop_by_year) %>%
       addTiles() %>%
       addMarkers()
   })
   
   output$table <- renderDataTable({
     
     pop_by_year <- filter(urban_agglomerations, 
                           year == input$year,
                           population_millions > input$pop_min)
     
     pop_by_year
     
   })
}

# Run the application 
shinyApp(ui = ui, server = server)