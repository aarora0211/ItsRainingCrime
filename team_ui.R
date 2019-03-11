library(shiny)
data <- read.csv("trimmed_data.csv", stringsAsFactors = F)
neighborhoods <- unique(data$neighborhood)
team_ui <- fluidPage(
  
  titlePanel("Its Raining Crime"),
  
  sidebarLayout(
    sidebarPanel(
      radioButtons(inputId ="toggle_rain", label = "Rainfall",
                   choices = c("Rain" = TRUE, "No Rain" = FALSE), selected = TRUE),
      selectInput(inputId = "neighborhood", label = "Select a Neighborhood", choices = neighborhoods,
                  selected = "UNIVERSITY")
    ),
    mainPanel(
     tabsetPanel(type = "tabs",
                  tabPanel("Plot", plotOutput("plot1")),
                  tabPanel("Table", tableOutput("table"))
                )
    )
  )
)