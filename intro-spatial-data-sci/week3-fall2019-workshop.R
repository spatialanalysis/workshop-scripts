install.packages("spData")
library(spData)
library(sf)
us_states

plot(us_states)

install.packages("remotes")
remotes::install_github("spatialanalysis/geodaData")

library(geodaData)
data("chicago_comm")
data("vehicle_pts")

head(vehicle_pts)
head(chicago_comm)
str(chicago_comm)
summary()
plot(chicago_comm["POP2010"])
st_crs(chicago_comm)
chicago_comm <- st_transform(chicago_comm, 32616)
st_crs(chicago_comm)

st_crs(vehicle_pts)
vehicle_pts <- st_transform(vehicle_pts, 32616)

# Order matters!
# st_join(chicago_comm, vehicle_pts)
comm_pts <- st_join(vehicle_pts, chicago_comm) # spatial join
head(comm_pts)

library(dplyr)
counts_by_area <- count(comm_pts, community)

counts_by_area <- st_drop_geometry(counts_by_area) %>% 
  rename(number_vehicles = n)

chicago_comm <- left_join(chicago_comm, counts_by_area) #attribute join

library(tmap)

chicago_comm <- chicago_comm %>% 
  mutate(community = as.character(community))

tm_shape(chicago_comm) +
  tm_polygons("number_vehicles")

str(chicago_comm)

nyc_sf
plot(nyc_sf)
