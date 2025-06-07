% -----------------------------------------------------------------------------
%% Value at Risk and Expected Shortfall Estimation
% -----------------------------------------------------------------------------

%% Equally-Weighted portfolio definition without transaction costs,
%% with total investment of $10,000
Weights         = ones(1, 9) / 9;
Investment      = 1e4;
portfolioReturns = sum(ndx_synt .* Weights, 2);
portfolioValue   = Investment * (1 + portfolioReturns);
portfolioPnL     = diff(portfolioValue);



% ========================================================================
%% 📈 VISUALIZATION SECTION
% ========================================================================
figure;
plot(Fulldates, portfolioValue, 'Color', [.4, .4, .4], 'LineWidth', 2);
title('Daily Value of the EW Portfolio', FontSize=18);
ylabel('USD');
