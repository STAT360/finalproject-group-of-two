library(shiny)
#Importing the CSV data
data <- read.csv(file = "data/winemag-data_first150k.csv")

# Define UI for app that draws a histogram ----
# User interface ----
ui <- fluidPage(
  titlePanel("censusVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Yikes"),
      
      selectInput("var",
                  label = "Choose a country to display",
                  choices = unique(country),
                  selected = ("US")),
      
      sliderInput("range",
                  label = "Range of points:",
                  min = 0, max = 100, value = c(0, 100)),
      
      numericInput("obs", "Minimum Price:", 0, min = 0, max = 2300),
      numericInput("obs", "Maximum Price:", 2300, min = 0, max = 2300)
      
    ),
    
      numericInput("obs", "Minimum Price:", 0, min = 0, max = 2300),
    

    

  )
)

# Server logic ----
server <- function(input, output) {
  output$map <- renderPlot({
    
    data <- switch(input$var,
                   "Percent White" = counties$white,
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian)
    
    color <- switch(input$var,
                    "Percent White" = "darkgreen",
                    "Percent Black" = "black",
                    "Percent Hispanic" = "darkorange",
                    "Percent Asian" = "darkviolet")
    
    legend <- switch(input$var,
                     "Percent White" = "% White",
                     "Percent Black" = "% Black",
                     "Percent Hispanic" = "% Hispanic",
                     "Percent Asian" = "% Asian")
    
    percent_map(var = data, color , legend, max = input$range[1], min = input$range[2])
  })
}

# Run app ----
shinyApp(ui, server)
