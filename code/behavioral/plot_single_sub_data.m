% plot trial-by-trial data against model prediction for an example participant
% appears as Fig. 1B in Zhang & Gläscher (2020) [10.1126/sciadv.abb4159]

%% load data 
load('data/behavioral/single_sub_data.mat')

%% plot

figure
set(gcf,'color',[1 1 1],'position', [100 100 1500 300])
afs = 18;  % axis font size
lfs = 22;  % labels font size
mks = 10;  % marker size

% http://colorbrewer2.org/; % light blue, dark blue, purple, red, green
clr = {[205,225,240]/255, [0.2157 0.4941 0.7216], [118,42,131]/255, [215,48,39]/255, [102,189,99]/255};

hold on

p1 = plot(subdata.T, subdata.prob1,  '-', 'color', clr{1}, 'LineWidth', 10);
p2 = plot(subdata.T, subdata.C1_avg, '-', 'color', clr{2}, 'LineWidth', 5);

for t = 1:subdata.T(end)
    if subdata.otcm(t) == 1
        l1= line([t t], [1.03 1.23], 'color', clr{5}, 'LineWidth', 8);
    else
        l2= line([t t], [1.03 1.13], 'color', clr{4}, 'LineWidth', 8);
    end
end

% plot switch
p5 = plot(subdata.T(subdata.swst == 1), subdata.swst(subdata.swst == 1) * -.132, ...
    'o','MarkerFaceColor', clr{3},'MarkerEdgeColor', clr{3},'MarkerSize', mks);

% plot reversal
rev_ind = find(subdata.rev == 1);
for r = 1:length(rev_ind)
    line([rev_ind(r), rev_ind(r)], [0 1], 'color',[.5 .5 .5],'lineStyle','--', 'LineWidth', 3)
end

hold off
offsetAxes(); % requires: https://github.com/anne-urai/Tools/blob/master/plotting/offsetAxes.m

t = legend([p2 p1], 'Data','Model','location','southwest');
set(t, 'FontSize',afs, 'box','off');

xlabel('Trial', 'FontSize', lfs)
ylabel('{\itP}(choice)','FontSize', lfs)
set(gca,'FontSize', afs, 'box','off' ,'TickDir','out', ...
    'XTick',[1 25 50 75 100],'YTick',[0 .5 1], 'Xlim',[0 subdata.T(end)], 'Ylim',[-0.2 1.2], ...
    'YTickLabel',{'0','0.5','1'}, 'ticklength', [.008 0.025], ...
    'linewidth', 3)
