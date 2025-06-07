% -----------------------------------------------------------------------------
%% DCC-GARCH Model Selection by RMSE
% -----------------------------------------------------------------------------
% Output:
%   - Table with summed RMSE values for each model.
%   - Index of the model with minimum RMSE (best fit).
% -----------------------------------------------------------------------------

%% RMSE comparison of multivariate models
% RMSE calculation for each model
RMSE_GARCH   = rmse(DCC_GARCH(:,   2:end), rolling_corr, 'omitnan');
RMSE_TARCH   = rmse(DCC_TARCH(:,   2:end), rolling_corr, 'omitnan');
RMSE_GJR     = rmse(DCC_GJR(:,     2:end), rolling_corr, 'omitnan');
RMSE_AGARCH  = rmse(ADCC_GARCH(:,  2:end), rolling_corr, 'omitnan');
RMSE_ATARCH  = rmse(ADCC_TARCH(:,  2:end), rolling_corr, 'omitnan');
RMSE_AGJR    = rmse(ADCC_GJR(:,    2:end), rolling_corr, 'omitnan');

% Identification of optimal model
model_names = {'DCC_GARCH', 'DCC_TARCH', 'DCC_GJR', ...
               'ADCC_GARCH', 'ADCC_TARCH', 'ADCC_GJR'};

metric_models = array2table(sum([RMSE_GARCH; RMSE_TARCH; RMSE_GJR; ...
                                 RMSE_AGARCH; RMSE_ATARCH; RMSE_AGJR], 2), ...
                             'VariableNames', {'RMSE'});
metric_models.Properties.RowNames = model_names;
[~, best_model_index] = min(metric_models.RMSE);
