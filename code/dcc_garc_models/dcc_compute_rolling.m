%% compute_rolling_correlation.m
% This script merges the macro index and asset returns,
% then computes the 90-day rolling window correlation matrix

% -----------------------------------------------------------------------------
% INPUT (assumed preloaded):
% - index_macro: [T x 1] macro-financial index time series
% - msft, aapl, nvda, amzn, crwd, ea, intu, pypl: asset returns [T x 1]
% - Fulldates: [T x 1] datetime vector
% -----------------------------------------------------------------------------

%% 1. Merge Data
ndx_synt = [index_macro, msft, aapl, nvda, amzn, crwd, ea, intu, pypl];
stocks_names = {'MSFT','AAPL','NVDA','AMZN','CRWD','EA','INTU','PYPL'};


%% 2. Rolling Correlation Parameters
window_size = 90;
total_length = length(ndx_synt);
rolling_corr = NaN(total_length, 8);  % 8 asset correlations


%% 3. Compute Rolling Correlations
for i = 1:total_length
    start_index = max(i - window_size + 1, 1);
    end_index = min(i + window_size - 1, total_length);
    window_data = ndx_synt(start_index:end_index, :);
    rolling_corr(i, :) = corr(window_data(:, 1), window_data(:, 2:end));
end


%% 4. Convert to Timetable
Fulldates_datetime = datetime(Fulldates);
rolling_corr_table = array2timetable(rolling_corr, 'RowTimes', Fulldates_datetime);
rolling_corr_table.Properties.VariableNames = stocks_names;



# =============================================================================
%% 📈 Final Plot: 90-Day Rolling Window Correlations
# =============================================================================
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
