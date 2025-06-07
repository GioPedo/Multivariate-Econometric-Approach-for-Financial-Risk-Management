# Dynamic Correlation for Risk Assessment in Finance
This repository contains a **multivariate econometric study** that has been applied to the financial risk management of an equally weighted (EW) portfolio.

Starting with a set of securities selected through a _machine learning_ (ML) technique and an aggregated macroeconomic-financial index, the study examines the _evolution of the pairwise correlations_ between the purpose-built index and each security over a 5-year horizon, and applies the final results to estimate the _Value at Risk_ (VaR) and the _Expected Shortfall_ (ES) of an EW portfolio.

In addition, the research is carried out on the same dataset, but excluding the most turbulent months of the COVID-19 pandemic in order to analyse _differences_ in both econometric and risk management results.


## Repository Structure
The repository is organized into two main directories:
- `code/`, which contains all the scripts used for data processing,clustering, econometric modelling and portfolio risk estimation;
- `docs/`, which includes the full thesis and its supporting presentation.

The structure is shown below:
```
.
├── 01_clustering_and_macro_index/
│ ├── cluster_analysis.py             # Clustering of NASDAQ-100 using KMeans
│ ├── macro_financial_index.m         # Macro-financial index with GARCH(1,1) weights
│ └── macro_index_README.md
│ └── README.md
│
├── 02_dcc_garch_models/
│ ├── dcc_main_driver.m               # Master script for DCC/VAR pipeline
│ ├── dcc_compute_rolling.m           # Rolling correlation benchmark
│ ├── dcc_estimate_all_models.m       # DCC, GJR, TARCH, ADCC variants
│ ├── dcc_model_selection.m           # RMSE-based model selection
│ ├── dcc_compare_with_VAR.m          # VAR-DCC implementation + LRT
│ ├── dcc_generate_plots.m            # Generates all plots
│ └── README.md
│
├── 03_advanced_risk_management/
│ ├── EW_portfolio.m                  # Portfolio P&L based on equal weights
│ ├── VaR_ES.m                        # Dynamic VaR and ES estimation
│ ├── VaR_ES_breaches.m               # VaR and ES exceedance visualization
│ └── README.md
│
├── docs/
├── MSc_Thesis_Giovanni_Pedone.pdf
├── Presentation_Dissertation.pdf
│
└── README.md                         # This file
```
**_Note_**: each main subdirectory (e.g., `01_clustering_and_macro_index`, `02_dcc_garch_models`, `03_advanced_risk_management`)
contains an `images/` folder that stores the plots generated within that specific study section.


## How to Run

### Requirements
- **Python 3.11** (or later recommended)
  - [Anaconda](https://www.anaconda.com/) (recommended for package management)  
  - IDE: Spyder (used in development)  
- **MATLAB R2023a** (or later recommended)
  - Econometrics Toolbox
  - Statistics and Machine Learning Toolbox
  - Financial Toolbox
  - **MFE Toolbox by Kevin Sheppard** (for `dcc.m`)  
    → [MFE Toolbox - dcc.m](https://github.com/bashtage/mfe-toolbox/blob/main/multivariate/dcc.m)
