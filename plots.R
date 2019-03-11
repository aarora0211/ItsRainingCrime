library(dplyr)
library(ggplot2)

my_data <- read.csv("trimmed_data.csv", stringsAsFactors = FALSE)
View(my_data)


make_plot_data <- my_data %>%
  filter(rain == TRUE) %>%
  filter(neighborhood == "UNIVERSITY") %>% 
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
