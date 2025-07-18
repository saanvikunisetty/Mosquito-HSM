
import rasterio
import glob

files = glob.glob(r"C:/Users/4saan/Desktop/Mosquito-HSM/Cropped_Bioclim/Final_Vars/*.tif")

for f in files:
    with rasterio.open(f) as src:
        print(f"{f}: bands = {src.count}, driver = {src.driver}")
