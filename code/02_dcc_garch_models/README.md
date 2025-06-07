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
  - Step 5: compare best DCC vs. VAR-DCC → via `dcc_compare_with_VAR`
  - Step 6: generate plots → through `dcc_generate_plots`

## 🖼️ Sample Output

<p align="center">
  <img src="images/Rolling_Window_Correlations.jpg" width="700"/>
  <br>
  <img src="images/DCC_Models_Parameters.png" width="550"/>
  <br>
  <img src="images/DCC_and_Rolling_Correlations_Comparison.jpg" width="700"/>
</p>
