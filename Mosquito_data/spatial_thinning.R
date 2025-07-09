library(terra)
library(dplyr)
library(geosphere)

cropped_stack <- readRDS("c:/Users/4saan/Desktop/Mosquito-HSM/WorldClim/cropped_stack.rds")
mosq_points_vect <- readRDS("c:/Users/4saan/Desktop/Mosquito-HSM/mosq_points_vect.rds")
final_vars <- readRDS("c:/Users/4saan/Desktop/Mosquito-HSM/Analysis/final_vars.rds")
mosq_illinois_shp <- readRDS("c:/Users/4saan/Desktop/Mosquito-HSM/mosq_illinois_shp.rds")

coords <- crds(mosq_illinois_shp)
mosq_coords_df <- as.data.frame(coords)
colnames(mosq_coords_df) <- c("decimalLongitude", "decimalLatitude")
mosq_attrs <- as.data.frame(mosq_illinois_shp)
mosq_df <- cbind(mosq_coords_df, mosq_attrs)

res_deg <- res(cropped_stack)[1]
res_km <- res_deg * 111
cat("Raster resolution detected:", res_km, "km\n")

min_dist_m <- 9250

custom_thin <- function(df, lon_col = "decimalLongitude", lat_col = "decimalLatitude", min_dist_m = 9250) 
{
  coords <- df[, c(lon_col, lat_col)]
  selected <- logical(nrow(df))
  remaining <- seq_len(nrow(df))
  
  while (length(remaining) > 0) {
    i <- remaining[1]
    selected[i] <- TRUE
    
    dists <- distHaversine(coords[i, , drop=FALSE], coords[remaining, , drop=FALSE])
    remaining <- remaining[dists > min_dist_m]
  }
  
  return(df[selected, ])
}

thinned_data <- custom_thin(mosq_df, lon_col = "decimalLongitude", lat_col = "decimalLatitude", min_dist_m = 9250)

cat("Thinned from", nrow(mosq_df), "to", nrow(thinned_data), "points.\n")
saveRDS(thinned_data, "c:/Users/4saan/Desktop/Mosquito-HSM/Mosquito_data/thinned_data.rds")