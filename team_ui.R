library(shiny)
data <- read.csv("trimmed_data.csv", stringsAsFactors = F)
neighborhoods <- unique(data$neighborhood)
team_ui <- fluidPage(theme = "bootstrap.css",
  
  titlePanel(h3("Its Raining Crime")),
  
  sidebarLayout(
    sidebarPanel(
      radioButtons(inputId ="toggle_rain", label = "Rainfall",
                   choices = c("Rain" = TRUE, "No Rain" = FALSE), selected = TRUE),
      selectInput(inputId = "neighborhood", label = "Select a Neighborhood", choices = neighborhoods,
                  selected = "UNIVERSITY")
    ),
    mainPanel(
     tabsetPanel(type = "tabs",
                  tabPanel("Fequency of Crime", plotOutput("plot1"), textOutput("text1")),
                  tabPanel("Precipitation and Specific Crime", plotOutput("plot2"), textOutput("text2")),
                  tabPanel("Precipitation and Overall Crime ", plotOutput("plot3"), textOutput("text3")),
                  tabPanel("Temperature and Crime", plotOutput("plot4"), textOutput("text4"))
                )
    )
  )
)