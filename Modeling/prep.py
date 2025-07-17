import pandas as pd
import pyreadr
import numpy as np
import geopandas as gpd
import rasterio
from rasterio.plot import show
from rasterstats import point_query
import matplotlib.pyplot as plt
import os

background_csv = "c:/Users/4saan/Desktop/Mosquito-HSM/Mosquito_data/background_pts.csv"
background_df = pd.read_csv(background_csv)

presence_csv = "c:/Users/4saan/Desktop/Mosquito-HSM/Mosquito_data/presence_pts.csv"
presence_df = pd.read_csv(presence_csv)