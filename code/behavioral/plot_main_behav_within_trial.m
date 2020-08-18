% plot main behavioral results (within-trial): choice switch and bet difference
% appears as Fig. 1D-E in Zhang & Gläscher (2020) [10.1126/sciadv.abb4159]

%% load data 
load('data/behavioral/main_behav_data_within_trial.mat')

%% choice switch probability (Fig. 1D)
afs = 20;  % axis font size
lfs = 24;  % labels font size

f1 = figure;
set(f1,'color',[1 1 1])
set(f1,'position', [200 80 500 700])

colors = cbrewer('qual', 'Set1', 10);
clr{1} = colors(2,:) ;
clr{2} = colors(1,:) ;

line_lw = 4; 
errb_lw = 3;

hold on

% mean
o1 = plot(pSwitch.mean_with, '-');
set(o1,'color',clr{1},'LineWidth',line_lw)
o2 = plot(pSwitch.mean_against, '-');
set(o2,'color',clr{2},'LineWidth',line_lw)

% errorbar
e1 = errorbar(pSwitch.mean_with, pSwitch.sem_with, 'color', clr{1});
set(e1, 'LineStyle', 'none'); set(e1, 'LineWidth', errb_lw);
e2 = errorbar(pSwitch.mean_against, pSwitch.sem_against, 'color', clr{2});
set(e2, 'LineStyle', 'none'); set(e2, 'LineWidth', errb_lw);
hold off
offsetAxes(); % requires: https://github.com/anne-urai/Tools/blob/master/plotting/offsetAxes.m

t = legend('With group','Against group','location','northwest');
set(t, 'FontSize',afs, 'box', 'off')
xlabel('Group consensus', 'FontSize', lfs)
ylabel('Choice switch probability (%)','FontSize', lfs)
set(gca,'box','off' ,'TickDir','out', ...
        'XTick',[1 2 3],'YTick',[0:.1:.5], 'Xlim',[0.6 3], 'Ylim',[0 0.55], ...
        'XTickLabel',{'2:2', '3:1', '4:0'}, ...
        'YTickLabel',{'0','10','20','30','40','50'}, ...
        'linewidth', 3, 'FontSize', afs)
    
%% bet difference (Fig. 1E)
f2 = figure;
set(f2,'color',[1 1 1])
set(f2,'position', [200 80 500 700])

colors = cbrewer('qual', 'Set1', 10);
clr{1} = colors(2,:) ;
clr{2} = colors(1,:) ;

line_lw = 4; 
errb_lw = 3;

hold on

% mean
o1 = plot(bet.mean_with, '-');
set(o1,'color',clr{1},'LineWidth',line_lw)
o2 = plot(bet.mean_against, '-');
set(o2,'color',clr{2},'LineWidth',line_lw)

% errorbar
e1 = errorbar(bet.mean_with, bet.sem_with, 'color', clr{1});
set(e1, 'LineStyle', 'none'); set(e1, 'LineWidth', errb_lw);
e2 = errorbar(bet.mean_against, bet.sem_against, 'color', clr{2});
set(e2, 'LineStyle', 'none'); set(e2, 'LineWidth', errb_lw);
hold off
offsetAxes();

t = legend('With group','Against group','location','northwest');
set(t, 'FontSize',afs, 'box', 'off')
xlabel('Group consensus', 'FontSize', lfs)
ylabel('Bet difference (Bet 2 - Bet 1)','FontSize', lfs)
set(gca,'box','off' ,'TickDir','out', ...
        'XTick',[1 2 3], 'YTick', [-0.3:0.1:0.3],  'Xlim',[0.6 3], 'Ylim',[-.3 0.3], ...
        'XTickLabel',{'2:2', '3:1', '4:0'}, ...
        'YTickLabel',{'-0.3','-0.2','-0.1','0','0.1', '0.2', '0.3'}, ...
        'linewidth', 3, 'FontSize', afs)

% end of script
