library("shiny")
library("dplyr")
library("tidyr")
library("ggplot2")
library("hexbin")
my_data <- read.csv("trimmed_data.csv", stringsAsFactors = FALSE)
team_server <- function(input, output) {
  
# Introduction to the program
  
  output$intro <- renderUI({
    
    title <- tags$h2("Introduction")
  
    p1 <- tags$p("This analysis uses data from the National Atmospheric and Oceanic Association
                    (NOAA) that gives information on the amount of precipitation and the temperature, and data from the Seattle 
                    government that gives statistics about crime. The data from NOAA tells us the temperature max, temperature min,
                    whether its raining, and the amount of precipitation. The data from the Seattle government tells us the date, type
                    of crime, and neighborhood. The data about the different types of crime often use local penal codes to describe the
                    specific crime. For example,Car prowl means the theft of something from a car.
                                                                                               ") 
     divider <- tags$hr()  
     
     tab <- tags$br()
                    
     p2 <- tags$p("This data can help to understand trends in crime with a set given of conditions. Law enforcement can use this 
                    information to better prepare and predict crime with respect to the weather.
                    Additionally, we can find trends in crime based on location, type, seasonal time,
                    and time of day.")
     
     link1 <- tags$a(href="https://www.kaggle.com/rtatman/did-it-rain-in-seattle-19482017", "Crime Data Set")
     
     link2 <- tags$a(href="https://catalog.data.gov/dataset/crime-data-76bd0", "Weather Data Set")
     
     names_intro <- tags$h4("Authors")
     
      names <- tags$ul(
                 tags$li("Shivank Mistry"), 
                 tags$li("Akshit Arora"), 
                 tags$li("Benjamin Byrne Morse"),
                 tags$li("Sean Cleary")
               )
     
      HTML(paste(title, divider, p1, tab, tab, p2, divider, link1, tab, link2, divider, names_intro, names))
  })

  output$plot1 <- renderPlot({
# Plot 1
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
# Plot 2    
    second_plot_data <- my_data %>%
      filter(rain == TRUE) %>%
      filter(neighborhood == input$neighborhood) %>% 
      select(subcategory, PRCP, neighborhood)
    
    plot_two <- ggplot(data = second_plot_data) +
      geom_point(
        mapping = aes(x = PRCP, y = subcategory)) +
      labs(
        title = "Precipitation level and specific crime",
        x = "precipitation level",
        y =  "type of crime"
      )
    
    plot_two
  })
  
  output$plot3 <- renderPlot({
# plot 3   
    third_plot_data <- my_data %>%
      #filter(rain == input$toggle_rain) %>%
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
  
  output$plot4 <- renderPlot({
# plot 4
    plot_4_data <- my_data %>%
      filter(rain == input$toggle_rain) %>%
      select(subcategory, PRCP, neighborhood, TMAX) %>%
      filter(neighborhood == input$neighborhood) %>%
      count(subcategory, neighborhood, TMAX)
    
    plot_4 <- ggplot(data = plot_4_data) + 
      geom_hex(mapping = aes(x = n, y = TMAX))+
      labs(
        title = "Cold Weather and Crime",
        x = "number of occurences",
        y =  "Daily High Temperature"
      )
    plot_4
    
  })
  
  output$plot5 <- renderPlot({
# plot 5
    my_data$MonthN <- as.numeric(format(as.Date(my_data$date),"%m")) # Month's number
    
    crime_numbers <- my_data %>% 
      filter((rain == input$toggle_rain)&neighborhood == input$neighborhood) %>% 
      count(MonthN, subcategory)
    
    mean_crimes <- crime_numbers %>% 
      group_by(subcategory) %>% 
      summarize(m = mean(n)) %>% 
      top_n(9, m)
    
    crime_numbers <- crime_numbers %>% 
      inner_join(mean_crimes, by = "subcategory")
    plot_5 <- ggplot(data = crime_numbers, mapping = aes(x = MonthN, y = n, color = subcategory, size = "3")) +
                geom_line() + 
                geom_point() + 
                guides(size = FALSE) +
                scale_x_continuous(breaks = seq(1,12,1),
                                   labels = c("Jan", "Feb", "Mar", "Apr", "May", "June",
                                              "July", "Aug", "Sep", "Oct", "Nov", "Dec")) +
                labs(title = paste0("Seasonal Crimes in ", input$neighborhood), x = "Month", y="Number of Crimes") +
                scale_color_brewer(palette = "Set1")
              
    plot_5
  })
# Description of the first plot
  output$text1 <- renderText({
    text1 <- paste0("Plot 1 shows the top 10 crimes that are commited while raining. The current neighborhood is ",
                    tolower(input$neighborhood), ".")
    text1
    
  })
# Description of the second plot
  output$text2 <- renderText({
    text2 <- paste0("Plot 2 shows the amount of crime with and without rain for each specific crime. This 
                      can also be filtered by neighboorhood.This visualization shows which crimes 
                      are more common in", tolower(input$neighborhood), ".")
    text2
    
  })
# Description of the third plot
  output$text3 <- renderText({
    text3 <- paste0("Plot 3 shows the relationship between the level of rain and the number of crimes
                      commited. The y axis shows percipitation levels and the x axis shows the number of
                     crimes at that percipitation level. The data can be filtered by neighboorhood to 
                     see if there is a diffence by neighboorhood. This visualization shows the affect of rainfall
                    on specific crimes.The current neighborhood is ",
                    tolower(input$neighborhood), ".")
    text3
    
  })
# Description of the fourth plot
  output$text4 <- renderText({
    text4 <- paste0("Plot 4 shows the relationship between temperature and the number of crimes. We want
                       to see if temperature has an effect on crime with and without rain. The plot shows 
                       temperature on the y axis and the number of occurences on the x axis. This visualization
                        can help understand trends in crime based on current weather trends. The current
                       neighborhood is ",
                    tolower(input$neighborhood), ".")
    text4
    
  })
  output$text5 <- renderText({
    text5 <- paste0("This visualization shows the rate of top 9 crimes in over the span of the year. On the x axis,
                    the months are labeled, and on the y axis, the count is plotted. This plot can help identify trends
                    in crime with the seasons. With this information, law enforcement can determine trends in crime and 
                    the time of the year. The current neighborhood being visualized is ", 
                    tolower(input$neighborhood), ".")
    text5
    
  })
  
  output$disclaimer <- renderText({
    disclaimer <- "Notice: Rainfall toggle not applicable to this section"
    disclaimer
  })
  
  output$disclaimer2 <- renderText({
    disclaimer <- "Notice: Rainfall toggle not applicable to this section"
    disclaimer
  })
  
  
}
