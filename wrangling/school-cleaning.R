library(dplyr)

# Load in files we need
grad_rates <- read.csv('data/SDP_Graduation_rates_school_S_2024-04-01.csv')
school_list <- read.csv('data/2022-2023 Master SChool List (20230110).csv')

# First, let's clean up the graduation rates
# We only want the graduating class of 2023, 4 year grad rates, for all students
grad_rates <- grad_rates %>% 
  filter(cohort == '2019-2020',
         rate_type == '4-Year Graduation Rate',
         group == 'All Students')

# Next let's bring in the latitude and longitude from the school list
school_data <- grad_rates %>% 
  left_join(school_list %>% select('ULCS.Code', 'GPS.Location'),
            by = c('schoolid_ulcs' = 'ULCS.Code'))

# Save as csv
#write.csv(school_data, 'data/school_data.csv', row.names = FALSE)