# to make a new folder from R
dir.create("scripts")

library(raster) # raster data
library(ggplot2) # plotting
library(sf) # vector data

file_path <- "raster-kriging/spring-2019/data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif"

rgb_band1_harv <- raster(file_path)
rgb_band2_harv <- raster(file_path, band = 2)

class(rgb_band1_harv)

rgb_band1_harv_df <- as.data.frame(rgb_band1_harv, xy = TRUE)
rgb_band2_harv_df <- as.data.frame(rgb_band2_harv, xy = TRUE)

ggplot() +
  geom_raster(data = rgb_band1_harv_df, aes(x = x, y = y, alpha = HARV_RGB_Ortho)) +
  coord_quickmap()

rgb_stack_harv <- stack(file_path)
rgb_stack_harv@layers

?plotRGB
plotRGB(rgb_stack_harv, r = 1, g = 2, b = 3)

rgb_brick_harv <- brick(rgb_stack_harv)
plotRGB(rgb_brick_harv)

# something new!! cropping rasters
chm_path <- "raster-kriging/spring-2019/data/NEON-DS-Airborne-Remote-Sensing/HARV/CHM/HARV_chmCrop.tif"

boundary_path <- "raster-kriging/spring-2019/data/NEON-DS-Site-Layout-Files/HARV/HarClip_UTMZ18.shp"

chm_harv <- raster(chm_path)
chm_harv_df <- as.data.frame(chm_harv, xy = TRUE)

boundary_harv <- read_sf(boundary_path)

ggplot() +
  geom_raster(data = chm_harv_df, aes(x = x, y = y, fill = HARV_chmCrop)) +
  scale_fill_gradientn(colors = terrain.colors(10)) +
  geom_sf(data = boundary_harv, fill = NA)

?crop

boundary_sp <- as(boundary_harv, "Spatial")
chm_crop <- crop(chm_harv, boundary_sp)

chm_crop_df <- as.data.frame(chm_crop, xy = TRUE)

ggplot() +
  geom_raster(data = chm_crop_df, aes(x = x, y = y, fill = HARV_chmCrop)) +
  scale_fill_gradientn(colors = terrain.colors(10)) +
  geom_sf(data = boundary_harv, fill = NA)
  