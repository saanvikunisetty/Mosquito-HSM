library(terra)
library(dplyr)
library(geosphere)

cropped_stack <- readRDS("c:/Users/4saan/Desktop/Mosquito-HSM/WorldClim/cropped_stack.rds")
mosq_points_vect <- readRDS("c:/Users/4saan/Desktop/Mosquito-HSM/mosq_points_vect.rds")
final_vars <- readRDS("c:/Users/4saan/Desktop/Mosquito-HSM/Analysis/final_vars.rds")
mosq_illinois_shp <- readRDS("c:/Users/4saan/Desktop/Mosquito-HSM/mosq_illinois_shp.rds")

res_deg <- res(cropped_stack)[1]
res_km <- res_deg * 111
cat("Raster resolution detected:", res_km, "km\n")

mosq_df <- read.csv("c:/Users/4saan/Desktop/Mosquito-HSM/mosq_env_with_bioclim.csv")
min_dist_m <- 9250

custom_thin <- function(df, lon_col = "decimalLongitude", lat_col = "decimalLatitude", min_dist_m = 9250) {
  coords <- df[, c(lon_col, lat_col)]
  selected <- logical(nrow(df))
  remaining <- seq_len(nrow(df))

  while (length(remaining) > 0) {
    i <- remaining[1]
    selected[i] <- TRUE

    dists <- distHaversine(coords[i, ], coords[remaining, ])
    remaining <- remaining[dists > min_dist_m]
  }

  return(df[selected, ])
}