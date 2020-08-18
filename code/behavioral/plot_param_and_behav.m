% plot parameters of interest and the associated behavior (individual level)
% appears as Fig. 2I-J in Zhang & Gläscher (2020) [10.1126/sciadv.abb4159]

%% load data 
load('data/behavioral/param_and_behav.mat')

%% Choice: beta(w.Nagainst) and slope of pSwitch (Fig. 2I) 
f1 = figure;
set(f1,'color',[1 1 1],'position', [300 50 500 800])

afs = 24;  % axis font size
lfs = 34;  % labels font size
clr = [65 100 161] / 255;

s = scatter(pSwitch.beta, pSwitch.slope, 'MarkerEdgeColor', 'none','MarkerFaceColor', clr,'sizedata',150);
l = lsline;
set(l, 'color', 'k', 'linewidth', 3)
hold off

xlim([-1.1, 5]); ylim([-.2 .8])
xlabel('\beta({\itw}.N_{against})', 'FontSize', lfs)
ylabel('Slope of choice switch probability', 'FontSize', lfs)
set(gca, 'fontsize', afs, 'box','off' ,'TickDir','out', ...
         'xTick', [-1:1:5], 'yTick', -.2:.2:.8, ...
         'linewidth', 3)
alpha(.7)

%% Bet: beta(w.Nwith) and slope of betDiff
f2 = figure;
set(f2,'color',[1 1 1],'position', [300 50 500 800])

clr = [82 117 10]/255;
x0 = -1:.1:3;

hold on 
s = scatter(betDiff.beta, betDiff.slope, 'MarkerEdgeColor', 'none','MarkerFaceColor', clr,'sizedata',150);
f = polyfit(betDiff.beta, betDiff.slope,1);
p = plot(x0, f(1)*x0 + f(2));
%l = lsline; also works, but visially not very nice
set(p, 'color', 'k', 'linewidth', 3)
hold off

xlim([-1.1, 3]); ylim([-.4 1])
xlabel('\beta({\itw}.N_{with})', 'FontSize', lfs)
ylabel('Slope of bet difference', 'FontSize', lfs)
set(gca, 'fontsize', afs, 'box','off' ,'TickDir','out', ...
         'xTick', [-1:1:3], 'yTick', -.4:.2:1, ...
         'linewidth', 3)
alpha(.7)

% end of script
