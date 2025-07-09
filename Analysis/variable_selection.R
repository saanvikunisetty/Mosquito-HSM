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

vif_results <- vifstep(bio_vars, th = 10)
#how much estimated regression coefficient increased due to multicollinearity?
print(vif_results)
selected_vars <- vif_results@results$Variables
print("Selected variables: ")
print(selected_vars)
vif_table <- as.data.frame(vif_results@results)
write.csv(vif_table, "vif.csv", row.names = FALSE)

#Pairwise correlation testing
colnames(bio_vars) <- gsub("\\.\\.\\..*", "", colnames(bio_vars))
selected_vars <- bio_vars[, c("BIO2", "BIO5", "BIO7", "BIO10", "BIO12", "BIO18", "BIO19")]
cor_matrix_selected <- cor(selected_vars, use = "complete.obs")
abs_cor_matrix <- abs(cor_matrix_selected)
diag(abs_cor_matrix) <- NA

max_cor <- which(abs_cor_matrix == max(abs_cor_matrix, na.rm = TRUE), arr.ind = TRUE)
var1 <- rownames(abs_cor_matrix)[max_cor[1]]
var2 <- colnames(abs_cor_matrix)[max_cor[2]]
cat("Most collinear pair is:", var1, "and", var2, "\n")

mean_cor_var1 <- mean(abs_cor_matrix[var1, ], na.rm = TRUE)
mean_cor_var2 <- mean(abs_cor_matrix[var2, ], na.rm = TRUE)
var_to_remove <- ifelse(mean_cor_var1 > mean_cor_var2, var1, var2)
cat("Removing variable:", var_to_remove, "\n")

final_vars <- selected_vars[, !(names(selected_vars) %in% var_to_remove)]
saveRDS(final_vars, file = "c:/Users/4saan/Desktop/Mosquito-HSM/Analysis/final_vars.rds")