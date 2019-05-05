library(shiny)
#Importing the CSV data
data <- read.csv(file = "data/winemag-data_first150k.csv")

# Define UI for app that draws a histogram ----
ui <- fluidPage(
  titlePanel(""),
  
  sidebarLayout(
    sidebarPanel(
      
    ),
    mainPanel(plotOutput("map"))
  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {

}

shinyApp(ui, server)