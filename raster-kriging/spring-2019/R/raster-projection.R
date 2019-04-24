library(raster)
library(ggplot2)
library(dplyr)

dsm_path <- "raster-kriging/spring-2019/data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif"
dtm_path <- "raster-kriging/spring-2019/data/NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_dtmCrop.tif"
hillshade_path <- "raster-kriging/spring-2019/data/NEON-DS-Airborne-Remote-Sensing/HARV/DTM/HARV_DTMhill_WGS84.tif"

harv_dtm <- raster(dtm_path)
harv_dsm <- raster(dsm_path)

harv_hill <- raster(hillshade_path)
harv_dtm_df <- as.data.frame(harv_dtm, xy = TRUE)
harv_dsm_df <- as.data.frame(harv_dsm, xy = TRUE)
harv_hill_df <- as.data.frame(harv_hill, xy = TRUE)

head(harv_df)
head(harv_hill_df)

ggplot() +
  geom_raster(data = harv_df, aes(x = x, y = y, fill = HARV_dtmCrop)) +
  geom_raster(data = harv_hill_df, aes(x = x,
                                       y = y,
                                       alpha = HARV_DTMhill_WGS84)) +
  coord_quickmap() +
  scale_fill_viridis_c() +
  scale_alpha(range = c(0.15, 0.65), guide = "none") +
  ggtitle("Elevation with hillshade")

ggplot() +
  geom_raster(data = harv_df,
              aes(x = x, y = y, fill = HARV_dtmCrop)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) +
  coord_quickmap()

ggplot() +
  geom_raster(data = harv_hill_df, 
              aes(x = x, y = y, alpha = HARV_DTMhill_WGS84)) +
  coord_quickmap()

crs(harv)
crs(harv_hill)

# Project our raster! And make it the same res as the original elevation data
harv_hill_proj <- projectRaster(harv_hill, crs = crs(harv), res = 1)

crs(harv_hill_proj)

extent(harv)
extent(harv_hill)
extent(harv_hill_proj)

res(harv_hill)
res(harv_hill_proj)

harv_hill_proj_df <- as.data.frame(harv_hill_proj, xy = TRUE)

# Plot together
ggplot() +
  geom_raster(data = harv_df,
              aes(x = x, y = y, fill = HARV_dtmCrop)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) +
  geom_raster(data = harv_hill_proj_df, 
              aes(x = x, y = y, alpha = HARV_DTMhill_WGS84)) +
  coord_quickmap()

# To do raster calcs, can just subtract one raster from the other!
harv_chm <- harv_dsm - harv_dtm 
harv_chm_df <- as.data.frame(harv_chm, xy = TRUE)

ggplot() +
  geom_raster(data = harv_chm_df,
              aes(x = x, y = y, fill = layer)) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) +
  coord_quickmap()

harv_chm2 <- overlay(harv_dsm, harv_dtm, fun = function(x, y) x - y )

harv_chm2_df <- as.data.frame(harv_chm2, xy = TRUE)

ggplot() +
  geom_raster(data = harv_chm2_df,
              aes(x = x, y = y, fill = layer)) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) +
  coord_quickmap()

writeRaster(harv_chm2, "CHM_HARV.tiff", format = "GTiff", overwrite = TRUE, NAflag = -9999)
