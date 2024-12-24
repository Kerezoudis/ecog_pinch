%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% BB TIMESERIES ANALYSIS %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The goal of this analysis is to compare BB activation in most significant
% channels across pinching, thumb flexion and index flexion. 
%
% Panos Kerezoudis, CaMP lab, 2023

%% ADD WORKING DIRECTORY AND RELEVANT PATHS

cd('/Users/kerezoudis.panagiotis/Desktop/KJM_Library/PK_practice/data');

% Add path
addpath(genpath('/Users/kerezoudis.panagiotis/Desktop/KJM_Library/PK_practice/functions'))
addpath('/Users/kerezoudis.panagiotis/Documents/mnl_ieegBasics') % MNL IEEG BASICS

%% DEFINE SUBJECTS

subjects = ['bp'; 'cc'; 'wm'];

%% SUBJECT SELECTION 

% subject = 'bp'; 
% subject = 'cc';
subject = 'wm';

%% CALCULATE STA-lnA FOR EACH TASK

llim = -500; uplim = 3000;
[lnA_pinch, lnA_flex, win] = gen_sta_lnA(subject, llim, uplim);

%% SELECT SPECIFIC ELECTRODES TO FURTHER LOOK INTO

% We will subselect only those channels that are significant 
% during (1) pinching & thumb flex OR (2) pinching & index flex

% Find mutually significant channels
% Bonferroni correction - yes or no
bonfen = 'n';
if bonfen == 'y', thresh = .05 / size(lnA_pinch.data, 2);
else thresh = .05; end

v = find(lnA_pinch.p < .05 & lnA_flex.thumb_p < thresh | ...
    lnA_pinch.p < .05 & lnA_flex.index_p < thresh);

%% PLOT FOR THE CHANNELS ABOVE, THE FOLLOWING TRACES:
%   (1) pinch
%   (2) thumb flexion
%   (3) index flexion
%   (4) thumb + index flexion

mov_avg = 50;

figure(1), 
switch subject
    case 'bp', tiledlayout(2, 3),
    case 'cc', tiledlayout(2, 3),
    case 'wm', tiledlayout(2, 3),
end
for k = 1:length(v)
    nexttile()
    sgtitle("Log(BB) STAs for significant channels")
    plot([win(1):win(2)], exp(movmean(lnA_pinch.sta_avg(v(k), :), mov_avg)), 'k'), hold on
    plot([win(1):win(2)], exp(movmean(lnA_flex.thumb_sta_avg(v(k), :), mov_avg)), 'b'), 
    plot([win(1):win(2)], exp(movmean(lnA_flex.index_sta_avg(v(k), :), mov_avg)), 'r')
    plot([win(1):win(2)], exp(movmean(lnA_flex.thumb_sta_avg(v(k), :), mov_avg)) + ...
        exp(movmean(lnA_flex.index_sta_avg(v(k), :), mov_avg)), 'g--')
    set(gca, 'xtick', 1000*[ 0 1 2 3])
    legend("Pinch", "Thumb flex", "Index flex", "Thumb+Index flex")
    title("Channel " + num2str(v(k)))
    box off, dg_figfix
end


%% COMPARE LOG BB WITH NON-PARAMETRIC TESTS

% Algorithm by Maris, Oostenveld, 2007 paper
% Cluster-based correction of Permutation tests on Event-related fields
% Decided to skip two-sample t-test with Bonferroni correction

% 5 chans x 3 t-tests = 15 comparisons 
bbcompare = []; 

% Set parameters
alphaThresh = 0.05; alphaFA = 0.05; nperm = 1000;

