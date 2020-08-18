% plot main behavioral results (between-trial): choice1 accuracy and bet1 magnitude
% appears as Fig. 1H-I in Zhang & Gläscher (2020) [10.1126/sciadv.abb4159]

%% load data 
load('data/behavioral/main_behav_data_between_trial.mat')

%% choice1 accuracy (Fig. 1H)
afs = 20;  % axis font size
lfs = 24;  % labels font size

f1 = figure;
set(f1,'color',[1 1 1])
set(f1,'position', [200 80 1000 700])

colors = cbrewer('qual', 'Set1', 10);
clr{1} = colors(2,:) ;
clr{2} = colors(1,:) ;

line_lw = 4; 
errb_lw = 3;

subplot(1,2,1) % when switch
hold on

% with condition
o1 = plot(c1_switch.mean_with, '-');
set(o1,'color',clr{1},'LineWidth',line_lw)

% against condition
o2 = plot(c1_switch.mean_against, '-');
set(o2,'color',clr{2},'LineWidth',line_lw)

% errorbar
e1 = errorbar(c1_switch.mean_with, c1_switch.sem_with, 'color', clr{1});
set(e1, 'LineStyle', 'none'); set(e1, 'LineWidth', errb_lw);
e2 = errorbar(c1_switch.mean_against, c1_switch.sem_against, 'color', clr{2});
set(e2, 'LineStyle', 'none'); set(e2, 'LineWidth', errb_lw);
hold off
offsetAxes();

text(.8, .43, {'"Switch" trials:', 'C1(t+1) \neq C2(t)'}, 'FontSize', afs);

t = legend('With group','Against group','location','northwest');
set(t, 'FontSize',afs, 'box', 'off')
set(gca,'FontSize', afs)
xlabel('Group consensus', 'FontSize', lfs)
ylabel('Choice 1 accuracy on t+1 (%)','FontSize', lfs)
set(gca,'box','off' ,'TickDir','out', ...
        'XTick',[1 2 3],'YTick',[.4:.05:.7], 'Xlim',[0.6 3], 'Ylim',[0.4 0.7], ...
        'XTickLabel',{'2:2', '3:1', '4:0'}, ...
        'YTickLabel',{'40','45','50','55','60','65','70'}, ...
        'linewidth', 3, 'FontSize', afs)

    
subplot(1,2,2) % whey stay
hold on

% with condition
o1 = plot(c1_stay.mean_with, '-');
set(o1,'color',clr{1},'LineWidth',line_lw)

% against condition
o2 = plot(c1_stay.mean_against, '-');
set(o2,'color',clr{2},'LineWidth',line_lw)

% errorbar
e1 = errorbar(c1_stay.mean_with, c1_stay.sem_with, 'color', clr{1});
set(e1, 'LineStyle', 'none'); set(e1, 'LineWidth', errb_lw);
e2 = errorbar(c1_stay.mean_against, c1_stay.sem_against, 'color', clr{2});
set(e2, 'LineStyle', 'none'); set(e2, 'LineWidth', errb_lw);
hold off
offsetAxes();

text(.8, .43, {'"Stay" trials:', 'C1(t+1) = C2(t)'}, 'FontSize', afs);
set(gca,'FontSize', afs)
xlabel('Group consensus', 'FontSize', lfs)
ylabel('Choice accuracy (%)','FontSize', lfs)
set(gca,'box','off' ,'TickDir','out', ...
        'XTick',[1 2 3],'YTick',[.4:.05:.7], 'Xlim',[0.6 3], 'Ylim',[0.4 0.7], ...
        'XTickLabel',{'2:2', '3:1', '4:0'}, ...
        'YTickLabel',{'40','45','50','55','60','65','70'}, ...
        'linewidth', 3, 'FontSize', afs)
a = get(gca, 'YAxis'); 
a.Color = [1 1 1]; % make y-axis invisible
    
%% bet1 magnitude (Fig. 1I)
f2 = figure;
set(f2,'color',[1 1 1])
set(f2,'position', [200 80 1000 700])

colors = cbrewer('qual', 'Set1', 10);
clr{1} = colors(2,:) ;
clr{2} = colors(1,:) ;

line_lw = 4; 
errb_lw = 3;

subplot(1,2,1) % when switch
hold on

% with condition
o1 = plot(b1_switch.mean_with, '-');
set(o1,'color',clr{1},'LineWidth',line_lw)

% against condition
o2 = plot(b1_switch.mean_against, '-');
set(o2,'color',clr{2},'LineWidth',line_lw)

% errorbar
e1 = errorbar(b1_switch.mean_with, b1_switch.sem_with, 'color', clr{1});
set(e1, 'LineStyle', 'none'); set(e1, 'LineWidth', errb_lw);
e2 = errorbar(b1_switch.mean_against, b1_switch.sem_against, 'color', clr{2});
set(e2, 'LineStyle', 'none'); set(e2, 'LineWidth', errb_lw);
hold off
offsetAxes();

text(.8, 1.752, {'"Switch" trials:', 'C1(t+1) \neq C2(t)'}, 'FontSize', afs);
t = legend('With group','Against group','location','northwest');
set(t, 'FontSize',afs, 'box', 'off')
xlabel('Group consensus', 'FontSize', lfs)
ylabel('Bet 1 magnitude on t+1','FontSize', lfs)
set(gca,'box','off' ,'TickDir','out', ...
        'XTick',[1 2 3],'YTick',[1.7:.1:2.2], 'Xlim',[0.6 3], 'Ylim',[1.7 2.2], ...
        'XTickLabel',{'2:2', '3:1', '4:0'}, ...
        'YTickLabel',{'1.7', '1.8','1.9','2.0','2.1','2.2'}, ...
        'linewidth', 3, 'FontSize', afs)

    
subplot(1,2,2) % whey stay
hold on

% with condition
o1 = plot(b1_stay.mean_with, '-');
set(o1,'color',clr{1},'LineWidth',line_lw)

% against condition
o2 = plot(b1_stay.mean_against, '-');
set(o2,'color',clr{2},'LineWidth',line_lw)

% errorbar
e1 = errorbar(b1_stay.mean_with, b1_stay.sem_with, 'color', clr{1});
set(e1, 'LineStyle', 'none'); set(e1, 'LineWidth', errb_lw);
e2 = errorbar(b1_stay.mean_against, b1_stay.sem_against, 'color', clr{2});
set(e2, 'LineStyle', 'none'); set(e2, 'LineWidth', errb_lw);
hold off
offsetAxes();

text(.8, 1.752, {'"Stay" trials:', 'C1(t+1) = C2(t)'}, 'FontSize', afs);
xlabel('Group consensus', 'FontSize', lfs)
ylabel('Bet 1 magnitude on t+1','FontSize', lfs)
set(gca,'box','off' ,'TickDir','out', ...
        'XTick',[1 2 3],'YTick',[1.7:.1:2.2], 'Xlim',[0.6 3], 'Ylim',[1.7 2.2], ...
        'XTickLabel',{'2:2', '3:1', '4:0'}, ...
        'YTickLabel',{'1.7', '1.8','1.9','2.0','2.1','2.2'}, ...
        'linewidth', 3, 'FontSize', afs)
a = get(gca, 'YAxis'); 
a.Color = [1 1 1]; % make y-axis invisible

% end of script
    