library("dplyr")
library("ggplot2")
library("hexbin")
source("analysis.r")
# install.packages("hexbin")


# This file has the plots using the trimmed data. The plots are then inplemented in
# the team_server.R file.

# loads joined data
crime_rain_data <- read.csv("trimmed_data.csv", stringsAsFactors = FALSE)


# data and plot #1

rainy_crimes <- crime_rain_data %>%
  filter(rain == TRUE) %>%
  filter(neighborhood == "UNIVERSITY") %>% 
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


# data and plot #2

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

# data and plot #3
  
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

# data and plot #4


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

plot_5 <- ggplot(data = crime_numbers, mapping = aes(x = MonthN, y = n, color = subcategory, size = "3")) +
  geom_line() + 
  geom_point() + 
  guides(size = FALSE) +
  scale_x_continuous(breaks = seq(1,12,1),
                     labels = c("Jan", "Feb", "Mar", "Apr", "May", "June", "July", "Aug", "Sep", "Oct", "Nov", "Dec")) +
  labs(title = paste0("Seasonal Crimes in ", "XXX"), x = "Month", y="Number of Crimes") +
  scale_color_brewer(palette = "Set1")
  
plot_5
  
# Descriptions

plot1
# Plot 1 shows the top 10 crimes that are commited while raining. 
# Question: what are the top 10 crimes commited while its raining per neighborhood


plot_two
# Plot 2 shows the amount of crime with and without rain for each specific crime. This 
# can also be filtered by neighboorhood.

# Question: How does the level of rain effect when specific crimes will occur in every 
#neighborhood 

plot_3
# Plot 3 shows the relationship between the level of rain and the number of crimes
# commited. The y axis shows percipitation levels and the x axis shows the number of
# crimes at that percipitation level. The data can be filtered by neighboorhood to 
# see if there is a diffence by neighboorhood

# question: How does the level of rain effect the total number of crimes per 
#neighboorhood
plot_4
# Plot 4 shows the relationship between temperature and the number of crimes. We want
# to see if temperature has an effect on crime with and without rain. The plot shows 
# temperature on the y axis and the number of occurences on the x axis. The current
# neighborhood is 

# temperature on the y axis and the number of occurences on the x axis.

# question: How does the temperature effect the total number of crimes per 
# neighboorhood

