% plot BOLD time series of NAcc for the RPE signal (PE = R - V)
% appears as Fig. 3D-F & Fig. 4D in Zhang & Gläscher (2020) [10.1126/sciadv.abb4159]

%% [Step 1] prepare data

upsrate = 10;  % up sampling rate
TR      = 2.51;
subID   = [1:9 11:20 22:41];
ts_dir  = fullfile('data', 'fMRI', 'time_series');

%% [Step 2] specify VOI and model variables; note: select ONE of the four options below

% option 1 --------------------
pm = [1 2];
pm_clr = [1 2];
orth = 1;
roi = 'vmPFC';  
dur = 10;

% option 2 --------------------
pm = [1 2];
pm_clr = [1 2];
orth = 1;
roi = 'ACC';  
dur = 10;

% option 3 --------------------
pm = [3 1];
pm_clr = [3 1];
orth = 0;
roi = 'lVS';  
dur = 30;

% option 4 --------------------
pm = [5 4];
pm_clr = [3 1];
orth = 0;
roi = 'lPut';  
dur = 30;

%% [Step 3] initis the currect path, load onsets & model variables, load VOI (timeseries data)

subdir = {};
for j = subID
    curr_sub = sprintf('%s/sub%02d/%s', ts_dir, j);    
    subdir(end + 1) = {curr_sub};
end

load(fullfile('data', 'fMRI', 'time_series', 'derivatives', 'onset.mat'));
load(fullfile('data', 'fMRI', 'time_series', 'derivatives', 'model_var.mat'));

onsName = 'cue';

pmNames = {'vself', 'vother', 'reward', 'social_expected', 'social_actual'};
pmLabs = {'{\itV}self','{\itV}other' ,'Reward', 'Expected consensus', 'Actual consensus'};

pmodName = pmNames(pm);
pmodLabs = pmLabs(pm);

switch upper(roi)
    case 'VMPFC'
        voiName  = 'VOI_vmPFC_1.mat';
    case 'ACC'
        voiName  = 'VOI_ACC_1.mat';
    case 'LVS'
        voiName  = 'VOI_lVS_1.mat';
    case 'LPUT'
        voiName  = 'VOI_lPut_1.mat';
end

%% [Step 4] compute effects on BOLD (i.e., beta predictors)

betas = [];
for j = 1:length(subID)
    
    clear Y xY ons pmod
    
    load(fullfile(subdir{j},voiName));
    ts = Y;
    
    ons = onset.sub(j).(onsName);
    for p = 1:length(pmodName)
        pmod(:,p) = model_var.sub(j).(pmodName{p});
    end
    
    ons = ons(1:end-1);
    pmod = pmod(1:end-1,:);    
    
    %%% MAIN ts correlation function: ts_corr_basic.m
    betas(j,:,:) = ts_corr_basic(ts,ons,pmod, 'dur', dur, 'orth', orth);
end

if size(betas,1) ~= length(subID)
    error('Wrong dimension! Check the index! ')
end

%% [Step 5] plot; note: select ONE of the three options below, depends on your choice on [Step 2]
afs = 24;  % axis font size
lfs = 28;  % labels font size
fill_col = cbrewer('qual', 'Set1', 10);
        
lin_col = 0.8*fill_col;
lin_col_ref = [.5 .5 .5]; 

ref_lw = 4; % reference Lines
ac_lw = 5;  % signal lines

%% Option 1 - Plot vmPFC/ACC (Fig. 3D-E)

ll_bttm = -0.08;
ll_top = 0.2;

x = [0:size(betas,2)-1] * TR/upsrate; % scale back in second space

figure;clf;axes;hold on;
set(gcf, 'color',[1 1 1], 'position', [10 300 1000 700])

line([0 round(x(end))],[0 0], 'linestyle', '-', 'color', lin_col_ref, 'linewidth',ref_lw)

line([0 0], [ll_bttm ll_top], 'linestyle', '-', 'color', lin_col_ref, 'linewidth',ref_lw)
text(0.4,ll_top + 0.03,'Choice1', 'HorizontalAlignment', 'Center', 'FontSize', afs)

clear M S pl
if length(pmodName) ~= length(pm)
  error(' # of PMODs must be the same as # of Col! ')
end

% plot the line
for p =1:length(pmodName)
    M(p,:) = mean(squeeze(betas(:,:,p)));
    S(p,:) = nansem(squeeze(betas(:,:,p)));
    
    pl(p) = plot(x,M(p,:),'color',lin_col(pm_clr(p),:),'linewidth',ac_lw);
end

% now the error regions
for p = 1:length(pmodName)
    L = M(p,:) - S(p,:);
    U = M(p,:) + S(p,:);
    Xcoords = [x x(end:-1:1)];
    Ycoords = [L U(end:-1:1)];
    
    pa(p) = patch(Xcoords,Ycoords,fill_col(pm_clr(p),:));
    set(pa(p),'linestyle','none','linewidth',4,'facealpha',0.5);
end

lg = legend(pl, pmodLabs , 'location', 'northeast', 'orientation','vertical', 'position', [0.62 0.83 0.44 0.1493]);
set(lg, 'box', 'off', 'FontSize', lfs)
xlabel('Time (s)', 'FontSize', lfs)
ylabel('Effect on BOLD (a.u.)', 'FontSize', lfs)

