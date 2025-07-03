occ_data <- 
read.delim("c:/Users/4saan/Desktop/Mosquito-HSM/Mosquito_data/occurrence.txt")
write.csv(occ_data, "occurrence.csv", row.names = FALSE)