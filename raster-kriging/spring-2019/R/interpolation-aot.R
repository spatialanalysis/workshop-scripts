library(sf)
library(ggplot2)
library(gstat)
library(sp)

download.file("https://github.com/spatialanalysis/workshop-notes/raw/master/data/node_temps.csv", destfile = "raster-kriging/spring-2019/data/node-temps.csv")

# change csv to sf object
nodes <- read.csv("node-temps.csv")
nodes_sf <- st_as_sf(nodes, coords = c("lon", "lat"), crs = 4326)
nodes_sf <- st_transform(nodes_sf, 32616)

areas <- st_read("https://data.cityofchicago.org/resource/igwz-8jzy.geojson")
areas <- st_transform(areas, 32616)

# make a ggplot2 map?
ggplot() +
  geom_sf(data = areas) +
  geom_sf(data = nodes_sf, aes(color = avg_temp))

# change sf to sp to use in gstat
nodes_sp <- as_Spatial(nodes_sf)

# make a variogram
nodes_var <- variogram(nodes_sp$avg_temp ~ 1, nodes_sp)
plot(nodes_var)

nodes_var_fit <- fit.variogram(nodes_var, model = vgm("Sph"))
plot(nodes_var, nodes_var_fit)

areas_grid <- st_make_grid(areas, n = c(20, 20))
areas_grid_sp <- as_Spatial(areas_grid)
plot(areas_grid)

nodes_kriged <- krige(nodes_sp$avg_temp ~ 1, nodes_sp, areas_grid_sp, model = nodes_var_fit)

# need to debug
nodes_kriged_df <- as.data.frame(nodes_kriged)
ggplot() +
  geom_raster(data = nodes_kriged_df,
              aes(x = x, 
                  y = y,
                  fill = var1.pred))

spplot(nodes_kriged["var1.pred"])

# any idea of how to clip to boundary?
nodes_kriged_sf <- st_as_sf(nodes_kriged)
clipped <- st_intersection(areas, nodes_kriged_sf)

ggplot() +
  geom_raster(data = clipped,
              aes(x = x,
                  y = y,
                  fill = var1.pred))
