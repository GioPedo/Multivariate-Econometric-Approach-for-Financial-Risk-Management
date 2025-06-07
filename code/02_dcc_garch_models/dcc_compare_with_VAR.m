% -----------------------------------------------------------------------------
%% VAR-DCC-GARCH Estimation and Likelihood Ratio Comparison
% -----------------------------------------------------------------------------
% Description:
%
%     This script compares a standard DCC-GARCH model with a VAR-DCC-GARCH
%     specification, where the VAR(1) component captures conditional mean
%     effects. The comparison is conducted via:
%        - ADF test to ensure stationarity of all series
%        - estimation of a VAR(p) model using AIC and BIC for lag selection
%        - DCC-GARCH estimation on VAR residuals
%        - likelihood ratio test (LRT) to compare DCC-GARCH vs. VAR-DCC-GARCH
% -----------------------------------------------------------------------------

%% ADF Test on Each Series
stocks_names_ADF = {'Index_Macro', 'Msft', 'Aapl', 'Nvda', 'Amzn', ...
                    'Crwd', 'Ea', 'Intu', 'Pypl'};
num_assets = length(stocks_names_ADF);

results_ADF = table('Size', [num_assets, 4], ...
    'VariableTypes', {'double', 'double', 'double', 'double'}, ...
    'VariableNames', {'H0', 'p-Value', 'Test Statistic', 'Critical Value'}, ...
    'RowNames', stocks_names_ADF);

for i = 1:num_assets
    [h, pValue, stat, cValue] = adftest(ndx_synt(:, i));
    results_ADF.(['H_{0}', num2str(i)]) = h;
    results_ADF.('p-Value')(i) = pValue;
    results_ADF.('Test Statistic')(i) = stat;
    results_ADF.('Critical Value')(i) = cValue;
end


%% VAR Lag Selection using AIC and BIC
maxLags = 10;
aic = zeros(maxLags, 1);
bic = zeros(maxLags, 1);

for p = 1:maxLags
    Mdl = varm(size(ndx_synt, 2), p);
    EstMdl = estimate(Mdl, ndx_synt);
    results = summarize(EstMdl);
    aic(p) = results.AIC;
    bic(p) = results.BIC;
end

[~, bestLagAIC] = min(aic);
[~, bestLagBIC] = min(bic);
optimalLags = bestLagBIC;


%% Estimate VAR(p) Model and Residuals
Mdl_VAR = varm(size(ndx_synt, 2), optimalLags);
EstMdl_VAR = estimate(Mdl_VAR, ndx_synt);
residuals_VAR = infer(EstMdl_VAR, ndx_synt);


%% DCC-GARCH on VAR Residuals
[parameters_garch_VAR, ll_garch_VAR, Ht_garch_VAR, vcv_garch_VAR] = ...
    dcc(residuals_VAR, [], 1, 0, 1, 1, 0, 1, 2);


%% Calculate Dynamic Correlations of VAR-DCC-GARCH
for t = 1:length(ndx_synt) - optimalLags
    for j = 2:size(ndx_synt, 2)
        if j == 1
            DCC_GARCH_VAR(t, j) = 1;
        else
            DCC_GARCH_VAR(t, j) = Ht_garch_VAR(1, j, t) / ...
                (sqrt(Ht_garch_VAR(1, 1, t)) * sqrt(Ht_garch_VAR(j, j, t)));
        end
    end
end


%% Extract Alpha and Beta
alpha_vardccgarch = parameters_garch_VAR(end-1);
beta_vardccgarch  = parameters_garch_VAR(end);

%% Standard Errors and t-Stats
se_alpha_vardccgarch = sqrt(vcv_garch_VAR(end-1, end-1));
se_beta_vardccgarch  = sqrt(vcv_garch_VAR(end, end));

t_alpha_vardccgarch = alpha_vardccgarch / se_alpha_vardccgarch;
t_beta_vardccgarch  = beta_vardccgarch / se_beta_vardccgarch;

%% p-values
p_value_alpha_vardccgarch = 2 * (1 - normcdf(abs(t_alpha_vardccgarch)));
p_value_beta_vardccgarch  = 2 * (1 - normcdf(abs(t_beta_vardccgarch)));


% -----------------------------------------------------------------------------
%% Likelihood Ratio Test
% -----------------------------------------------------------------------------
dof = optimalLags;
[h_lrtest, pValue_lrtest] = lratiotest(ll_garch_VAR, ll_garch, dof);
