library(RSocrata)
library(sf)
library(lubridate)
library(tidyverse)

vehicle_data <- read.socrata("https://data.cityofchicago.org/resource/suj7-cg3j.csv")

vehicle_final <- vehicle_data %>% 
  filter(year(creation_date) == 2016,
         month(creation_date) == 9) %>% 
  select(comm = community_area,
         lon = longitude,
         lat = latitude) %>% 
  filter(!is.na(lon), !is.na(lat))

vehicle_pts <- st_as_sf(vehicle_final, 
         coords = c("lon", "lat"),
         crs = 4326,
         agr = "constant")

plot(vehicle_pts)

st_crs(vehicle_pts)
vehicle_pts <- st_transform(vehicle_pts, 32616)

st_crs(vehicle_pts)
vehicle_pts

vehicle_pts_buffer <- st_buffer(vehicle_pts, 1000)
plot(vehicle_pts_buffer)

comm_areas <- read_sf("https://data.cityofchicago.org/resource/igwz-8jzy.geojson")

st_crs(comm_areas)

comm_areas <- st_transform(comm_areas, 32616)
comm_pts <- st_join(vehicle_pts, comm_areas)

count(comm_pts, community) %>% 
  filter(community == "HYDE PARK") %>% 
  plot()

count(comm_pts, community) %>% 
  arrange(desc(n))
  
merge(x, y, by = "id") # attribute join
st_join(x, y) # spatial join


