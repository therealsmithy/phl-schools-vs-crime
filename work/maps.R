library(mapview)
library(sf)
library(dplyr)
library(ggplot2)
library(ggmap)

# Read in data
school_data <- read.csv('data/school_data.csv')
neighborhoods <- st_read('data/philadelphia-neighborhoods.geojson') %>% st_transform(4326)
crime_2023 <- read.csv('data/crime-incidents-2023.csv')

# Set up base map
API_key <- "e1f47dec-6863-4a61-b2cd-e1a5185301b4"
register_stadiamaps(API_key)
phl_map <- get_stadiamap(c(bottom = 39.85, top = 40.14, left = -75.3, right = -74.9), zoom = 12,
                         maptype = 'stamen_toner_lite')
ggmap(phl_map)

# Neighborhood map
mapview(neighborhoods, zcol = 'NAME')

# Map out school locations
ggmap(phl_map) +
  geom_point(data = school_data, aes(x = long, y = lat),
             color = 'navy')

# Crime map (all crime)
ggmap(phl_map) +
  geom_point(data = crime_2023, aes(x = lng, y = lat),
             color = 'red', alpha = 0.1)
