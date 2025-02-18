library(dplyr)
library(lubridate)
library(ggplot2)
library(ggdark)
library(sf)

# Load in data
crime <- read.csv('data/crime-by-neighborhood.csv')
school <- read.csv('data/school_data.csv')

# Going to focus on crime and schools
# First off, crime
# Convert crime code to factor
crime <- crime %>% 
  mutate(ucr_general = as.factor(ucr_general))

# How many incident of each type of crime?
inc_by_type <- crime %>% 
  group_by(ucr_general) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n))
# Top 10 most common crime types
head(inc_by_type, 10)

# How many incidents by month?
inc_by_month <- crime %>% 
  group_by(month = month(dispatch_date_time)) %>% 
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
  group_by(dispatch_time) %>% 
  summarise(n = n()) %>% 
  arrange(dispatch_time) %>% 
  filter(!is.na(dispatch_time))
# Top 10 hours with most crime
inc_by_hour %>% 
  arrange(desc(n)) %>% 
  head(10)
# Plot
ggplot(inc_by_hour, aes(x = dispatch_time, y = n)) +
  geom_line() +
  labs(title = 'Crime Incidents by Hour of Day', y = 'Count', x = 'Hour') +
  dark_theme_bw()

# What police districts have the most crime?
inc_by_district <- crime %>% 
  group_by(objectid) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n))
# Top 10 districts with most crime
head(inc_by_district, 10)

# What neighborhoods have the most crime?
inc_by_neighborhood <- crime %>% 
  group_by(NAME) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n))
# Top 10 neighborhoods with most crime
head(inc_by_neighborhood, 10)

# Now let's look at schools
# Filter schools where 'score' is numeric
school <- school %>% 
  filter(!is.na(as.numeric(score)))

# Average 4-year graduation rate across the city
avg_grad_rate <- mean(as.numeric(school$num) / school$denom, na.rm = TRUE)
avg_grad_rate

# What schools have the highest graduation rate?
graduation_rates <- school %>% 
  summarise(schoolname = schoolname, score = score) %>%
  arrange(desc(as.numeric(score)))
head(graduation_rates, 10)

# What schools have the lowest graduation rate?
tail(graduation_rates, 10)

# Schools with the highest enrollment
enrollment <- school %>% 
  group_by(schoolname) %>% 
  summarise(enrollment = denom, score = score) %>% 
  arrange(desc(enrollment))
head(enrollment, 10)

# Schools with the lowest enrollment
tail(enrollment, 10)
