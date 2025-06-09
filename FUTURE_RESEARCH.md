# Future Research

This section outlines potential enhancements and methodological directions that can expand and refine the current project.

---

## 1. Alternative Clustering Techniques

The current project relies on K-Means for stock selection. However, alternative methods may offer better robustness in financial datasets:

- **DBSCAN**: density-based clustering method that filters out noise and identifies arbitrarily shaped groups. Useful for isolating niche stock segments with distinct risk-return profiles.

- **Spectral Clustering**: uses similarity graphs to uncover latent structures in asset relationships. Especially effective in capturing non-convex clusters and correlation-based communities.

---

## 2. Dimensionality Reduction

- **PCA (Principal Component Analysis)** can be integrated to reduce data dimensionality and identify stocks that align with major systemic risk factors.
- PCA helps extract dominant sources of market variance, improving representativeness in high-dimensional data.

---

## 3. Econometric Extensions

More advanced econometric models can be explored to better capture the complexity of financial dependencies:

- **Copula-DCC Models**: separate marginal distributions from dependence structure, enabling more flexible modeling.
- **Wavelet-DCC Models**: incorporate time-frequency decomposition for analyzing multi-scale dynamics.
- **Mixture Models**: capture multimodal behaviors in volatility and correlation regimes.
- **Non-Normal Error Distributions**: incorporate t-distributions or skewed models to improve tail risk modeling.

---

## 4. Applied Use Cases

Dynamic correlation models like DCC can be applied in practical domains such as:

- **Derivative Hedging**: optimize time-varying hedge ratios across multiple instruments.
- **Currency Risk**: estimate dynamic hedge ratios under varying macro conditions.
- **Cryptocurrencies**: monitor conditional correlations in volatile markets (e.g., during COVID-19).
- **Multi-Asset Portfolios**: combine equities, commodities, and currencies for enhanced diversification and risk control.

---

> These extensions aim to advance financial risk modeling by incorporating modern data science methods and aligning with current research on market dependencies and tail risk management.
