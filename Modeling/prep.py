import pandas as pd
import pyreadr
import numpy as np
import geopandas as gpd
import rasterio
from rasterio.plot import show
from rasterstats import point_query
import matplotlib.pyplot as plt
import os

environment_dir = "c:/Users/4saan/Desktop/Mosquito-HSM/Cropped_Bioclim"

background_csv = "c:/Users/4saan/Desktop/Mosquito-HSM/Mosquito_data/background_pts.csv"
background_df = pd.read_csv(background_csv)

presence_csv = "c:/Users/4saan/Desktop/Mosquito-HSM/Mosquito_data/presence_pts.csv"
presence_df = pd.read_csv(presence_csv)

presence_df["presence"] = 1
background_df["presence"] = 0

combined_df = pd.concat([presence_df, background_df], ignore_index=True)

combined_gdf = gpd.GeoDataFrame(
    combined_df,
    geometry=gpd.points_from_xy(combined_df["decimalLongitude"], combined_df["decimalLatitude"]),
    crs="EPSG:4326"
)

raster_files = [f for f in os.listdir(environment_dir) if f.endswith(".tif")]
raster_layers = {}
for raster_file in raster_files:
    raster_path = os.path.join(environment_dir, raster_file)
    raster = rasterio.open(raster_path)
    raster_layers[raster_file.replace(".tif", "")] = raster