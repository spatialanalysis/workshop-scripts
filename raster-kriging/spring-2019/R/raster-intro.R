# Working through the intro raster course found here:
# https://datacarpentry.org/r-raster-vector-geospatial/01-raster-structure/index.html

library(raster)
library(rgdal)
library(ggplot2)

# Replace with path to file on your computer
data_path <- "raster-kriging/spring-2019/data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_dsmCrop.tif"

data_path2 <- "raster-kriging/spring-2019/data/NEON-DS-Airborne-Remote-Sensing/HARV/DSM/HARV_DSMhill.tif"

GDALinfo(data_path)
harv_dsm_metadata <- capture.output(GDALinfo(data_path))

harv_dsm_metadata

# Import raster data
harv_dsm <- raster(data_path)

harv_dsm

summary(harv_dsm, maxsamp = ncell(harv_dsm))

ncell(harv_dsm)
class(harv_dsm)

harv_df <- as.data.frame(harv_dsm, xy = TRUE)
class(harv_df)
head(harv_df)
str(harv_df)

ggplot() +
  geom_raster(data = harv_df, aes(x = x, y = y, fill = HARV_dsmCrop)) +
  scale_fill_viridis_c() +
  coord_quickmap()

?coord_map

crs(harv_dsm)

minValue(harv_dsm)
maxValue(harv_dsm)

nlayers(harv_dsm)

GDALinfo(data_path)

ggplot() +
  geom_histogram(data = harv_df,
                 aes(HARV_dsmCrop), bins = 40)

GDALinfo(data_path2)
