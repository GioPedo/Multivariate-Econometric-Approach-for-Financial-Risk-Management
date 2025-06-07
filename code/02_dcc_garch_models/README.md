# DCC-GARCH Models

This section focuses on modeling dynamic correlations between the macro-financial index and asset returns using DCC-GARCH models.

## Overview

- **Rolling Correlation**: computes 90-day rolling correlations as a benchmark.
- **DCC-GARCH Models**: estimates various models to capture dynamic correlations.
- **VAR-DCC Comparison**: analyses models with and without conditional mean components.

## File Structure

- `dcc_main_driver.m`: main script for executing the complete workflow:
  - Step 1: initialization (`clear`, `clc`)
  - Step 2: rolling correlation benchmark → calls `dcc_compute_rolling`
  - Step 3: estimate all DCC-type models → runs `dcc_estimate_all_models`
  - Step 4: select best model by RMSE → uses `dcc_model_selection`
  - Step 5: compare best DCC vs VAR-DCC using LRT → via `dcc_compare_with_VAR`
  - Step 6: generate plots → through `dcc_generate_plots`
- `dcc_compute_rolling.m`: computes rolling correlations.
- `dcc_estimate_all_models.m`: estimates all DCC-type models.
- `dcc_model_selection.m`: selects best model (RMSE).
- `dcc_compare_with_VAR.m`: compares DCC vs VAR-DCC (LRT).
- `dcc_generate_plots.m`: creates final visualizations.

## 🖼️ Sample Output

<p align="center">
  <img src="images/Rolling_Window_Correlations.jpg" width="700"/>
</p>
