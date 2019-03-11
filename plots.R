library(dplyr)
library(ggplot2)

my_data <- read.csv("trimmed_data.csv", stringsAsFactors = FALSE)
View(my_data)


make_plot_data <- my_data %>%
  filter(rain == TRUE) %>%
  count(subcategory)%>%
  arrange(desc(n))%>%
  top_n(10, n)



View(make_plot_data)

plot1 <- ggplot(data = make_plot_data) +
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


second_plot_data <- my_data %>%
  filter(rain == TRUE) %>%
  select(subcategory, PRCP, neighborhood)
 
  

View(second_plot_data)

plot_two <- ggplot(data = second_plot_data) +
  geom_point(
    mapping = aes(x = PRCP, y = subcategory)) +
      labs(
        title = "Precipitation level and spacific crime",
        x = "type of crime",
        y =  "precipitation level"
  )

  plot_two


third_plot_data <- my_data %>%
  filter(rain == TRUE) %>%
  select(subcategory, PRCP, neighborhood) %>%
  filter(neighborhood == "CAPITOL HILL") %>%
count(subcategory, PRCP, neighborhood)

View(third_plot_data)


plot_3 <- ggplot(data = third_plot_data) + 
  geom_hex(mapping = aes(x = n, y = PRCP))+
  labs(
    title = "Precipitation level and crime",
    x = "number of occurences",
    y =  "precipitation level"
  )
plot_3


