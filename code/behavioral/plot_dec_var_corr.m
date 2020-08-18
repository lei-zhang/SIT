% plot correlation matrix of value-related decision variables derived from M6b
% appears as Fig. 3A in Zhang & Gläscher (2020) [10.1126/sciadv.abb4159]

%% load data 
load('data/behavioral/dec_var_corr.mat')

%% Choice: beta(w.Nagainst) and slope of pSwitch (Fig. 2I) 
f = figure;
set(f,'color',[1 1 1],'position', [100 100 500 450])

nVar = 4; % # of variables
afs = 18;  % axis font size
lfs = 24;  % labels font size

cm = flipud(cbrewer('div', 'RdBu', 128));

imagesc(corrmat_avg, [-1 1]);
colormap(f,cm)
cb = colorbar;

axc = ones(1,3) * .7; % axis color

var_name = {'\color{black} {\itV}self','\color{black} {\itV}other', ...
    '\color{black} Reward','\color{black} RPE', ...
    '\color{black} {\itw}.Nagainst', '\color{black} SwSt'};

set(gca,'box','on', 'linewidth', 3, 'FontSize', afs, 'TickDir','in', ...
    'XTick',1:nVar, 'YTick', 1:nVar, ...
    'xcolor', axc, 'ycolor', axc, 'ticklength', [0 0.025], ...
    'XTickLabel', var_name, 'YTickLabel', var_name, ...
    'XTickLabelRotation', 45);

set(cb, 'LineWidth', 3, 'Ticks', [-1,1], 'fontsize',afs, 'color', axc, ...
    'ticklabels', {'\color{black} -1','\color{black} 1'} ,...
    'Location', 'eastoutside');

% end of script
