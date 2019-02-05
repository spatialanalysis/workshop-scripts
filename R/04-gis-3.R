# Load libraries for use
library(sf)
library(ggplot2)
library(dplyr)

# Read in libraries and areas data
libraries <- st_read("https://data.cityofchicago.org/resource/psqp-6rmg.geojson")
areas <- st_read("https://data.cityofchicago.org/resource/igwz-8jzy.geojson")

# Project both
libraries <- st_transform(libraries, 32616)
areas <- st_transform(areas, 32616)

# Make a ggplot with libraries and community areas
ggplot() +
  geom_sf(data = areas) +
  geom_sf(data = libraries)

# Find which areas intersect with libraries and save as a variable called "intersects"
intersects <- st_intersects(areas, libraries)
intersects
?st_intersects

# Filter areas by *without* libraries. Save as a variable called "no_lib" Hint: use "==" instead of ">" in the logical comparison
no_lib <- filter(areas, lengths(intersects) == 0)

# Make a ggplot with libraries, community areas, and community areas without libraries
ggplot() +
  geom_sf(data = areas) +
  geom_sf(data = no_lib, fill = "pink") +
  geom_sf(data = libraries)

ggsave("doc/areas_without_libraries_big.png", width = 4, height = 4)

st_join(libraries, areas)
st_join(libraries, areas["community"])

areas <- select(areas, community, area_numbe, geometry)

lib_join <- st_join(libraries, areas)

# This is just to help me figure out which columns to select
names(areas)
str(areas)
glimpse(areas)

lib_counts <- count(lib_join, community)

arrange(lib_counts, desc(n))
