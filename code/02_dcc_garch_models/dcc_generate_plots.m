% =============================================================================
%% 📈 90-Day Rolling Window Correlations
% =============================================================================
figure;
stackedplot(rolling_corr_timetable, ...
    'Color', [0.6350 0.0780 0.1840], ...
    'LineWidth', 2);

annotation('textbox', [0 0.88 1 0.1], ...
    'String', ['90-Day Rolling Window Correlations ' ...
               'between Macroeconomic-Financial Index & Assets'], ...
    'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center', ...
    'FontWeight', 'bold', ...
    'FontSize', 20);


% =============================================================================
%% 📈 1st comparison: Dynamic Correlations – Rolling Window vs. DCC-GARCH
% =============================================================================
figure;
subplot(2, 1, 1);
plot(DCC_GARCH(:, 2:end), 'LineWidth', 2.5);
title('DCC-GARCH(1,1)', FontSize=14);
ylabel('Correlations');
legend_names = strcat('Macro Index/', stocks_names(1:end));
legend(legend_names, 'Location', 'southeast', 'NumColumns', 2);
subplot(2, 1, 2);
plot(rolling_corr, 'LineWidth', 2.5);
title('90-Day Rolling Window Correlation', FontSize=14);
ylabel('Correlations');
annotation('textbox', [0 0.905 1 0.1], 'String', ...
        'Comparison of DCC-GARCH(1,1) and 90-Day Rolling Window Correlations', ...
        'EdgeColor', 'none', 'HorizontalAlignment', 'center', ...
        'FontWeight', 'bold', FontSize=18);


% =============================================================================
%% 📈 2nd comparison: Dynamic Correlations – VAR-DCC-GARCH vs. DCC-GARCH
% =============================================================================
figure;
subplot(2, 1, 1);
plot(DCC_GARCH_VAR(:, 2:end), 'LineWidth', 2.5);
title('VAR(1)-DCC-GARCH(1,1)', FontSize=14);
ylabel('Correlations');
legend_names = strcat('Macro Index/', stocks_names(1:end));
legend(legend_names, 'Location', 'northeast');
subplot(2, 1, 2);
plot(DCC_GARCH(:, 2:end), 'LineWidth', 2.5);
title('DCC-GARCH(1,1)', FontSize=14);
ylabel('Correlations');
annotation('textbox', [0 0.905 1 0.1], 'String', ...
        'Comparison of VAR(1)-DCC-GARCH(1,1) and DCC-GARCH(1,1) Correlations', ...
        'EdgeColor', 'none', 'HorizontalAlignment', 'center', ...
        'FontWeight', 'bold', FontSize=18);
