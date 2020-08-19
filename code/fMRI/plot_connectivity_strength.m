% plot commectivity strength (PPI and PhiPI)
% appears as Fig. 4C,G,I in Zhang & Gläscher (2020) [10.1126/sciadv.abb4159]

%% load data 
load('data/fMRI/connectivity_strength.mat')

%% PPI: rTPJ ~ SwSt --> lPut (Fig. 4C) 
afs = 24;  % axis font size
lfs = 28;  % labels font size
colors = cbrewer('qual', 'Set1', 10);

f1 = figure;
set(f1,'color',[1 1 1])
set(f1,'position', [200 80 400 700])

violinPlot(ppi(:,1), 'histOri', 'left', 'widthDiv', [2 1], 'showMM', 0, ...
    'color',  mat2cell(colors(1, : ), 1), 'xValues', 1.95, 'distwidth', .7); 
violinPlot(ppi(:,2), 'histOri', 'right', 'widthDiv', [2 2], 'showMM', 0, ...
    'color',  mat2cell(colors(2, : ), 1), 'xValues', 2.05, 'distwidth', .7);

ylabel('Coupling (rTPJ ~ lPut)','FontSize', lfs)
xlabel('Choice 2','FontSize', lfs)

set(gca,'FontSize', afs, 'box','off' ,'TickDir','out', ...
        'XTick',[1.75 2.25], 'xTickLabel', {'Switch','Stay'}, ...
        'YTick',[-1.5:0.5:1.5], 'Xlim',[1.4 2.6], 'Ylim',[-1.55 1.5], ...
        'linewidth', 4)
alpha(.9)

%% PPI: rTPJ ~ dlPFC --> vmPFC (Fig. 4G)
f2 = figure;
set(f2,'color',[1 1 1])
set(f2,'position', [200 80 400 700])

violinPlot(phipi_vmpfc(:,1), 'histOri', 'left', 'widthDiv', [2 1], 'showMM', 0, ...
    'color',  mat2cell(colors(1, : ), 1), 'xValues', 1.95, 'distwidth', .7);
 
violinPlot(phipi_vmpfc(:,2), 'histOri', 'right', 'widthDiv', [2 2], 'showMM', 0, ...
    'color',  mat2cell(colors(2, : ), 1), 'xValues', 2.05, 'distwidth', .7);

ylabel('Coupling (rTPJ ~ vmPFC)','FontSize', lfs)
xlabel('dlPFC','FontSize', lfs)

set(gca,'FontSize', afs, 'box','off' ,'TickDir','out', ...
        'XTick',[1.75 2.25], 'xTickLabel', {'High','Low'}, ...
        'YTick',[-.5:0.5:1.5], 'Xlim',[1.4 2.6], 'Ylim',[-.55 1.5], ...
        'linewidth', 4)
alpha(.9)

%% PPI: rTPJ ~ dlPFC --> ACC (Fig. 4I)
f3 = figure;
set(f3,'color',[1 1 1])
set(f3,'position', [200 80 400 700])

violinPlot(phipi_acc(:,1), 'histOri', 'left', 'widthDiv', [2 1], 'showMM', 0, ...
    'color',  mat2cell(colors(1, : ), 1), 'xValues', 1.95, 'distwidth', .7);
 
violinPlot(phipi_acc(:,2), 'histOri', 'right', 'widthDiv', [2 2], 'showMM', 0, ...
    'color',  mat2cell(colors(2, : ), 1), 'xValues', 2.05, 'distwidth', .7);

ylabel('Coupling (rTPJ ~ ACC)','FontSize', lfs)
xlabel('dlPFC','FontSize', lfs)

set(gca,'FontSize', afs, 'box','off' ,'TickDir','out', ...
        'XTick',[1.75 2.25], 'xTickLabel', {'High','Low'}, ...
        'YTick',[-.5:0.5:1.5], 'Xlim',[1.4 2.6], 'Ylim',[-.55 1.5], ...
        'linewidth', 4)
alpha(.9)

% end of script
