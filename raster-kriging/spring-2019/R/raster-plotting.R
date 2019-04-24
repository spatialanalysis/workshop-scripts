# challenge: import harvard dsm data into a format that we can use with ggplot2
library(raster)
library(ggplot2)
library(dplyr)

file_path <- "raster-kriging/spring-2019/data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif"
hillshade_path <- "raster-kriging/spring-2019/data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_DSMhill.tif"

harv_dsm <- raster(file_path)
harv_hill <- raster(hillshade_path)
harv_df <- as.data.frame(harv_dsm, xy = TRUE)
harv_hill_df <- as.data.frame(harv_hill, xy = TRUE)

harv_df <- harv_df %>% 
  mutate(fct_elevation = cut(HARV_dsmCrop, breaks = 3))

ggplot() +
  geom_bar(data = harv_df, aes(fct_elevation))

unique(harv_df$fct_elevation)
harv_df %>% 
  group_by(fct_elevation) %>% 
  count()

custom_bins <- c(300, 350, 400, 450)

harv_df <- harv_df %>% 
  mutate(fct_elevation2 = cut(HARV_dsmCrop, breaks = custom_bins))

ggplot() +
  geom_bar(data = harv_df, aes(fct_elevation2))

unique(harv_df$fct_elevation2)
harv_df %>% 
  group_by(fct_elevation2) %>% 
  count()

names(harv_df)

## challenge: try using ggplot to make map with binned elevation data
ggplot() +
  geom_raster(data = harv_df, aes(x = x,
                           y = y,
                           fill = fct_elevation2)) +
  scale_fill_manual(values = terrain.colors(3), name = "Elevation") +
  coord_quickmap() +
  theme(axis.title = element_blank())

terrain.colors(3)

# title of map: Classified Elevation Map - NEON Harvard Forest Field Site
# x axis: UTM Westing Coordinate (m)
# y axis: UTM Northing Coordinate (m)

harv_df <- mutate(harv_df, fct_elevation_6 = cut(HARV_dsmCrop, breaks = 6))

ggplot() +
  geom_raster(data = harv_df, aes(x = x,
                                  y = y,
                                  fill = fct_elevation_6)) +
  scale_fill_manual(values = terrain.colors(6), name = "Elevation") +
  coord_quickmap() +
  xlab("UTM Westing Coordinate (m)") +
  ylab("UTM Northing Coordinate (m)") +
  ggtitle("Classified Elevation Map")

harv_hill_df

ggplot() +
  geom_raster(data = harv_df, aes(x = x, y = y, fill = HARV_dsmCrop)) +
  geom_raster(data = harv_hill_df, aes(x = x,
                                       y = y,
                                       alpha = HARV_DSMhill)) +
  coord_quickmap() +
  scale_fill_viridis_c() +
  scale_alpha(range = c(0.15, 0.65), guide = "none") +
  ggtitle("Elevation with hillshade")
