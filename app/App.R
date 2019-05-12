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
                  choices = unique(data$country),
                  selected = ("US")),
      
      sliderInput("range",
                  label = "Range of points:",
                  min = 0, max = 100, value = c(0, 100)),
      
      numericInput("obs", "Minimum Price:", 0, min = 0, max = 2300),
      numericInput("obs", "Maximum Price:", 2300, min = 0, max = 2300)
      
    ),
    
    mainPanel(
      #Reference to graphs should be placed here, actual graph code goes in server. Example:
      #plotOutput('Price')
    )
  )
)

# Server logic ----
server <- function(input, output) {
  #This is where we filter the data based on selected inputs. We need to fill out the filter() function based
  #on what we select from the inputs.
  filtered <- reactive({
    dat %>%
      filter()
  })
  
  #This is where the plots/graphs are actually genertated. Example:
  
  #output$Price <- renderPlot({
    #ggplot(filtered(), aes(price)) +
      #geom_density() +
      #ggtitle("Density Plot of Price for Selected District")
  #})
}

# Run app ----
shinyApp(ui, server)