set(gca, 'FontSize', afs, 'TickDir', 'out', ...
         'XTick', 0:5:10, 'YTick', -0.1:0.1:0.3,...
         'xlim', [-1 ceil(x(end))], 'ylim', [-.1 .3], ...
         'TickLength', [0.025 0.01], 'linewidth', 4)
     
%% Option 2 - Plot VS (Fig. 3F)
ll_bttm = -0.08;
ll_top = 0.3;

x = [0:size(betas,2)-1] * TR/upsrate; 

figure;clf;axes;hold on;
set(gcf, 'color',[1 1 1], 'position', [10 3 1000 700])

line([0 round(x(end))],[0 0], 'linestyle', '-', 'color', lin_col_ref, 'linewidth',ref_lw)
line([21.71 21.71], [ll_bttm ll_top], 'linestyle', '-', 'color', lin_col_ref, 'linewidth',ref_lw)
text(22.11,ll_top + 0.03,'Outcome', 'HorizontalAlignment', 'Center', 'FontSize', afs)

clear M S pl
if length(pmodName) ~= length(pm)
  error(' # of PMODs must be the same as # of Col! ')
end

cut_pt = 21.5; % cue of reward outcome

for p =1:length(pmodName)    
    M(p,:) = mean(squeeze(betas(:,:,p)));
    S(p,:) = nansem(squeeze(betas(:,:,p)));
    
    if p == 1        
        idx = find(x>=cut_pt);
    else
        idx = 1:length(x);        
    end   
    
    pl(p) = plot(x(idx),M(p,idx),'color',lin_col(pm_clr(p),:),'linewidth',ac_lw);
end

% now the error regions
for p = 1:length(pmodName)       
    if p == 1        
        idx = find(x>=cut_pt);
    else
        idx = 1:length(x);        
    end   
    
    L = M(p,idx) - S(p,idx);
    U = M(p,idx) + S(p,idx);
    
    x_tmp = x(idx);
    
    Xcoords = [x_tmp x_tmp(end:-1:1)];
    Ycoords = [L U(end:-1:1)];
    
    pa(p) = patch(Xcoords,Ycoords,fill_col(pm_clr(p),:));
    set(pa(p),'linestyle','none','linewidth',4,'facealpha',0.5);
end

offsetAxes();
lg = legend(pl, pmodLabs , 'location', 'north', 'orientation','vertical',  'position', [0.52 0.83 0.44 0.1493]);
set(lg, 'box', 'off', 'FontSize', lfs)
xlabel('Time (s)', 'FontSize', lfs)
ylabel({'Effect on BOLD (a. u.)'}, 'FontSize', lfs)
set(gca, 'FontSize', afs, 'TickDir', 'out', ...
         'XTick', 20:5:30, 'YTick', -0.1:0.1:0.4,...         
         'xlim', [20 ceil(x(end))], 'ylim', [-.12 .4], ...
         'TickLength', [0.01 0.01], ...
         'linewidth', 3)     
     
%% Option 3 - Plot lPut (Fig. 4D)
ll_bttm = -0.08;
ll_top = 0.12;

x = [0:size(betas,2)-1] * TR/upsrate;

figure;clf;axes;hold on;
set(gcf, 'color',[1 1 1], 'position', [10 300 1000 700])

line([4 round(x(end))],[0 0], 'linestyle', '-', 'color', lin_col_ref, 'linewidth',ref_lw)
line([5.33 5.33], [ll_bttm ll_top], 'linestyle', '-', 'color', lin_col_ref, 'linewidth',ref_lw)
text(5.33+.4,ll_top + 0.03,'Social Info', 'HorizontalAlignment', 'Center', 'FontSize', afs)

clear M S pl
if length(pmodName) ~= length(pm)
  error(' # of PMODs must be the same as # of Col! ')
end

cut_pt = 5.2; % cue of social outcome

for p =1:length(pmodName)
    
    M(p,:) = mean(squeeze(betas(:,:,p)));
    S(p,:) = nansem(squeeze(betas(:,:,p)));
    
    if p == 1        
        idx = find(x>=cut_pt);
    else
        idx = 1:length(x);        
    end   
    
    pl(p) = plot(x(idx),M(p,idx),'color',lin_col(pm_clr(p),:),'linewidth',ac_lw);
end

% now the error regions
for p = 1:length(pmodName)
       
    if p == 1        
        idx = find(x>=cut_pt);
    else
        idx = 1:length(x);        
    end   
    
    L = M(p,idx) - S(p,idx);
    U = M(p,idx) + S(p,idx);
    
    x_tmp = x(idx);
    
    Xcoords = [x_tmp x_tmp(end:-1:1)];
    Ycoords = [L U(end:-1:1)];
    
    pa(p) = patch(Xcoords,Ycoords,fill_col(pm_clr(p),:));
    set(pa(p),'linestyle','none','linewidth',4,'facealpha',0.5);
end

lg = legend(pl, pmodLabs , 'location', 'northeast', 'orientation','vertical', 'position', [0.52 0.83 0.44 0.1493]);
set(lg, 'box', 'off', 'FontSize', lfs)
xlabel('Time (s)', 'FontSize', lfs)
ylabel('Effect on BOLD (a.u.)', 'FontSize', lfs)
set(gca, 'FontSize', afs, 'TickDir', 'out', ...
         'XTick', [5.33 8 12], 'YTick', -0.1:0.1:0.2,...
         'xticklabel', {'5.3','8','12'}, ...
         'xlim', [4.33 12], 'ylim', [-.1 .2], ...
         'TickLength', [0.025 0.01], ...
         'linewidth', 4)

% end of script