for k = 1:length(v)

    % Define vectors to be compared 
    d1 = movmean(lnA_pinch.sta_avg(v(k), :), mov_avg)';
    d2 = movmean(lnA_flex.thumb_sta_avg(v(k), :), mov_avg)';
    d3 = movmean(lnA_flex.index_sta_avg(v(k), :), mov_avg)';
    d4 = d2 + d3;

    % Pinch vs Thumb flexion 
    [~, bbcompare.PvT(k), ~] = ieeg_clusterTest(d1, d2, alphaThresh, alphaFA, nperm);
    
    % Pinch vs Index Flexion
    [~, bbcompare.PvI(k), ~] = ieeg_clusterTest(d1, d3, alphaThresh, alphaFA, nperm);

    % Pinch vs Thumb+Index Flexion
    [~, bbcompare.PvTI(k), ~] = ieeg_clusterTest(d1, d4, alphaThresh, alphaFA, nperm);

end


%% VISUALIZE DIFFERENT WAYS OF COMPARING STAs ACROSS CONDITIONS

mov_avg = 50;
k = 4;

subplot(1, 3, 1), 
plot([win(1):win(2)], movmean(lnA_pinch.sta_avg(v(k), :), mov_avg), 'k'), hold on
plot([win(1):win(2)], movmean(lnA_flex.thumb_sta_avg(v(k), :), mov_avg), 'b'), 
plot([win(1):win(2)], movmean(lnA_flex.index_sta_avg(v(k), :), mov_avg), 'r')
    plot([win(1):win(2)], movmean(lnA_flex.thumb_sta_avg(v(k), :), mov_avg) + ...
        movmean(lnA_flex.index_sta_avg(v(k), :), mov_avg), 'g')
set(gca, 'xtick', 1000*[ 0 1 2 3])
legend("Pinch", "Thumb flex", "Index flex", "Thumb+Index flex", 'FontSize', 16)
title("Channel " + num2str(v(k)) + " - Log(BB) power", 'FontSize', 16)
box off

subplot(1, 3, 2), 
plot([win(1):win(2)], exp(lnA_pinch.sta_avg(v(k), :)), 'k'), hold on
plot([win(1):win(2)], exp(lnA_flex.thumb_sta_avg(v(k), :)), 'b'), 
plot([win(1):win(2)], exp(lnA_flex.index_sta_avg(v(k), :)), 'r')
    plot([win(1):win(2)], exp(lnA_flex.thumb_sta_avg(v(k), :)) + ...
        exp(lnA_flex.index_sta_avg(v(k), :)), 'g')
set(gca, 'xtick', 1000*[ 0 1 2 3])
legend("Pinch", "Thumb flex", "Index flex", "Thumb+Index flex", 'FontSize', 16)
title("Channel " + num2str(v(k)) + " - exp log(BB) power", 'FontSize', 16)
box off

subplot(1, 3, 3), 
plot([win(1):win(2)], movmean(bb_clean(lnA_pinch.sta_avg(v(k), :)), mov_avg), 'k'), hold on
plot([win(1):win(2)], movmean(bb_clean(lnA_flex.thumb_sta_avg(v(k), :)), mov_avg), 'b'), 
plot([win(1):win(2)], movmean(bb_clean(lnA_flex.index_sta_avg(v(k), :)), mov_avg), 'r')
    plot([win(1):win(2)], movmean(bb_clean(lnA_flex.thumb_sta_avg(v(k), :)), mov_avg) + ...
        movmean(bb_clean(lnA_flex.index_sta_avg(v(k), :)), mov_avg), 'g')
set(gca, 'xtick', 1000*[ 0 1 2 3])
legend("Pinch", "Thumb flex", "Index flex", "Thumb+Index flex", 'FontSize', 16)
title("Channel " + num2str(v(k)) + " - BB clean power", 'FontSize', 16)
box off

%% PSEUDO-LINEAR SUMMATION

chan = 28;

d1 = lnA_pinch.sta_avg(chan, :); d1 = d1/norm(d1);
d2 = lnA_flex.thumb_sta_avg(chan, :);
d3 = lnA_flex.index_sta_avg(chan, :);
d4 = d2/norm(d2) + d3/norm(d3);

plot(d1, 'k'), hold on
plot(d4, 'r')








