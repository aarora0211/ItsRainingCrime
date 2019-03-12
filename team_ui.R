library(shiny)
data <- read.csv("trimmed_data.csv", stringsAsFactors = F)
neighborhoods <- unique(data$neighborhood)
<<<<<<< HEAD
team_ui <- fluidPage(theme = "bootstrap.css",
            titlePanel(h1("Its Raining Crime")),  #title of the app
            p("This analysis uses data from the National Atmospheric and Oceanic Association
                              (NOAA) that gives information on the amount of precipitation and the temperature, and data from the Seattle 
              government that gives statistics about crime. The data from NOAA tells us the temperature max, temperature min,
              whether its raining, and the amount of precipitation. The data from the Seattle government tells us the date, type
              of crime, and neighborhood. The data about the different types of crime often use local penal codes to describe the
              specific crime. For example,Car prowl means the theft of something from a car. 
              
              
              This data can help to understand trends in crime with a set given of conditions. Law enforcement can use this 
              information to better prepare and predict crime with respect to the weather.
              Additionally, we can find trends in crime based on location, type, seasonal time,
              and time of day."),


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

