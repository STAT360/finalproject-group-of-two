library(shiny)
library(ggplot2)
library(dplyr)
library(stringr)
library(shinyWidgets)

#Importing the CSV data
data <- read.csv(file = "data/winemag-data_first150k.csv")

# Define UI for app that draws a histogram ----
# User interface ----

ui <- fluidPage(theme = "style.css", 
                
 

  titlePanel("Wines of the World"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Select options to filter your wine choices"),
      
      pickerInput("selectedCountry","Country", choices=levels(unique(data$country)), 
                  options = list(`actions-box` = TRUE), selected= "US", multiple = T),
      
      textInput("selectedDescription",
                 "Use one word to describe your favorite type of wine",
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
                  tabPanel("Fun Stuff", plotOutput("Price"), plotOutput("Points"), plotOutput("PricePoints")),
                  tabPanel("Summary", plotOutput("SummaryCountry"), plotOutput("SummaryPoints"))
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
      filter(country %in% input$selectedCountry, price >= input$min, price <= input$max, points >= input$range[1], points <= input$range[2], str_detect(description,input$selectedDescription))
  })
  
  observe({
    print(input$selectedCountry)
  })
  
  #This is where the plots/graphs are actually genertated. Example:

  output$Points <- renderPlot({
    ggplot(filtered(), aes(points)) +
      geom_bar(fill = "#7f1a1a") +
      labs(title= "Distribution of Score", x= "Score") +
      xlim(80,100) 
  })
  
  output$Price <- renderPlot({
    ggplot(filtered(), aes(price)) +
      geom_bar(fill = "#7f1a1a") +
      labs(title= "Distribution of Price", x= "Price") 
  })
  
  output$SummaryCountry <- renderPlot({
    data %>% 
      group_by(gr = cut(points, breaks = seq(0, 100, by = 5) - 
                          .Machine$double.eps, right = FALSE)) %>% 
      ggplot() +
        geom_bar(mapping = aes(x = gr, fill = country), position = "fill") +
        labs(fill = "Countries", y = "proportion", title = "Proportion of Countries in Point Range") +
        scale_x_discrete(name = "point range", labels = c("75-80", "80-85", "85-90", "90-95", "95-100"))
      
  })
  
  output$SummaryPoints <- renderPlot({
    data %>% 
      group_by(gr = cut(price, breaks = seq(0, 2300, by = 230) - 
                          .Machine$double.eps, right = FALSE)) %>% 
      ggplot() +
        geom_bar(mapping = aes(x = gr, fill = country), position = "fill") +
        labs(fill = "Countries", y = "proportion", title = "Proportion of Countries in Price Range") +
        scale_x_discrete(name = "price range", labels = c("0-230", "230-460", "460-690", "690-920", "920-1150", "1150-1380", "1380-1610", "1610-1930", "1930-2070", "2070-2300"))
  })
  
  output$PricePoints <- renderPlot({
    ggplot(filtered(), aes(x=points, y=price))+
      geom_point(color="#7f1a1a") +
      geom_smooth(method="lm", color="#7f1a1a") +
      labs(title="Price vs. Points", x="Points", y="Price")
  })
}

# Run app ----
shinyApp(ui, server)
