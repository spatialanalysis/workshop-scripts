install.packages(c("tidyverse", 
                   "RSocrata", 
                   "sf", 
                   "tmap", 
                   "lubridate"))

library(tidyverse) # Ctrl-Enter to run a line 
library(RSocrata)
library(sf)
library(tmap)
library(lubridate)

vehicle_data <- read.socrata("https://data.cityofchicago.org/resource/suj7-cg3j.csv")

head(vehicle_data)
dim(vehicle_data)
class(vehicle_data)
glimpse(vehicle_data) # other ways to explore
str(vehicle_data)

vehicle_data %>% 
  filter(year(creation_date) == 2005) 

vehicle_data$creation_date
year(vehicle_data$creation_date)

angela %>% 
  brush_hair %>% 
  eat_breakfast %>% 
  go_to_work %>% 
  teach_r_spatial

group_by(select(filter(vehicle_data, year(creation_date) == 2005), x))

names(vehicle_data)
unique(month(vehicle_data$creation_date))
  
vehicle_sept16 <- vehicle_data %>% 
  filter(year(creation_date) == 2016,
         month(creation_date) == 9) 

head(vehicle_sept16)
glimpse(vehicle_sept16)
str(vehicle_sept16)
dim(vehicle_sept16)

vehicle_final <- vehicle_sept16 %>% 
  select(lon = longitude, 
         lat = latitude, 
         comm = community_area)

vehicle_coord <- filter(vehicle_final, !is.na(lon), !is.na(lat))

vehicle_points <- st_as_sf(vehicle_coord, 
                           coords = c("lon", "lat"), 
                           crs = 4326, 
                           agr = "constant")

plot(vehicle_points)
class(vehicle_points)
st_crs(vehicle_points)
