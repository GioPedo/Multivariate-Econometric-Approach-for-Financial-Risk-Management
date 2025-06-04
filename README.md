# Dynamic Correlation for Risk Assessment in Finance
This repository contains a **multivariate econometric study** that has been applied to the financial risk management of an equally weighted (EW) portfolio.

Starting with a set of securities selected through a _machine learning_ (ML) technique and an aggregated macroeconomic-financial index, the study examines the _evolution of the pairwise correlations_ between the purpose-built index and each security over a 5-year horizon, and applies the final results to estimate the _Value at Risk_ (VaR) and the _Expected Shortfall_ (ES) of an EW portfolio.

In addition, the research is carried out on the same dataset, but excluding the most turbulent months of the COVID-19 pandemic in order to analyse _differences_ in both econometric and risk management results.

## Repository Structure

```
.
├── code/                           # Source code for financial analysis
│ ├── cluster_analysis.py           # Clustering of NASDAQ-100 using KMeans
│ ├── macro_financial_index.m       # Construction of macro-financial index with GARCH(1,1)
│ ├── dcc_garch_models.m            # Implementation of DCC-GARCH dynamic correlation model
│ ├── VaR_ES.m                      # Calculation of VaR and Expected Shortfall
│ └── VaR_ES_breaches.m             # Analysis of VaR and ES breaches
│
├── docs/
│ ├── MSc_Thesis_Giovanni_Pedone.pdf
│ └── Presentation_Dissertation.pdf
│
└── README.md                       # This file
```
