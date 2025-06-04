# Macro-Financial Index Construction

This file documents the methodology and code used to construct a macro-financial index
representing U.S. economic and financial conditions. The index is later used in
a multivariate econometric study for financial risk management.

---

## Overview

The index is built using six macroeconomic and financial variables:

- **GOLD**: gold prices (as inflation hedge)
- **WTI**: oil prices (commodity inflation + global demand)
- **VIX**: implied equity volatility (market uncertainty)
- **FVX**: 5-year Treasury yields (interest rate environment)
- **CPI**: U.S. consumer price index (inflation)
- **LOIS**: Libor-OIS spread (systemic stress / credit risk)

These indicators capture different dimensions of market stress, inflation and risk aversion.

---

## Methodology

### 1. Data Preprocessing
- Raw data is loaded from an Excel file (`Macro_Variables.xlsx`) and FRED (via `fetch`).
- Price series are converted to returns or spreads (e.g., `Libor - OIS`).
- The CPI index is interpolated to daily frequency using linear interpolation.

### 2. Volatility Estimation
- Each time series is modeled using a **GARCH(1,1)** model.
- Conditional volatility is extracted from each fitted model.
- Estimation is performed using MATLAB’s `estimate()` on a GARCH template.

### 3. Index Aggregation
- The volatility of each series is averaged over time.
- Inverse volatilities are used as weights → `weight_i = 1 / mean(volatility_i)`
- Weights are normalized to sum to 1.
- Final index is computed as:  
  `Index(t) = Σ [normalized_weight_i × variable_i(t)]`

---

## File Structure

| File                        | Description                                  |
|-----------------------------|----------------------------------------------|
| `macro_financial_index.m`   | Main script: data processing, GARCH, index   |
| `Macro_Variables.xlsx`      | Excel file with raw macro data               |

---

## Time Horizon

- Frequency: **Daily**
- Period: **January 2019 – January 2024**
- Sources: **Yahoo Finance**, **Bloomberg**, **FRED**

---

## Notes

- The GARCH step is essential to capture heteroskedasticity in macro-financial time series.
- The methodology improves upon naive linear combinations by incorporating **risk-based weights**.
- This index can be used as an input in correlation analysis or DCC-GARCH estimation.

---

## Dependencies

- Spyder (Python IDE)
- MATLAB (Financial Toolbox)
- FRED API access (via `fetch`)

---

## Author

Giovanni Pedone  
Thesis Project, MSc Finance – University of Trento  
GitHub Publication: **June 2025**

