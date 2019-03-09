library("dplyr")

crime_data <- read.csv("crime_data.csv", stringsAsFactors = FALSE)
rain_data <- read.csv("seattle_rain.csv", stringsAsFactors = FALSE)


rain_data <- rain_data %>% 
  mutate(date = as.Date(DATE, "%Y-%m-%d"), rain = RAIN)

crime_data_with_weather <- crime_data %>% 
  mutate(date = as.Date(Reported.Date, "%m/%d/%Y")) %>% 
  inner_join(rain_data, by = "date") %>% 
  mutate(subcategory = Crime.Subcategory,
         description = Primary.Offense.Description,
         neighborhood = Neighborhood) %>% 
  select(date, subcategory, neighborhood, rain, PRCP, TMAX, TMIN)

# bens table didn't load
write.csv(crime_data_with_weather, "trimmed_data.csv", row.names = F)

# returns most recent crimes with n being the number of crimes
get_recent_crimes <- function(num) {
  recent = tail(crime_data_with_weather, n = num)
  return(recent)
}
View(crime_data_with_weather)

