library(terra)
library(dplyr)
library(corrplot)
library(tigris)

source("c:/Users/4saan/Desktop/Mosquito-HSM/WorldClim/worldclim.R")
source("c:/Users/4saan/Desktop/Mosquito-HSM/Mosquito_data/GBIF.R")

bioclim_values <- extract(cropped_stack, mosq_illinois_shp)
mosq_env <- cbind(as.data.frame(mosq_illinois_shp), bioclim_values[, -1])

bio_only <- mosq_env %>% select(starts_with("BIO"))
cor_matrix <- cor(bio_only, use = "complete.obs")
write.csv(cor_matrix, "correlation_matrix.csv", row.names = TRUE)

png("correlogram.png", width = 1200, height = 1200, res = 150)
corrplot(cor_matrix, method = "color", type = "upper", tl.col = "black",
         title = "Pearson Correlation Between Bioclimatic Variables",
         mar = c(0, 0, 2, 0))
dev.off()