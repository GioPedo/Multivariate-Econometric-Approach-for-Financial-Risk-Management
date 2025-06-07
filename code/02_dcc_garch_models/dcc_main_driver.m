# =============================================================================
% Title: Estimation and Evaluation of DCC-GARCH Models
% Author: Giovanni Pedone
% Thesis Date: 17-Oct-2024
% GitHub Upload: June 2025
%
% Description:
%     This script implements and evaluates a range of multivariate GARCH models 
%     to analyze dynamic correlations between a macro-financial index and selected assets.
%     The process includes:
%         - computing rolling window correlations (as a benchmark),
%         - estimating several DCC-type models (including TARCH, GJR, and asymmetric variants),
%         - selecting the best specification based on statistical performance (RMSE),
%         - extending the analysis with a VAR-DCC-GARCH approach to account for conditional means.
%
%     The final comparison provides insight into model suitability for capturing 
%     time-varying correlations relevant to market risk analysis.
%
% NOTE:
%     Requires the MFE Toolbox by Kevin Sheppard:
%     https://github.com/bashtage/mfe-toolbox/blob/main/multivariate/dcc.m
%     Add the toolbox to the MATLAB path before running.
# =============================================================================

%% 1. Initialization
clear; clc;

%% 2. Rolling Window Correlation Benchmark
dcc_compute_rolling;

%% 3. Estimate all DCC-type models
dcc_estimate_all_models;

%% 4. Model Selection (RMSE)
dcc_model_selection;

%% 5. Compare Best DCC vs VAR-DCC (LRT)
dcc_compare_with_VAR;

%% 6. Generate Plots
dcc_generate_plots;
