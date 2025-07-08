occ_data <- 
read.delim("c:/Users/4saan/Desktop/Mosquito-HSM/Mosquito_data/occurrence.txt")
#write.csv(occ_data, "c:/Users/4saan/Desktop/Mosquito-HSM/occurrence.csv", row.names = FALSE)

library(dplyr)

cleaned_occ <- occ_data %>%
  filter(!is.na(decimalLatitude), !is.na(decimalLongitude)) %>%
  filter(coordinateUncertaintyInMeters < 10000 | 
  is.na(coordinateUncertaintyInMeters)) %>%
  distinct(decimalLatitude, decimalLongitude, .keep_all = TRUE)

illinois_bbox <- list(
  xmin = -91.5,
  xmax = -87,
  ymin = 36.9,
  ymax = 42.5
)

options(tigris_use_cache = TRUE)
states_sf <- states(cb = TRUE, year = 2024)
illinois_sf <- subset(states_sf, NAME == "Illinois")
illinois_vect <- vect(illinois_sf)

mosq_points_vect <- vect(cleaned_occ, 
                        geom = c("decimalLongitude", "decimalLatitude"),
                        crs = "EPSG:4326")

mosq_illinois_shp <- mosq_points_vect[illinois_vect, ]
saveRDS(mosq_illinois_shp, "mosq_illinois_shp.rds")