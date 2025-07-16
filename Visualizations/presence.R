library(ggplot2)
library(tigris)
library(readr)
library(dplyr)
library(sf)
library(terra)

thinned_data <- readRDS("c:/Users/4saan/Desktop/Mosquito-HSM/Mosquito_data/thinned_data.rds")
presence_df <- thinned_data
background_pts_raw <- readRDS("c:/Users/4saan/Desktop/Mosquito-HSM/Mosquito_data/background_pts.rds")

options(tigris_use_cache = TRUE)
illinois_counties <- counties(state = "IL", cb = TRUE, class = "sf")
bg_sf <- st_as_sf(background_pts_raw)

p <- ggplot() +
  geom_sf(data = illinois_counties, fill = NA, color = "black") +
  geom_point(data = presence_df, aes(x = decimalLongitude, y = decimalLatitude),
             color = "red", size = 1.5, alpha = 0.7) +
  geom_sf(data = bg_sf, aes(geometry = geometry), color = "blue", size = 1, alpha = 0.5) +
  labs(title = "Mosquito Presence and Pseudoabsence Points in Illinois") +
  theme_minimal()

ggsave("c:/Users/4saan/Desktop/Mosquito-HSM/Visualizations/presence+absence.png", 
       plot = p, width = 8, height = 8, dpi = 300, bg = "white")