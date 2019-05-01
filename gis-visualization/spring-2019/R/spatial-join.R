library(sf)
library(ggplot2)
library(dplyr)

libraries <- read_sf("https://data.cityofchicago.org/resource/psqp-6rmg.geojson")
areas <- read_sf("https://data.cityofchicago.org/resource/igwz-8jzy.geojson")

# won't work if not projected
st_intersects(areas, libraries)

# project the data
st_crs(libraries)
libraries <- st_transform(libraries, 32616)
areas <- st_transform(areas, 32616)

# make a map of both!
ggplot() +
  geom_sf(data = areas) +
  geom_sf(data = libraries)

# find which libraries are in which areas
intersects <- st_intersects(areas, libraries)
no_library_areas <- filter(areas, lengths(intersects) == 0)

# map places in chicago without libraries
ggplot() +
  geom_sf(data = areas) + 
  geom_sf(data = no_library_areas, fill = "pink")

# try making a map of areas in chicago with more than 1 library!
many_library_areas <- filter(areas, lengths(intersects) > 1)

ggplot() +
  geom_sf(data = areas) +
  geom_sf(data = no_library_areas, fill = "red") +
  geom_sf(data = many_library_areas, fill = "green")

?ggsave
ggsave("gis-visualization/spring-2019/doc/figs/green-red-libraries.jpg", width = 5)

# SPATIAL JOIN
?st_join

# count how many libraries in each area
libraries_with_areas <- st_join(libraries, areas)
count(libraries_with_areas, community)

# use the pipe to do it in one line
st_join(libraries, areas) %>% count(community)

naniar::vis_miss(libraries_with_areas)
naniar::gg_miss_var(libraries_with_areas)

st_join(areas, libraries)

ggplot() +
  geom_sf(data = areas) +
  geom_sf(data = libraries_with_areas, aes(color = community))

# alt - gives you <- 