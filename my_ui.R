library(dplyr)
library(ggplot2)
library(shiny)

my_ui <- fluidPage(
  titlePanel("Its Raining Crime"),
  
  sidebarLayout(
    radioButtons(inputId ="toggle_rain", label = "Rainfall",
                 c("Rain" = TRUE, "No Rain" = FALSE), selected = "Rain")
    
  ), 
  mainPanel(
    tabsetPanel(type = "tabs",
                tabPanel("Plot", plotOutput("plot")),
                tabPanel("Table", tableOutput("table"))
    )
  )
)