% -----------------------------------------------------------------------------
%% VAR-DCC-GARCH Estimation and Likelihood Ratio Comparison
% -----------------------------------------------------------------------------
% Description:
%
%     This script compares a standard DCC-GARCH model with a VAR-DCC-GARCH
%     specification, where the VAR(1) component captures conditional mean
%     effects. The comparison is conducted via:
%        - ADF test to ensure stationarity of all series
%        - Estimation of a VAR(p) model using BIC for lag selection
%        - DCC-GARCH estimation on VAR residuals
%        - Likelihood Ratio Test (LRT) to compare DCC-GARCH vs. VAR-DCC-GARCH
% -----------------------------------------------------------------------------
