library(sf)

wards <- read_sf("data/ward1998.shp")
wards
plot(wards)

wards_utm <- st_transform(wards, 32616)
wards_stateplane <- st_transform(wards, 3435)

wards_utm
wards_stateplane

plot(st_geometry(wards_utm))
plot(st_geometry(wards_stateplane))
