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

mosq_illinois <- cleaned_occ %>%
  filter(decimalLatitude >= illinois_bbox$ymin,
         decimalLatitude <= illinois_bbox$ymax,
         decimalLongitude >= illinois_bbox$xmin,
         decimalLongitude <= illinois_bbox$xmax)

print(summary(mosq_illinois[, c("decimalLatitude", "decimalLongitude")]))
print(nrow(mosq_illinois))