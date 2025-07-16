library(tigris)
library(terra)
library(sf)

illinois_sf <- states(cb = TRUE, year = 2024) |>
  subset(STUSPS == "IL")

illinois_vect <- vect(illinois_sf)

set.seed(42)
background_pts <- spatSample(illinois_vect, size = 250, method = "random")

saveRDS(background_pts, "c:/Users/4saan/Desktop/Mosquito-HSM/Analysis/background_pts.rds")
