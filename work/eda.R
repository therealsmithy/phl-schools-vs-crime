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

# How many incidents by month?
inc_by_month <- crime %>% 
  group_by(month = month(dispatch_date)) %>% 
  summarise(n = n()) %>% 
  arrange(month)
  
ggplot(inc_by_month, aes(x = month, y = n)) +
  geom_col() +
  labs(title = 'Crime Incidents by Month') +
  dark_theme_bw()
