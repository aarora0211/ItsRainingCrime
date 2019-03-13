library(shiny)
data <- read.csv("trimmed_data.csv", stringsAsFactors = F)
neighborhoods <- unique(data$neighborhood)
team_ui <- fluidPage(
  
            titlePanel(h1("Its Raining Crime")),  #title of the app
           
  sidebarLayout(
    sidebarPanel(
      radioButtons(inputId ="toggle_rain", label = "Rainfall",
                   choices = c("Rain" = TRUE, "No Rain" = FALSE), selected = TRUE),
      selectInput(inputId = "neighborhood", label = "Select a Neighborhood", choices = neighborhoods,
                  selected = "UNIVERSITY")
    ),
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Introduction", htmlOutput("intro")),
                  tabPanel("Fequency of Crime", plotOutput("plot1"), textOutput("text1")),
                  tabPanel("Precipitation and Specific Crime", plotOutput("plot2"), tags$strong(textOutput("disclaimer")), textOutput("text2")),
                  tabPanel("Precipitation and Overall Crime ", plotOutput("plot3"), tags$strong(textOutput("disclaimer2")), textOutput("text3")),
                  tabPanel("Temperature and Crime", plotOutput("plot4"), textOutput("text4")),
                  tabPanel("Crime and Time of Year", plotOutput("plot5"), textOutput("text5"))
                )
    )
  )
)

