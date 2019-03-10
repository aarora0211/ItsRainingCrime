library("dplyr")

crime_data <- read.csv("crime_data.csv", stringsAsFactors = FALSE)
rain_data <- read.csv("seattle_rain.csv", stringsAsFactors = FALSE)


rain_data <- rain_data %>% 
  mutate(date = as.Date(DATE, "%Y-%m-%d"), rain = RAIN)

crime_data_with_weather <- crime_data %>% 
  mutate(date = as.Date(Reported.Date, "%Y-%m-%d")) %>% 
  inner_join(rain_data, by = "date") %>% 
  mutate(subcategory = Crime.Subcategory,
         description = Primary.Offense.Description,
         neighborhood = Neighborhood) %>% 
  select(date, subcategory, neighborhood, rain, PRCP, TMAX, TMIN)

# returns most recent crimes with n being the number of crimes
get_recent_crimes <- function(num) {
  recent = tail(crime_data_with_weather, n = num)
  return(recent)
}

crime_data_with_weather <- read.csv("trimmed_data.csv", stringsAsFactors = FALSE)
View(crime_data_with_weather)
# 
# 1. What crime is the least likely to occur when it is raining?
rain_crime <- crime_data_with_weather %>% filter(rain == "TRUE") %>% select(subcategory)
least_crime <- rain_crime %>% count(subcategory)
least_crime_dis <- least_crime %>% filter(n == min(n))
   
#   ###### This question can help determine the effect that rain has on a certain crime 
#   2. What crime rate is effected the most by rain? 
rain_crime <- crime_data_with_weather %>% filter(rain == "TRUE") %>% select(subcategory)
least_crime <- rain_crime %>% count(subcategory)
no_rain_crime <- crime_data_with_weather %>% filter(rain == "FALSE") %>% select(subcategory)
no_least_crime <- no_rain_crime %>% count(subcategory)
combined_data <- full_join(least_crime, no_least_crime,"subcategory")
most_effected <- combined_data %>% mutate(most = 100*(n.x - n.y)/n.y)
most_effected <- most_effected %>% filter(most == max(most))
names(most_effected)[2] <- "Raining"
names(most_effected)[3] <- "Not Raining"
names(most_effected)[4] <- "Percent Increase"
View(most_effected)

#   ###### This can help law enforcement determine what they should devote resources towards when it is raining.
#   3. What neighboorhood has the largest percentage increase in crime when it does not rain.

neighborhood_crime <- crime_data_with_weather %>% select(neighborhood,rain) 
neighborhood_crime_rain <- neighborhood_crime %>% filter(rain == TRUE) %>% select(neighborhood)
neighborhood_crime_no_rain <- neighborhood_crime %>% filter(rain == FALSE) %>% select(neighborhood)
neighborhood_rain_count <- neighborhood_crime_rain %>% count(neighborhood)
names(neighborhood_rain_count)[2] <- "Raining"
neighborhood_no_rain_count <- neighborhood_crime_no_rain %>% count(neighborhood)
names(neighborhood_no_rain_count)[2] <- "Not_Raining"
joined_data <- neighborhood_rain_count %>% 
inner_join(neighborhood_no_rain_count, by = "neighborhood") %>% 
mutate(percentage = 100*(Not_Raining-Raining)/Raining) %>% 
filter(percentage == max(percentage))
View(joined_data)

# ###### This will help understand what characteristics of a neighborhood leads to more crime
# 4. What crime is commited the most when the temperature is below 32 degrees? Above 75? Is it the same crime, did the temperature effect the most common crime?
most_crime <- crime_data_with_weather %>% 
            select(subcategory, TMIN, TMAX)
min_temp_data <- most_crime %>% filter(TMIN < 32) %>% select(subcategory) %>% count(subcategory) %>% filter(n == max(n))
max_temp_data <- most_crime %>% filter(TMAX > 75) %>% select(subcategory) %>% count(subcategory) %>% filter(n == max(n))
View(min_temp_data)
View(max_temp_data)

#   ###### This can help law enforcement determine what they should devote resources to when it is warm or cold.
#   5. what season has the most crime? is it consistent from year to year?
#   Done!!!!


#   ###### This can help law enforcement predict trends in crime based on the weather and historical data
#   6. What crime rate has the largest increase when it rains in the University district.
u_crime <- crime_data_with_weather %>% select(neighborhood,rain,subcategory) %>% filter(neighborhood == "UNIVERSITY")
u_crime_rain <- u_crime %>% filter(rain == TRUE) %>% select(subcategory)
u_crime_no_rain <- u_crime %>% filter(rain == FALSE) %>% select(subcategory)
u_rain_count <- u_crime_rain %>% count(subcategory)
names(u_rain_count)[2] <- "Raining"
u_no_rain_count <- u_crime_no_rain %>% count(subcategory)
names(u_no_rain_count)[2] <- "Not_Raining"
u_joined_data <- u_rain_count %>% 
  inner_join(u_no_rain_count, by = "subcategory") %>% 
  mutate(percentage = 100*(Raining-Not_Raining)/Not_Raining) %>% 
  filter(percentage == max(percentage))
View(u_joined_data)

# ###### This can help predict crime trends in the UDistrict based on the weather 
# 7. What is the most common crime for Seattle the most common crime in every neighboorhood?
#Done!!!!
