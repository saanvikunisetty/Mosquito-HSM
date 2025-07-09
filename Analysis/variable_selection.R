library(dplyr)
library(usdm)
library(corrplot)
library(car)

cropped_stack <- readRDS("c:/Users/4saan/Desktop/Mosquito-HSM/WorldClim/cropped_stack.rds")
mosq_illinois_shp <- readRDS("c:/Users/4saan/Desktop/Mosquito-HSM/mosq_illinois_shp.rds")

bioclim_values <- extract(cropped_stack, mosq_illinois_shp)
mosq_env <- cbind(as.data.frame(mosq_illinois_shp), bioclim_values[, -1])
write.csv(mosq_env, "c:/Users/4saan/Desktop/Mosquito-HSM/mosq_env_with_bioclim.csv", row.names = FALSE)
mosq_env <- read.csv("c:/Users/4saan/Desktop/Mosquito-HSM/mosq_env_with_bioclim.csv")
bio_vars <- mosq_env %>% select(starts_with("BIO"))

vif_result <- vifstep(bio_vars, th = 10)
#how much estimated regression coefficient increased due to multicollinearity?
print(vif_result)
selected_vars <- vif_result@results$Variables
print("Selected variables: ")
print(selected_vars)