library(terra)
library(dplyr)
library(spatialrisk)
library(sf)

mosq_points_vect <- readRDS("c:/Users/4saan/Desktop/Mosquito-HSM/mosq_points_vect.rds")
final_vars <- readRDS("c:/Users/4saan/Desktop/Mosquito-HSM/Analysis/final_vars.rds")

mosq_sf <- st_as_sf(mosq_points_vect, coords = c("decimalLongitude", "decimalLatitude"), crs = 4326)