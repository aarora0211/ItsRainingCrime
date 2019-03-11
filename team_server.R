library("shiny")
library("dplyr")
library("tidyr")
library("hexbin")
my_data <- read.csv("trimmed_data.csv", stringsAsFactors = FALSE)
team_server <- function(input, output) {
  
  
  output$plot1 <- renderPlot({
    
    make_plot_data <- my_data %>%
      filter(rain == input$toggle_rain) %>%
      filter(neighborhood == input$neighborhood) %>% 
      count(subcategory)%>%
      arrange(desc(n))%>%
      top_n(10, n)
    
    plot_1 <- ggplot(data = make_plot_data) +
      geom_col(
        mapping = aes(x = reorder(subcategory, n), y = n, fill = subcategory)) +
      scale_color_brewer(palette = "Spectral") +
      theme(axis.text.x = element_blank(),
            axis.ticks = element_blank())+
      labs(
        title = "Most frequent crimes",
        x = "Crime",
        y =  "number of occurences"
      )
    plot_1
  })
  
  output$plot2 <- renderPlot({
    
    second_plot_data <- my_data %>%
      filter(rain == TRUE) %>%
      filter(neighborhood == input$neighborhood) %>% 
      select(subcategory, PRCP, neighborhood)
    
    plot_two <- ggplot(data = second_plot_data) +
      geom_point(
        mapping = aes(x = PRCP, y = subcategory)) +
      labs(
        title = "Precipitation level and spacific crime",
        x = "precipitation level",
        y =  "type of crime"
      )
    
    plot_two
  })
  
  output$plot3 <- renderPlot({
    
    third_plot_data <- my_data %>%
      filter(rain == input$toggle_rain) %>%
      filter(neighborhood == input$neighborhood) %>%
      select(subcategory, PRCP, neighborhood) %>%
      count(subcategory, PRCP, neighborhood)
    
    plot_3 <- ggplot(data = third_plot_data) + 
      geom_hex(mapping = aes(x = n, y = PRCP))+
      labs(
        title = "Precipitation level and crime",
        x = "number of occurences",
        y =  "precipitation level"
      )
    plot_3
  })
}