library(shiny)
library(ggplot2)
library(dplyr)
library(stringr)
library(shinydashboard)
#Importing the CSV data
data <- read.csv(file = "data/winemag-data_first150k.csv")

# Define UI for app that draws a histogram ----
# User interface ----
ui <- fluidPage(

  titlePanel("Wines of the World"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Select options to filter your wine choices"),
      
      selectInput("selectedCountry",
                  label = "Choose a country to display",
                  choices = unique(data$country),
                  selected = ("US")),
      
      textInput("selectedDescription",
                 "Use one word to describe your favorite type of wine",
                 value = "Warm",
                 placeholder = NULL),
      
      sliderInput("range",
                  label = "Range of points:",
                  min = 80, max = 100, value = c(80, 100)),
      
      numericInput("min", "Minimum Price:", 0, min = 0, max = 2300),
      numericInput("max", "Maximum Price:", 2300, min = 0, max = 2300)
      
    ),
    
    mainPanel(
      
      tabsetPanel(type = "tabs",
                  #Reference to graphs should be placed here, actual graph code goes in server. Example:
                  tabPanel("Fun Stuff", plotOutput("Price"), plotOutput("Points")),
                  tabPanel("Summary", plotOutput("summary_1"))
      )
        
    )
  )
)
  


# Server logic ----
server <- function(input, output) {
  #This is where we filter the data based on selected inputs. We need to fill out the filter() function based
  #on what we select from the inputs.
  filtered <- reactive({
    data %>%
      filter(country == input$selectedCountry, price >= input$min, price <= input$max, points >= input$range[1], points <= input$range[2], str_detect(description,input$selectedDescription))
  })
  
  
  #This is where the plots/graphs are actually genertated. Example:

  output$Points <- renderPlot({
    ggplot(filtered(), aes(points)) +
      geom_histogram(color="darkred") +
      labs(title= "Distribution of Points", x= "Points", y= "Count") +
      xlim(80,100) 
  })
  
  output$Price <- renderPlot({
    ggplot(filtered(), aes(price)) +
      geom_density() +
      ggtitle("Density Plot of Price for Selected District")
  })
}

# Run app ----
shinyApp(ui, server)
