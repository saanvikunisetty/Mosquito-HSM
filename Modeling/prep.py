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

#print(f"Combined GeoDataFrame CRS: {combined_gdf.crs}")
#print(f"Sample geometries:\n{combined_gdf.geometry.head()}")
#print(f"Raster files found: {raster_files}")
#print(f"Raster layers loaded: {list(raster_layers.keys())}")

env_data = {}

for raster_file in raster_files:
    raster_path = os.path.join(environment_dir, raster_file)
    var_name = raster_file.replace(".tif", "")
    values = point_query(combined_gdf, raster_path, interpolate='nearest')
    env_data[var_name] = values

env_df = pd.DataFrame(env_data)

combined_export_df = pd.concat([
    combined_df[["decimalLongitude", "decimalLatitude", "presence"]].reset_index(drop=True),
    env_df
], axis=1)

print(combined_export_df.head())
print(combined_export_df.info())
print(combined_export_df.describe())
print(combined_export_df["presence"].value_counts())

output_csv = "c:/Users/4saan/Desktop/Mosquito-HSM/Modeling/input.csv"
combined_export_df.to_csv(output_csv, index=False)