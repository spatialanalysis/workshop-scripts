library(sp)
library(gstat)
library(ggplot2)
library(sf)

# Load and look at dataset
data("meuse")

head(meuse)
str(meuse)
summary(meuse)
class(meuse)
names(meuse)
?meuse

# Map the data
ggplot(meuse, aes(x = x, y = y, size = lead, color = dist)) +
  geom_point() +
  theme_bw()

# Convert to a spatial object
# older sp method
coordinates(meuse) <- ~x+y
proj4string(meuse)

proj4string(meuse) <- CRS("+init=epsg:28992")
proj4string(meuse)

# alternate method using sf
data(meuse)
meuse_sf <- st_as_sf(meuse, coords = c("x", "y"))
st_crs(meuse_sf) <- 28992
st_crs(meuse_sf)
meuse_sp <- as_Spatial(meuse_sf)

# Make a variogram
vgm <- variogram(log(zinc)~1, meuse_sp)
plot(vgm)

# Fit a model to the variogram
show.vgms()
?vgm

vgm_fit <- fit.variogram(vgm, model = vgm("Sph"))
plot(vgm, vgm_fit)

# Get a gridded surface
data("meuse.grid")
ggplot(meuse.grid, aes(x = x, y = y)) +
  geom_point()

meuse_grid_sf <- st_as_sf(meuse.grid, coords = c("x", "y"))
st_crs(meuse_grid_sf) <- 28992
meuse_grid <- as_Spatial(meuse_grid_sf)

# Krige!
meuse_kriged <- krige(log(zinc)~1, meuse_sp, meuse_grid, model = vgm_fit)

head(meuse_kriged)

# Plot your kriged surface
# old way
spplot(meuse_kriged["var1.pred"])

# new way
meuse_kriged_df <- as.data.frame(meuse_kriged) 
ggplot() +
  geom_raster(data = meuse_kriged_df, 
              aes(x = coords.x1, 
                  y = coords.x2, 
                  fill = var1.pred)) +
  scale_fill_gradient(low = "yellow", high = "red") +
  geom_point(data = meuse,
             aes(x = x,
                 y = y))
