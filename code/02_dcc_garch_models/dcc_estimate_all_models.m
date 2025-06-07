% -------------------------------------------------------------------------
%% Estimation of the Dynamic Conditional Correlation (DCC) model
% -------------------------------------------------------------------------
%% 1. Estimate DCC-GARCH model
[parameters_garch, ll_garch, Ht_garch, vcv_garch] = dcc(ndx_synt, [], 1, 0, 1, 1, 0, 1, 2);

%% 2. Calculate Dynamic Correlations
for t = 1:length(ndx_synt)
    for j = 2:size(ndx_synt, 2)
        if j == 1
            DCC_GARCH(t, j) = 1;
        else
            DCC_GARCH(t, j) = Ht_garch(1, j, t) / (sqrt(Ht_garch(1, 1, t)) * sqrt(Ht_garch(j, j, t)));
        end
    end
end

%% 3. Extract alpha and beta parameters
alpha_dccgarch = parameters_garch(end-1);
beta_dccgarch  = parameters_garch(end);

%% 4. Compute standard errors
se_alpha_dccgarch = sqrt(vcv_garch(end-1, end-1));
se_beta_dccgarch  = sqrt(vcv_garch(end, end));

%% 5. Compute t-statistics
t_alpha_dccgarch = alpha_dccgarch / se_alpha_dccgarch;
t_beta_dccgarch  = beta_dccgarch / se_beta_dccgarch;

%% 6. Compute p-values
p_value_alpha_dccgarch = 2 * (1 - normcdf(abs(t_alpha_dccgarch)));
p_value_beta_dccgarch  = 2 * (1 - normcdf(abs(t_beta_dccgarch)));


% -------------------------------------------------------------------------
%% Additional DCC-type Models
% -------------------------------------------------------------------------

% DCC-TARCH
[parameters_tarch, ll_tarch, Ht_tarch, vcv_tarch] = dcc(ndx_synt, [], 1, 0, 1, 1, 1, 1, 1);

% DCC-GJR-GARCH
[parameters_gjr, ll_gjr, Ht_gjr, vcv_gjr] = dcc(ndx_synt, [], 1, 0, 1, 1, 1, 1, 2);

% A(symmetric)DCC-GARCH
[parameters_agarch, ll_agarch, Ht_agarch, vcv_agarch] = dcc(ndx_synt, [], 1, 1, 1, 1, 0, 1, 2);

% ADCC-TARCH
[parameters_atarch, ll_atarch, Ht_atarch, vcv_atarch] = dcc(ndx_synt, [], 1, 1, 1, 1, 1, 1, 1);

% ADCC-GJR-GARCH
[parameters_agjr, ll_agjr, Ht_agjr, vcv_agjr] = dcc(ndx_synt, [], 1, 1, 1, 1, 1, 1, 2);
