library(geodaData)
library(sf)
library(tmap)
library(sfExtras)
library(spdep)

head(ncovr)
?ncovr
str(ncovr)
summary(ncovr)

plot(ncovr)
plot(ncovr["geometry"])

st_crs(ncovr)

tm_shape(ncovr) +
  tm_polygons("HR60")

tmap_mode("view")

tm_shape(ncovr) +
  tm_polygons("HR60")

ncovr_rook <- st_rook(ncovr)
ncovr_queen <- st_queen(ncovr)

# check average number of neighbors per county
rook_neighbors <- lengths(ncovr_rook)
queen_neighbors <- lengths(ncovr_queen)

mean(rook_neighbors) # 5.6 ish
mean(queen_neighbors) # 5.8 ish
 
# convert lists of neighbors to "nb" object to make map
rook_nb <- st_as_nb(ncovr_rook)
summary(rook_nb)

queen_nb <- st_as_nb(ncovr_queen)
summary(queen_nb)

centroid_coords <- st_centroid_coords(ncovr)

plot(queen_nb, centroid_coords, lwd = 0.2, cex = 0.5, col = "blue")


st_coordinates(clev_pts)
