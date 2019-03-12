library(dplyr)
library(ggplot2)
library(scales)
source("analysis.r")

crime_rain_data <- read.csv("trimmed_data.csv", stringsAsFactors = FALSE)


rainy_crimes <- crime_rain_data %>%
  filter(rain == TRUE) %>%
  count(subcategory)%>%
  arrange(desc(n))%>%
  top_n(9, n)

plot1 <- ggplot(data = rainy_crimes) +
  geom_col(
    mapping = aes(x = reorder(subcategory, n), y = n, fill = subcategory)) +
  scale_fill_brewer(palette = "Set1") +
  theme(axis.text.x = element_blank(),
        axis.ticks = element_blank())+
  labs(
    title = "Crime on rainy days",
    x = "Crime",
    y =  "number of occurences while raining"
  )
plot1

second_plot_data <- crime_rain_data %>%
  filter(rain == TRUE) %>%
  select(subcategory, PRCP, neighborhood)
 
  

#View(second_plot_data)

plot_two <- ggplot(data = second_plot_data) +
  geom_point(
    mapping = aes(x = PRCP, y = subcategory)) +
      labs(
        title = "Precipitation level and spacific crime",
        x = "type of crime",
        y =  "precipitation level"
  )

  plot_two


third_plot_data <- crime_rain_data %>%
  filter(rain == TRUE) %>%
  select(subcategory, PRCP, neighborhood) %>%
  filter(neighborhood == "CAPITOL HILL") %>%
count(subcategory, PRCP, neighborhood)

#View(third_plot_data)


plot_3 <- ggplot(data = third_plot_data) + 
  geom_hex(mapping = aes(x = n, y = PRCP))+
  labs(
    title = "Precipitation level and crime",
    x = "number of occurences",
    y =  "precipitation level"
  )
plot_3



plot_4_data <- crime_rain_data %>%
  filter(rain == TRUE) %>%
  select(subcategory, PRCP, neighborhood, TMAX) %>%
  filter(neighborhood == "CAPITOL HILL") %>%
  count(subcategory, neighborhood, TMAX)


#View(plot_4_data)

plot_4 <- ggplot(data = plot_4_data) + 
  geom_hex(mapping = aes(x = n, y = TMAX))+
  labs(
    title = "Cold Weather and Crime",
    x = "number of occurences",
    y =  "Daily High Temperature"
  )

plot_4

#Table for Seasonal Plot
crime_rain_data$MonthN <- as.numeric(format(as.Date(crime_rain_data$date),"%m")) # Month's number

crime_numbers <- crime_rain_data %>% 
  filter((rain == FALSE)&neighborhood == "UNIVERSITY") %>% 
  count(MonthN, subcategory)

mean_crimes <- crime_numbers %>% 
  group_by(subcategory) %>% 
  summarize(m = mean(n)) %>% 
  top_n(9, m)

crime_numbers <- crime_numbers %>% 
  inner_join(mean_crimes, by = "subcategory")

View(crime_numbers)



plot_5 <- ggplot(data = crime_numbers, mapping = aes(x = MonthN, y = n, color = subcategory, size = "3")) +
  geom_line() + 
  geom_point() + 
  guides(size = FALSE) +
  scale_x_continuous(breaks = seq(1,12,1),
                     labels = c("Jan", "Feb", "Mar", "Apr", "May", "June", "July", "Aug", "Sep", "Oct", "Nov", "Dec")) +
  labs(title = paste0("Seasonal Crimes in ", "XXX"), x = "Month", y="Number of Crimes") +
  scale_color_brewer(palette = "Set1")
  
plot_5
  