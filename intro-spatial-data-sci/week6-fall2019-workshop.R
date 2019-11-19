library(geodaData)
library(sf)
library(spdep)
library(tmap)

head(clev_pts)
dim(clev_pts)
names(clev_pts)

str(clev_pts)
st_crs(clev_pts)

plot(clev_pts)
plot(clev_pts["geometry"])

tmap_mode("view")

tm_shape(clev_pts) +
  tm_dots()

?dnearneigh

dist_1000_nb <- dnearneigh(clev_pts, 0, 1000)

coords <- st_coordinates(clev_pts)
plot(dist_1000_nb, coords)

?knearneigh
knn_matrix <- knearneigh(clev_pts)

k1_nb <- knn2nb(knn_matrix)
plot(k1_nb, coords)

# look at distances between neighbors in knn
k1_dists <- unlist(nbdists(k1_nb, coords))
summary(k1_dists)

# set fixed distance so that each point has at least 1 neighbor
critical_thres <- max(k1_dists)
dist_critical_nb <- dnearneigh(clev_pts, 0, critical_thres)
plot(dist_critical_nb, coords)

# how many neighbors does each point have?
number_neighbors <- card(dist_critical_nb) 

# plot histogram with # of neighbors?
summary(number_neighbors)

k6_nb <- knn2nb(knearneigh(clev_pts, k = 6))
plot(k6_nb, st_coordinates(clev_pts), cex = 0.5)

# can we do this with tmap? investigate


st_intersection(tracts, chicago_boundary)

clev_pts_joined <- st_join(clev_pts, polygon)
st_write(clev_pts_joined, "clev_pts_joined.shp")
