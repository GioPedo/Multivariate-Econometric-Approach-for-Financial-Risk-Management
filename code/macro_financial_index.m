%% Import Data
% Dataset
% Importo e calcolo i rendimenti delle variabili macro
%%%%% gold_p = gold serie price
%%%%% wti_p  = ""
%%%%% vix_p  = ""
%%%%% fvx_p  = ""
% Definisco e calcolo l'indice dei prezzi al consumo americano in dati
% giornalieri tramite interpolazione lineare
datasource_fred = fred;
d0 = '01-Jan-2019';
d1 = '01-Jan-2024';
cpi_fred = fetch(datasource_fred, 'CPIAUCSL', d0, d1);
cpi = cpi_fred.Data;
cpi_m  = "
cpi_p  = interp1(date_m, cpi_m, date_d, 'linear');





gold = price2ret(gold_p);
wti  = price2ret(wti_p);
vix  = price2ret(vix_p);
fvx  = diff(fvx_p);

log_cpi_p = log(cpi_p);
inflation_log = diff(log_cpi_p);
cpi_d = inflation_log * 100;

% Carico il Libor Usd 3m e l'OIS per calcolare il loro spread, il LOIS
libor  = ""
ois    = ""
lois_p = libor - ois;
lois   = diff(lois_p);





macro_variables = {gold, wti, vix, fvx, cpi_d, lois};
macro_variables_names = {'GOLD', 'WTI', 'VIX', 'FVX', 'CPI', 'LOIS'};
xlsdates = readmatrix('Output_Cluster_Analysis', 'Sheet', 'Prices', 'Range', 'A2:A1258');
Fulldates = datetime(xlsdates, 'ConvertFrom', 'excel');
dateformat = 'dd/MM/yyyy';




% Calcolo la volatilità delle macro tramite Garch per poter creare l'indice
% Inizializzazione di modelli e fits come celle vuote
models = cell(1, numel(macro_variables));
fits = cell(1, numel(macro_variables));
vol_forecast = cell(1, numel(macro_variables));
parameters_fitted = cell(3, numel(macro_variables))
plots = containers.Map;

% Ciclo per addestrare i modelli GARCH e ottenere le volatilità previste
for i = 1:numel(macro_variables)

    % Addestramento del modello GARCH
    models = garch('GARCHLags', 1, 'ARCHLags', 1, 'Offset', NaN);
    fit = estimate(models, macro_variables{i});
    
    % Salvataggio del modello e del fit
    model{i} = models;
    fits{i} = fit;
    
    % Estrazione dei parametri adattati
    omega = fits{i}.Constant;
    alpha = fits{i}.ARCH{1};
    beta  = fits{i}.GARCH{1};
    parameters_fitted(:, i) = {omega; alpha; beta};

    % Estrazione delle volatilità previste
    vol_forecast{i} = sqrt(infer(fit, macro_variables{i}));

end

% Creo i pesi di ciascuna variabile
weight_gold  = 1./mean(vol_forecast{1});
weight_wti   = 1./mean(vol_forecast{2});
weight_vix   = 1./mean(vol_forecast{3});
weight_fvx   = 1./mean(vol_forecast{4});
weight_cpi_d = 1./mean(vol_forecast{5});
weight_lois  = 1./mean(vol_forecast{6});

weights_norm = [weight_gold, weight_wti, weight_vix, weight_fvx, weight_cpi_d, weight_lois];
weights_norm = weights_norm ./ sum(weights_norm);

index_macro = weights_norm(:, 1) .* gold + ...
    weights_norm(:, 2) .* wti + ...
    weights_norm(:, 3) .* vix + ...
    weights_norm(:, 4) .* fvx + ...
    weights_norm(:, 5) .* cpi_d + ...
    weights_norm(:, 6) .* lois;




%%%%%%%%% PLOT %%%%%%%%%
