% Specificare che alla data dello studio i risultati sono stati i seguenti ma, date le variazioni di mercato e
% l'indice preso in considerazione, i risultati possono cambiare runnundo in un secondo momento

## Importing ------------------------------------------------------------------
import numpy as np, pandas as pd, yfinance as yf, plotly.express as px
from matplotlib import pyplot as plt
px.default='svg'
from scipy.cluster.vq import kmeans,vq
from math import sqrt
from sklearn.cluster import KMeans 
from pandas_datareader import data as pdr
yf.pdr_override()
from datetime import datetime

## Webscraping ----------------------------------------------------------------
nasdaq100_url = 'https://en.wikipedia.org/wiki/Nasdaq-100'
# Read in the url and scrape ticker data
data_table = pd.read_html(nasdaq100_url)
tickers = data_table[4]['Symbol'].values.tolist()
tickers = [s.replace('\n', '') for s in tickers]
tickers = [s.replace('.', '-') for s in tickers]
tickers = [s.replace(' ', '') for s in tickers]

## Downaload from YFinance ----------------------------------------------------
startdate = datetime(2019,1,1)
enddate = datetime(2024,1,1)
# Download prices
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
        pass
    prices_df = pd.concat(prices_list,axis=1)
prices_df.sort_index(inplace=True)

# Create an empty dataframe
returns = pd.DataFrame()
# Define the column Returns
returns['Returns'] = prices_df.pct_change().mean() * 252
# Define the column Volatility
returns['Volatility'] = prices_df.pct_change().std() * sqrt(252)
returns.dropna(inplace=True)


# Recreate data to feed into the algorithm
data = np.asarray([np.asarray(returns['Returns']),
                   np.asarray(returns['Volatility'])]).T
# Temp dropping NaN
nan_mask = np.any(np.isnan(data), axis=1)
# Remove rows with NaN values
data = data[~nan_mask]
X = data

## KMeans Cluster -------------------------------------------------------------
distorsions = []
for k in range(2, 20):
    k_means = KMeans(n_clusters=k)
    k_means.fit(X)
    distorsions.append(k_means.inertia_)




%%%%%%%%%%%%%%% PLOT
# Enhanced plot
fig = plt.figure(figsize=(12, 6))
plt.plot(range(2, 20), distorsions)
# Add title with larger font and bold text
plt.title('Metodo del Gomito (Elbow Method)', fontsize=20, weight='bold')
# Add labels for axes
plt.xlabel('Numero di Cluster (K)', fontsize=14)
# Customize grid
plt.grid(True, linestyle='--', alpha=0.7)
# Set optimal k value and corresponding distortion
optimal_k = 4
optimal_distortion = distorsions[optimal_k - 2]  # Index shifted by 2 due to range(2, 20)
# Plot a red circle around the optimal point
plt.plot(optimal_k, optimal_distortion, 'ro', markersize=20, markerfacecolor='none', markeredgewidth=1.5, label=f'K Ottimale = {optimal_k}')
# Add a green vertical line to mark the elbow visually
plt.axvline(x=optimal_k, color='grey', linestyle='--', lw=1.5)
# Add a legend
plt.legend(fontsize=12)
# Show plot
plt.tight_layout()
plt.show()
