library(sf)
library(dplyr)

# Load the data
neighborhoods <- st_read('data/raw/philadelphia-neighborhoods.geojson')
schools <- read.csv('data/clean/school_data.csv')

# Filter out missing coordinates in schools
schools <- schools %>% filter(!is.na(lat) & !is.na(long))

# Convert crime to sf
schools_sf <- st_as_sf(schools, coords = c('long', 'lat'), crs = 4326)

# Make sure both have same CRS
neighborhoods <- st_make_valid(neighborhoods)

# Simplify geometries
neighborhoods <- st_simplify(neighborhoods, dTolerance = 0.001)

# Spatial join to get neighborhood for each crime
schools_w_neighborhoods <- st_join(schools_sf, neighborhoods, join = st_intersects)

# Save to a new csv
#readr::write_csv(schools_w_neighborhoods, 'data/clean/schools-by-neighborhood.csv')