% -----------------------------------------------------------------------------
%% Value at Risk and Expected Shortfall Estimation
% -----------------------------------------------------------------------------


%% Definition of significance levels
alpha_5 = 0.05;
alpha_1 = 0.01;

%% Function to calculate VaR
VaR_formula = @(mu, sigma, alpha) - (mu + sigma * norminv(1 - alpha));

%% Var integration function to calculate ES
ES_formula = @(mu, sigma, alpha) + (1 / alpha) * integral(@(p) VaR_formula(mu, sigma, p), 0, alpha);

%% Calculation of Dynamic VaR and ES for the selected model
% For loop to calculate VaR and ES for each time point
for i = 1:length(Ht_garch_VAR)

    % Extraction of the dynamic conditional covariance matrix
    covarianceMatrix_dyn = Ht_garch_VAR(:, :, i);

    % Calculation of portfolio standard deviation
    portfolioSigma_dyn = sqrt(Weights * covarianceMatrix_dyn * Weights');
    portfolioMu_dyn    = portfolioReturns(i);

    % Calculation of VaR and ES for a 1% significance level
    var_mov_1_dyn(i) = VaR_formula(portfolioMu_dyn, portfolioSigma_dyn, alpha_1) * Investment;
    es_mov_1_dyn(i)  = ES_formula(portfolioMu_dyn, portfolioSigma_dyn, alpha_1) * Investment;

    % Calculation of VaR and ES for a 5% significance level
    var_mov_5_dyn(i) = VaR_formula(portfolioMu_dyn, portfolioSigma_dyn, alpha_5) * Investment;
    es_mov_5_dyn(i)  = ES_formula(portfolioMu_dyn, portfolioSigma_dyn, alpha_5) * Investment;
end

%% Calculation of dynamic VaR and ES averages for each significance level
mean_var_5 = mean(var_mov_5_dyn);
mean_var_1 = mean(var_mov_1_dyn);
mean_es_5  = mean(es_mov_5_dyn);
mean_es_1  = mean(es_mov_1_dyn);
