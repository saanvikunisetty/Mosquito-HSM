library(terra)

tif_folder <- "C:/Users/4saan/Desktop/Mosquito-HSM/WorldClim"
tif_files <- list.files(tif_folder, pattern = "\\.tif$", full.names = TRUE)

illinois_extent <- ext(-91.5, -87.5, 36.9, 42.5)
cropped_rasters <- list()

for (file in tif_files)
{
  raster_layer <- rast(file)
  cropped <- crop(raster_layer, illinois_extent)
  cropped_rasters[[basename(file)]] <- cropped
  #cat("Processed:", basename(file), "\n")
}

dir.create("Cropped_Bioclim", showWarnings = FALSE)  

for (i in seq_along(tif_files)) {
  out_file <- file.path("Cropped_Bioclim", basename(tif_files[i]))
  writeRaster(cropped_rasters[[i]], out_file, overwrite = TRUE)
}

cropped_stack <- rast(cropped_rasters)
plot(cropped_stack)
writeRaster(cropped_stack, 
            "cropped_bioclim/cropped_bioclim_stack.tif", 
            overwrite = TRUE)

descriptions <- c(
  "Annual Mean Temperature",
  "Mean Diurnal Range",
  "Isothermality",
  "Temperature Seasonality",
  "Max Temperature of Warmest Month",
  "Min Temperature of Coldest Month",
  "Temperature Annual Range",
  "Mean Temperature of Wettest Quarter",
  "Mean Temperature of Driest Quarter",
  "Mean Temperature of Warmest Quarter",
  "Mean Temperature of Coldest Quarter",
  "Annual Precipitation",
  "Precipitation of Wettest Month",
  "Precipitation of Driest Month",
  "Precipitation Seasonality",
  "Precipitation of Wettest Quarter",
  "Precipitation of Driest Quarter",
  "Precipitation of Warmest Quarter",
  "Precipitation of Coldest Quarter"
)

for (i in 1:nlyr(cropped_stack)) {
  new_name <- paste0("BIO", i, " - ", descriptions[i])
  names(cropped_stack)[i] <- new_name
  cat("Layer", i, "renamed to:", new_name, "\n")
}
