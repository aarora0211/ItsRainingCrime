library(dplyr)
library(ggplot2)
source("analysis.r")

crime_rain_data <- read.csv("trimmed_data.csv", stringsAsFactors = FALSE)
#View(my_data)


rainy_crimes <- crime_rain_data %>%
  filter(rain == TRUE) %>%
  count(subcategory)%>%
  arrange(desc(n))%>%
  top_n(10, n)


#View(rainy_crimes)

plot1 <- ggplot(data = rainy_crimes) +
  geom_col(
    mapping = aes(x = reorder(subcategory, n), y = n, fill = subcategory)) +
  scale_color_brewer(palette = "Spectral") +
  theme(axis.text.x = element_blank(),
        axis.ticks = element_blank())+
  labs(
    title = "Crime on rainy days",
    x = "Crime",
    y =  "number of occurences while raining"
  )
plot1


crime_data_with_weather <- crime_data_with_weather %>% 
  
# Map
ggplot(data = crime_data_with_weather) +
  geom_line(mapping = aes(x = ))

