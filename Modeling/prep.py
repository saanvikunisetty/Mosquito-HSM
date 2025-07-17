import pandas as pd
import pyreadr
import numpy as np
import geopandas as gpd
import rasterio
from rasterio.plot import show
from rasterstats import point_query
import matplotlib.pyplot as plt
import os

obj <- readRDS("background_pts.rds")
class(obj)
str(obj)

