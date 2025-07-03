library(terra)
library(dplyr)
library(corrplot)

#source("c:/Users/4saan/Desktop/Mosquito-HSM/worldclim.R")
#source("c:/Users/4saan/Desktop/Mosquito-HSM/Mosquito_data/GBIF.R")

bioclim_values <- extract(cropped_stack, mosq_points_vect)
mosq_env <- cbind(mosq_illinois, bioclim_values[, -1])

print(head(mosq_env[, c("decimalLatitude", "decimalLongitude", 
                  "BIO1 - Annual Mean Temperature", "BIO12 - Annual Precipitation")]))
