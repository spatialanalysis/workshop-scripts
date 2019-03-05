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

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("World Population Over Time"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         # sliderInput("bins",
         #             "Number of bins:",
         #             min = 10,
         #             max = 50,
         #             value = 30),
         
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
      
      # Show a plot of the generated distribution
      mainPanel(
         # plotOutput("distPlot"),
         leafletOutput("map"),
         dataTableOutput("table")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   # output$distPlot <- renderPlot({
   #    # generate bins based on input$bins from ui.R
   #    x    <- faithful[, 2] 
   #    bins <- seq(min(x), max(x), length.out = input$bins + 1)
   #    
   #    # draw the histogram with the specified number of bins
   #    hist(x, breaks = bins, col = 'darkgray', border = 'white')
   # })
   
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

