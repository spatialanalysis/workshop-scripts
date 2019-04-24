# load libraries
library(sf)
library(ggplot2)
library(dplyr)

# import with sf
ward86 <- read_sf("gis-visualization/spring-2019/data/ward1986.shp")
water <- read_sf("gis-visualization/spring-2019/data/Waterways.geojson")

# project
st_crs(ward86)
st_buffer(ward86) # does not work with unprojected data!!
st_crs(water)

ward86 <- st_transform(ward86, 32616)
st_crs(ward86)

water <- st_transform(water, 32616)
st_crs(water)

ggplot() +
  geom_sf(data = ward86) +
  geom_sf(data = water, col = "blue")

water <- filter(water, name != "LAKE MICHIGAN")

# calculate centroids
# plot with ggplot2
ggplot() +
  geom_sf(data = ward86)

centroids <- st_centroid(ward86)
centroids_buffer <- st_buffer(centroids, 1000)
st_crs(centroids)

ggplot() +
  geom_sf(data = ward86) +
  geom_sf(data = centroids_buffer) +
  geom_sf(data = centroids) 

# spatial intersection (important!!)
intersects <- st_intersects(ward86, water)
water_wards <- filter(ward86, lengths(intersects) > 0)

ggplot() +
  geom_sf(data = ward86) +
  geom_sf(data = water_wards, fill = "pink") +
  geom_sf(data = water, col = "blue")

