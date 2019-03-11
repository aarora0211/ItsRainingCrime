library("shiny")
library("dplyr")
library("tidyr")
my_data <- read.csv("trimmed_data.csv", stringsAsFactors = FALSE)
team_server <- function(input, output) {
  
  output$plot1 <- renderPlot({
    
    make_plot_data <- my_data %>%
      filter(rain == input$toggle_rain) %>%
      filter(neighborhood == input$neighborhood) %>% 
      count(subcategory)%>%
      arrange(desc(n))%>%
      top_n(10, n)
    
    p <- ggplot(data = make_plot_data) +
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
    p
  })
  
  
}