% plot choice accuracy and bet magnitude, within trial 
% appears as Fig. 1H-I in Zhang & Gläscher (2020) [10.1126/sciadv.abb4159]

%% load data 
load('data/behavioral/acc_bet_within_trial.mat')

%% choice accuracy, C1 -> C2 (Fig. 1F)
afs = 20;  % axis font size
lfs = 24;  % labels font size

f1 = figure;
set(f1,'color',[1 1 1]);
set(f1,'position',[50 50 300 700]);

clr = [ 71 143 194;
        55  95 151;
       134 172  65;
        72 107   0 ] / 255;

bw = 0.5;

hold on 
b1 = bar(1, nanmean(acc(:,1)), bw, 'facecolor', clr(1,:), 'edgecolor', clr(1,:));
e1 = errorbar(1, nanmean(acc(:,1)), nansem(acc(:,1)), 'color', 'k' ,'LineWidth', 2.5, 'lineStyle', 'none');

b2 = bar(2, nanmean(acc(:,2)), bw, 'facecolor', clr(2,:), 'edgecolor', clr(2,:));
e2 = errorbar(2, nanmean(acc(:,2)), nansem(acc(:,2)), 'color', 'k' ,'LineWidth', 2.5, 'lineStyle', 'none');

hold off

t = legend([b1 b2], 'Choice 1','Choice 2','location','southoutside');
set(t, 'FontSize',afs, 'box','off')
ylabel('Choice accuracy (%)','FontSize', lfs)
set(gca,'FontSize', afs, 'box','off' ,'TickDir','out', ...
        'XTick','', 'YTick', [.5:.05:.6],  'Xlim',[0.4 2.6], 'Ylim',[.49 .6], ...
        'YTickLabel',{'50','55','60'}, ...
        'linewidth', 3)


%% bet magnitude, B1 -> B2 (Fig. 1F)
f2 = figure;
set(f2,'color',[1 1 1]);
set(f2,'position',[50 50 300 700]);

bw = 0.5;

hold on 
b1 = bar(1, nanmean(bet(:,1)), bw, 'facecolor', clr(3,:), 'edgecolor', clr(3,:));
e1 = errorbar(1, nanmean(bet(:,1)), nansem(bet(:,1)), 'color', 'k' ,'LineWidth', 2.5, 'lineStyle', 'none');

b2 = bar(2, nanmean(bet(:,2)), bw, 'facecolor', clr(4,:), 'edgecolor', clr(4,:));
e2 = errorbar(2, nanmean(bet(:,2)), nansem(bet(:,2)), 'color', 'k' ,'LineWidth', 2.5, 'lineStyle', 'none');

hold off

t = legend([b1 b2], 'Bet 1','Bet 2','location','southoutside');
set(t, 'FontSize',afs, 'box','off')
ylabel('Bet magnitude','FontSize', lfs)

set(gca,'FontSize', afs, 'box','off' ,'TickDir','out', ...
        'XTick','', 'YTick', [1.9:.1:2.2],  'Xlim',[0.4 2.6], 'Ylim',[1.89 2.2], ...
        'YTickLabel',{'1.9','2.0','2.1','2.2'}, ...
        'linewidth', 3)
    