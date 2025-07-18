import pandas as pd
import numpy as np
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report, roc_auc_score
import matplotlib.pyplot as plt
import seaborn as sns

df = pd.read_csv("c:/Users/4saan/Desktop/Mosquito-HSM/Modeling/input.csv")
X = df.drop(columns=["decimalLongitude", "decimalLatitude", "presence"])
y = df["presence"]