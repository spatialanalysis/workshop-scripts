# install_github("spatialanalysis/geodaData")

library(geodaData)
library(sf)
library(tmap)

head(nyc_sf)
dim(nyc_sf)
str(nyc_sf)
plot(nyc_sf) # all attributes
names(nyc_sf)
plot(nyc_sf["geometry"]) # just outlines

summary(nyc_sf)
?nyc_sf

st_crs(nyc_sf)

tm_shape(nyc_sf) +
  tm_polygons() +
tm_shape(st_centroid(nyc_sf)) +
  tm_dots(size = 0.5)

tm_shape(nyc_sf) +
  tm_polygons("rent2008")

tm_shape(nyc_sf) +
  tm_fill("rent2008") + 
  tm_borders()

tmap_mode("view")

tm_shape(nyc_sf) +
  tm_polygons("rent2008") +
  tm_basemap(server = "OpenStreetMap")

tmap_mode("plot")

leaflet::providers

?tm_polygons

tm_shape(nyc_sf) +
  tm_fill("rent2008", title = "Rent in 2008", legend.hist = TRUE) +
  tm_borders() +
  tm_layout(main.title = "Rent in NYC Boroughs, 2008", compass.type = "4star", legend.outside = TRUE) +
  tm_compass() +
  tm_scale_bar(position = c("left", "top"))

tm_shape(nyc_sf) +
  tm_fill("rent2008", title = "Rent in 2008", legend.hist = TRUE) +
  tm_borders() +
  tm_style_cobalt()
