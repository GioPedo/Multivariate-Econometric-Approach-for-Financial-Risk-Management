%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title: VaR and ES Breaches
% Author: Giovanni Pedone
% Thesis Date: 17-Oct-2024
% GitHub Publication: June 2025
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% 1. VaR Breaches Identification
% This section detects portfolio losses that fall below the estimated dynamic
% Value-at-Risk thresholds at 95% and 99% significance levels using the 
% VAR(1)-DCC-GARCH(1,1) model.

portfolioValue = portfolioReturns * Investment;
rFulldates = Fulldates(2:end);
portfolioValue = portfolioValue(2:end);

figure;
plot(rFulldates, portfolioValue, 'Color', [.6, .6, .6], 'LineWidth', 2);
hold on;

% Identify violations below 95% and 99% VaR, only if actual loss occurred
violations_95 = (portfolioValue < var_mov_5_dyn') & (portfolioValue < 0);
violations_99 = (portfolioValue < var_mov_1_dyn') & (portfolioValue < 0);

% Highlight breaches
plot(rFulldates(violations_95), portfolioValue(violations_95), 'bo', ...
    'MarkerFaceColor', 'b', 'MarkerSize', 8);
plot(rFulldates(violations_99), portfolioValue(violations_99), 'ro', ...
    'MarkerFaceColor', 'r', 'MarkerSize', 8);

% Annotation and legend
annotation('textbox', [0 0.88 1 0.1], 'String', ...
    'Violations Dynamic VaR combined with \Sigma_{DCC/GARCH} of VAR-DCC-GARCH model', ...
    'EdgeColor', 'none', 'HorizontalAlignment', 'center', ...
    'FontWeight', 'bold', 'FontSize', 20);
ylabel('USD');
legend({'P&L', 'VaR_{95%} Breaches', 'VaR_{99%} Breaches'}, ...
    'Location', 'northeast');
hold off;


%% 2. ES Breaches
% This section compares the P&L distribution under Covid and Ex-Covid periods
% and highlights the average ES at 95% and 99% significance levels.

es_limit_5 = mean_es_5;
es_limit_1 = mean_es_1;
es_limit_5_nc = mean(es_mov_5_dyn_nc);

figure;

% Histogram: Covid period
h1 = histogram(portfolioValue, 75, 'FaceColor', [0.7 0.7 0.7], ...
    'EdgeColor', 'k', 'DisplayName', 'Covid');
hold on;

% Bin values
binEdges = h1.BinEdges;
binCounts = h1.Values;
binCenters = binEdges(1:end-1) + diff(binEdges)/2;

% Color under ES thresholds (Covid)
for i = 1:length(binCenters)
    if binCenters(i) <= es_limit_5
        patch([binEdges(i), binEdges(i), binEdges(i+1), binEdges(i+1)], ...
              [0, binCounts(i), binCounts(i), 0], 'b', ...
              'FaceAlpha', 0.5, 'EdgeColor', 'b');
    end
    if binCenters(i) <= es_limit_1
        patch([binEdges(i), binEdges(i), binEdges(i+1), binEdges(i+1)], ...
              [0, binCounts(i), binCounts(i), 0], 'r', ...
              'FaceAlpha', 0.5, 'EdgeColor', 'r');
    end
end

% ES lines and labels
x1 = xline(es_limit_5, '-.b', ...
    ['ES_{95%} = ' num2str(es_limit_5, '%.2f')], ...
    'LineWidth', 2, 'LabelHorizontalAlignment', 'center', ...
    'LabelVerticalAlignment', 'middle');
x1.FontWeight = 'bold';
x1.FontSize = 17;

x2 = xline(es_limit_1, '-.r', ...
    ['ES_{99%} = ' num2str(es_limit_1, '%.2f')], ...
    'LineWidth', 2, 'LabelHorizontalAlignment', 'center', ...
    'LabelVerticalAlignment', 'middle');
x2.FontWeight = 'bold';
x2.FontSize = 17;

% Histogram: Ex-Covid period
h2 = histogram(portfolioValue_nc, 75, 'FaceColor', [0.2 0.2 0.2], ...
    'EdgeColor', 'k', 'DisplayName', 'Ex-Covid');
h2.FaceAlpha = 0.35;

% Bin values (Ex-Covid)
binEdges2 = h2.BinEdges;
binCounts2 = h2.Values;
binCenters2 = binEdges2(1:end-1) + diff(binEdges2)/2;

% Color under ES thresholds (Ex-Covid)
for i = 1:length(binCenters2)
    if binCenters2(i) <= es_limit_5
        patch([binEdges2(i), binEdges2(i), binEdges2(i+1), binEdges2(i+1)], ...
              [0, binCounts2(i), binCounts2(i), 0], 'b', ...
              'FaceAlpha', 0.3, 'EdgeColor', 'b');
    end
    if binCenters2(i) <= es_limit_1
        patch([binEdges2(i), binEdges2(i), binEdges2(i+1), binEdges2(i+1)], ...
              [0, binCounts2(i), binCounts2(i), 0], 'r', ...
              'FaceAlpha', 0.3, 'EdgeColor', 'r');
    end
end

% Titles and labels
title('P&L and Expected Shortfall Comparison', 'FontSize', 20);
xlabel('USD');
ylabel('Counts');
legend([h1, h2], {'Covid', 'Ex-Covid'}, 'Location', 'northeast');
hold off;
