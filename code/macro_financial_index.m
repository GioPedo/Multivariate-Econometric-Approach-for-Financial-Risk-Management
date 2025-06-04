%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: Construction of the Macro-Financial Index
% Author: Giovanni Pedone
% Thesis Date: 17-Oct-2024
% GitHub Publication: June 2025
%
% Description:
%     This script builds a macro-financial index using macroeconomic variables
%     (gold, oil, VIX, FVX, CPI, LOIS), by estimating conditional volatility via
%     GARCH(1,1), assigning normalized inverse-volatility weights, and aggregating
%     into a single composite index for the US economy.
%
% Data sources: Yahoo Finance, Bloomberg, FRED (2019–2024)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% 1. Import Macro-Financial Data
% Load price series from Excel
gold_p = readmatrix('Macro_Variables.xlsx', 'Sheet', 'Data', 'Range', 'B2:B1259');
wti_p  = readmatrix('Macro_Variables.xlsx', 'Sheet', 'Data', 'Range', 'C2:C1259');
vix_p  = readmatrix('Macro_Variables.xlsx', 'Sheet', 'Data', 'Range', 'D2:D1259');
fvx_p  = readmatrix('Macro_Variables.xlsx', 'Sheet', 'Data', 'Range', 'E2:E1259');

% Compute returns or differences
gold = price2ret(gold_p);
wti  = price2ret(wti_p);
vix  = price2ret(vix_p);
fvx  = diff(fvx_p);

% Load Libor and OIS to compute LOIS spread
libor_p = readmatrix('Macro_Variables.xlsx', 'Sheet', 'Data', 'Range', 'F2:F1259');
ois_p   = readmatrix('Macro_Variables.xlsx', 'Sheet', 'Data', 'Range', 'G2:G1259');

lois_p = libor_p - ois_p;
lois   = diff(lois_p);


%% 2. Interpolate and Transform CPI (from FRED)
datasource_fred = fred;
cpi_fred = fetch(datasource_fred, 'CPIAUSCL');
cpi = cpi_fred.Data;

% Interpolation to daily frequency
% (assumes date matching already handled externally or not needed)
date_m = readmatrix('Macro_Variables.xlsx', 'Sheet', 'Data', 'Range', 'I2:I62');
date_d = readmatrix('Macro_Variables.xlsx', 'Sheet', 'Data', 'Range', 'A2:A1259');
cpi_m  = readmatrix('Macro_Variables.xlsx', 'Sheet', 'Data', 'Range', 'H2:H62');

cpi_p = interp1(date_m, cpi_m, date_d, 'linear');

% Compute daily inflation log-differenced
log_cpi_p     = log(cpi_p);
inflation_log = diff(log_cpi_p);
cpi_d         = inflation_log * 100;


%% 3. Group Variables into Cell Arrays (for GARCH loop later)
macro_variables = {gold, wti, vix, fvx, cpi_d, lois};
macro_variables_names = {'GOLD', 'WTI', 'VIX', 'FVX', 'CPI', 'LOIS'};


%% 4. Estimate Conditional Volatility with GARCH(1,1)
% Initialize model containers
models         = cell(1, numel(macro_variables));
fits           = cell(1, numel(macro_variables));
vol_forecast   = cell(1, numel(macro_variables));
parameters_fitted = cell(3, numel(macro_variables));

% Loop through each variable to fit GARCH(1,1)
for i = 1:numel(macro_variables)
    
    % Fit GARCH(1,1) model
    models{i} = garch('GARCHLags', 1, 'ARCHLags', 1, 'Offset', NaN);
    fits{i}   = estimate(models{i}, macro_variables{i});
    
    % Extract fitted parameters (omega, alpha, beta)
    omega = fits{i}.Constant;
    alpha = fits{i}.ARCH{1};
    beta  = fits{i}.GARCH{1};
    
    parameters_fitted(:, i) = {omega; alpha; beta};
    
    % Compute conditional volatility forecast (daily)
    vol_forecast{i} = sqrt(infer(fits{i}, macro_variables{i}));
end


%% 5. Display Fitted GARCH(1,1) Parameters
% Print the estimated parameters (omega, alpha, beta) for each macro variable
for i = 1:numel(macro_variables)
    fprintf('Fitted parameters for %s:\n', macro_variables_names{i});
    fprintf('Omega: %.4f\n', parameters_fitted{1, i});
    fprintf('Alpha: %.4f\n', parameters_fitted{2, i});
    fprintf('Beta: %.4f\n\n', parameters_fitted{3, i});
end


%% 6. Construct the Macro-Financial Index
% Use inverse-volatility weights to compute a composite macro index
% Compute inverse-volatility weights
weight_gold   = 1./mean(vol_forecast{1});
weight_wti    = 1./mean(vol_forecast{2});
weight_vix    = 1./mean(vol_forecast{3});
weight_fvx    = 1./mean(vol_forecast{4});
weight_cpi_d  = 1./mean(vol_forecast{5});
weight_lois   = 1./mean(vol_forecast{6});

% Normalize weights
weights_norm = [weight_gold, weight_wti, weight_vix, ...
                weight_fvx, weight_cpi_d, weight_lois];
weights_norm = weights_norm ./ sum(weights_norm);

% Construct the macro index as weighted sum
index_macro = weights_norm(:, 1) .* gold + ...
              weights_norm(:, 2) .* wti + ...
              weights_norm(:, 3) .* vix + ...
              weights_norm(:, 4) .* fvx + ...
              weights_norm(:, 5) .* cpi_d + ...
              weights_norm(:, 6) .* lois;



%% 📈 VISUALIZATION SECTION
% ========================================================================
% This section plots the resulting macro-financial index constructed
% using inverse-volatility weights across macroeconomic variables.
% ========================================================================
figure(2);
plot(Fulldates, index_macro, 'Color', 'b', 'LineWidth', 1.8);
title('Returns Macro-Financial Index', 'FontSize', 20);
ylabel('%');
xtickformat(dateformat);
