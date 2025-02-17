library(sf)
library(dplyr)

# Load in data
neighborhood <- st_read('data/philadelphia-neighborhoods.geojson')
crime <- read.csv('data/crime-incidents-2023.csv')

# Filter out missing coordinates in crime
crime <- crime %>% filter(!is.na(lat) & !is.na(lng))

# Convert crime to sf
crime_sf <- st_as_sf(crime, coords = c('lng', 'lat'), crs = 4326)

# Make sure both have same CRS
neighborhood <- st_make_valid(neighborhood)

# Simplify geometries
neighborhood <- st_simplify(neighborhood, dTolerance = 0.001)

# Spatial join to get neighborhood for each crime
crime_w_neighborhoods <- st_join(crime_sf, neighborhood, join = st_intersects)

# Save to a new csv
#write.csv(crime_w_neighborhoods, 'data/crime-by-neighborhood.csv')