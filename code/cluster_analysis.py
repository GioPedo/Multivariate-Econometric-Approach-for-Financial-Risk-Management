# =============================================================================
# Title: Cluster Analysis of NASDAQ-100 Securities
# Author: Giovanni Pedone
# Thesis Date: 2024-10-17
# GitHub Upload: June 2025
# 
# Description:
#     This script performs clustering on NASDAQ-100 components using 
#     historical financial data and machine learning techniques.
#     Tickers are scraped from Wikipedia, prices are fetched via Yahoo Finance,
#     and clustering methods (KMeans, etc.) are applied to identify 
#     structure and similarity within the market.

# Disclaimer:
#     The results in this script reflect the market conditions and data
#     available at the time of the thesis work (October 2024).
#     Due to the dynamic nature of financial markets, 
#     running this code at a different time may lead to different outputs,
#     especially depending on index composition and pricing data.
# =============================================================================


# =============================================================================
# IMPORT LIBRARIES
# =============================================================================
import numpy as np
import pandas as pd
import yfinance as yf
import plotly.express as px
import matplotlib.pyplot as plt
from scipy.cluster.vq import kmeans, vq
from math import sqrt
from sklearn.cluster import KMeans
from pandas_datareader import data as pdr
from datetime import datetime

# Optional display setting for Plotly
px.default='svg'
yf.pdr_override()


# =============================================================================
# SCRAPE NASDAQ-100 TICKERS FROM WIKIPEDIA
# =============================================================================
nasdaq100_url = 'https://en.wikipedia.org/wiki/Nasdaq-100'

# Read and extract tickers from Wikipedia table
data_table = pd.read_html(nasdaq100_url)
tickers = data_table[4]['Symbol'].values.tolist()

# Clean ticker symbols for compatibility with Yahoo Finance
tickers = [s.replace('\n', '') for s in tickers]
tickers = [s.replace('.', '-') for s in tickers]
tickers = [s.replace(' ', '') for s in tickers]

# =============================================================================
# DOWNLOAD HISTORICAL ADJUSTED CLOSE PRICES VIA YAHOO FINANCE
# =============================================================================
startdate = datetime(2019, 1, 1)
enddate = datetime(2024, 1, 1)

# Download and store each security's price series
prices_list = []
for ticker in tickers:
    try:
        prices = pdr.get_data_yahoo(ticker,
                                    start=startdate,
                                    end=enddate)['Adj Close']
        prices = pd.DataFrame(prices)
        prices.columns = [ticker]
        prices_list.append(prices)
    except:
        # If download fails, skip the ticker
        pass

# Concatenate all price series into one DataFrame
prices_df = pd.concat(prices_list, axis=1)
prices_df.sort_index(inplace=True)

# =============================================================================
# CALCULATE ANNUALIZED RETURNS AND VOLATILITY FOR CLUSTERING
# =============================================================================

returns = pd.DataFrame()
returns['Returns'] = prices_df.pct_change().mean() * 252
returns['Volatility'] = prices_df.pct_change().std() * sqrt(252)
returns.dropna(inplace=True)


# =============================================================================
# PREPARE DATA FOR CLUSTERING ALGORITHM
# =============================================================================

# Convert returns and volatility to NumPy array (2D: assets × features)
data = np.asarray([
    np.asarray(returns['Returns']),
    np.asarray(returns['Volatility'])
]).T

# Remove rows with missing values (NaN)
data = data[~np.any(np.isnan(data), axis=1)]
X = data  # Final dataset to cluster

# Compute distortions (inertia) for k = 2 to 19
distortions = []
for k in range(2, 20):
    k_means = KMeans(n_clusters=k)
    k_means.fit(X)
    distortions.append(k_means.inertia_)



# =============================================================================
# 📊 VISUALIZATION SECTION
# =============================================================================
# This section includes plots to analyze the clustering results:
# - Elbow Method to determine optimal number of clusters
# - Scatter plot of Return vs Volatility with color-coded clusters
# - Annotation of selected tickers and interpretation of cluster centroids


# -----------------------------------------------------------------------------
# 🔹 Plot 1: Elbow Method to Select Optimal K
# -----------------------------------------------------------------------------
# This plot shows the distortion (inertia) for different values of K in KMeans.
# The chosen optimal number of clusters (K = 4) is highlighted.
fig = plt.figure(figsize=(12, 6))
plt.plot(range(2, 20), distorsions)

plt.title('Elbow Method', fontsize=20, weight='bold')
plt.xlabel('Number of Clusters (K)', fontsize=14)
plt.grid(True, linestyle='--', alpha=0.7)

optimal_k = 4
optimal_distortion = distorsions[optimal_k -

plt.plot(optimal_k, optimal_distortion, 'ro', markersize=20,
         markerfacecolor='none', markeredgewidth=1.5,
         label=f'K Ottimale = {optimal_k}')
plt.axvline(x=optimal_k, color='grey', linestyle='--', lw=1.5)

plt.legend(fontsize=12)
plt.tight_layout()
plt.show()


# -----------------------------------------------------------------------------
# 🔹 Plot 2: Return vs Volatility (colored by Cluster)
# -----------------------------------------------------------------------------
# Assets are plotted by return and volatility. Each point is colored by cluster label.
# A few selected tickers are annotated.
plt.figure(figsize=(15, 7))
scatter = plt.scatter(
    clusters_df['Returns'], clusters_df['Volatility'], 
    c=clusters_df['Cluster'], cmap='viridis', s=150, alpha=0.5
)

plt.title('Scatter Plot: Return vs. Volatility', fontsize=20, weight='bold')
plt.xlabel('Return', fontsize=14)
plt.ylabel('Volatility', fontsize=14)

cbar = plt.colorbar(scatter)
cbar.set_label('Cluster', fontsize=15)
plt.grid(True, linestyle='--', alpha=0.6)

# Annotate selected tickers
tickers_to_annotate = ['PYPL', 'CRWD', 'INTU', 'EA']
for ticker in tickers_to_annotate:
    ticker_data = clusters_df[clusters_df['Symbol'] == ticker]
    cluster_value = ticker_data['Cluster'].values[0]
    color = scatter.cmap(scatter.norm(cluster_value))

    plt.annotate(
        ticker,
        (ticker_data['Returns'].values[0], ticker_data['Volatility'].values[0]),
        textcoords="offset points",
        xytext=(0,25),
        ha='center',
        fontsize=18,
        bbox=dict(boxstyle="round,pad=0.3", edgecolor=color, facecolor=color, alpha=0.8),
        arrowprops=dict(arrowstyle="-", color='black', lw=1.0)
    ) 

plt.tight_layout()
plt.show()


# -----------------------------------------------------------------------------
# 🔹 Plot 3: Interpret Clusters and Find Closest Tickers to Centroids
# -----------------------------------------------------------------------------
# Assign names to clusters and find the most representative asset for each.

# Assign semantic labels to clusters
names = {
    2:'low-low',
    1:'high-high', 
    0:'mid-mid',
    3:'low-high'
}

clusters_df['Cluster_Name'] = clusters_df['Cluster'].map(names)

# Find closest title to each cluster centroid
distances = np.linalg.norm(data[:, np.newaxis] - centroids, axis=2)
closest_titles_indices = np.argmin(distances, axis=0)
closest_titles = [returns.index[idx] for idx in closest_titles_indices]

closest_titles_df = pd.DataFrame({
    'Cluster': range(4),
    'Closest_Ticker': closest_titles
})

print(closest_titles_df)
