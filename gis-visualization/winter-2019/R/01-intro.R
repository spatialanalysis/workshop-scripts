# Import shapefile into R
library(sf)

ward86 <- st_read("data/ward1986.shp")

ward86_utm <- st_transform(ward86, 32616)
ward86_stateplane <- st_transform(ward86, 3435)
# Bad
# ward86_alaska <- st_transform(ward86, 3338)

st_crs(ward86)
st_crs(ward86_utm)
st_crs(ward86_stateplane)

plot(ward86)
plot(ward86_utm)
plot(ward86_stateplane)
plot(ward86_alaska)

# Challenge: project ward86 to Illinois East state plane projection (use Google to look up the EPSG code)
#Ctrl-Enter to run a line of code