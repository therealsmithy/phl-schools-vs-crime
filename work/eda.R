library(dplyr)
library(lubridate)
library(ggplot2)
library(ggdark)

# Load in data
crime <- read.csv('data/crime-incidents-2023.csv')
school <- read.csv('data/school_data.csv')

# Going to focus on crime and schools
# First off, crime
# Convert crime code to factor
crime <- crime %>% 
  mutate(text_general_code = as.factor(text_general_code))

# How many incident of each type of crime?
inc_by_type <- crime %>% 
  group_by(text_general_code) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n))
# Top 10 most common crime types
head(inc_by_type, 10)

# How many incidents by month?
inc_by_month <- crime %>% 
  group_by(month = month(dispatch_date)) %>% 
  summarise(n = n()) %>% 
  arrange(month) %>% 
  mutate(month = factor(month, levels = 1:12, labels = month.name))
# Top 5 months with the most crime
inc_by_month %>% 
  arrange(desc(n)) %>% 
  head(5)
# Plot
ggplot(inc_by_month, aes(x = month, y = n)) +
  geom_col() +
  labs(title = 'Crime Incidents by Month', y = 'Count', x = NULL) +
  dark_theme_bw()

# How many incidents by hour of day?
inc_by_hour <- crime %>% 
  group_by(hour) %>% 
  summarise(n = n()) %>% 
  arrange(hour) %>% 
  filter(!is.na(hour))
# Top 10 hours with most crime
inc_by_hour %>% 
  arrange(desc(n)) %>% 
  head(10)
# Plot
ggplot(inc_by_hour, aes(x = hour, y = n)) +
  geom_line() +
  labs(title = 'Crime Incidents by Hour of Day', y = 'Count', x = 'Hour') +
  dark_theme_bw()

# What police districts have the most crime?
inc_by_district <- crime %>% 
  group_by(dc_dist) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n))
# Top 10 districts with most crime
head(inc_by_district, 10)
