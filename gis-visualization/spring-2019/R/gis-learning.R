library(sf)
library(ggplot2)

ward92 <- read_sf("gis-visualization/spring-2019/data/ward1992.shp")
ward98 <- read_sf("gis-visualization/spring-2019/data/ward1998.shp")

ward92 <- st_transform(ward92, 32616)
ward98 <- st_transform(ward98, 32616)

# class(ward92)

ggplot(ward92) +
  geom_sf()

ggplot(ward98, aes(fill = WARD)) +
  geom_sf()

names(ward98)

View(ward92)
names(ward92)

st_crs(ward92)
st_crs(ward98)

ward92
centroids <- st_centroid(ward92)

ggplot() +
  geom_sf(data = ward92) +
  geom_sf(data = centroids, color = "red")

?geom_sf

st_cast(ward92, "POLYGON")
