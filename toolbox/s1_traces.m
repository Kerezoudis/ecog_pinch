%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% COMPARE PINCH VS FLEXION IN SUBJECT 1 %%%%%%%%%%%%%%%%%%%

%% LOAD SUBJECT AND PATHS
cd('/Users/kerezoudis.panagiotis/Desktop/KJM_Library/PK_practice/data');

% Add path
addpath(genpath('/Users/kerezoudis.panagiotis/Desktop/KJM_Library/PK_practice/functions'))
addpath('/Users/kerezoudis.panagiotis/Documents/mnl_ieegBasics') 

subject = 'bp'; 
task = 'pinch';
plotOptions = 2;

%% LOAD DATA FILES

% Load pinch-related variables --------------------------------------------
lnA_pinch.dg = load(['pinch/' subject '/' subject '_pinch.mat'], 'dg').('dg'); 
lnA_pinch.stim = load(['pinch/' subject '/' subject '_pinch.mat'], 'stim').('stim'); 
lnA_pinch.data = load(['pinch/' subject '/' subject '_pc_ts.mat'], 'lnA').('lnA');
lnA_pinch.r = load(['pinch/' subject '/' subject '_lna_rhythm_stats.mat'], 'lnA_pinch_r').('lnA_pinch_r');

% Load fingerflex-related variables ---------------------------------------
lnA_flex.dg = load(['fingerflex/' subject '/' subject '_fingerflex.mat'], 'dg').('dg'); 
lnA_flex.stim = load(['pinch/' subject '/' subject '_pinch.mat'], 'stim').('stim'); 
lnA_flex.data = load(['fingerflex/' subject '/' subject '_pc_ts.mat'], 'lnA').('lnA');

%% MOST SIGNIFICANT PINCH CHANNELS 

[b, i] = sort(lnA_pinch.r, 'descend'); v = i(1:5);

%% PLOT WAVERFORMS DURING PINCHING

xlims = floor(1.0e+04 *[1 3]); xlims = xlims(1):xlims(2);

% Plot smoothed BB signal and finger position
figure(1), sgtitle("Pinch BB")
for k = 1:length(v)
    subplot(5, 1, k), plot(bb_clean(lnA_pinch.data(xlims, v(k))), 'color', 'k')
    xlim([xlims(1)-xlims(1) xlims(end)-xlims(1)])
    title("Channel " + num2str(v(k)))
    box off
end

kjm_printfig(['pinch/' subject '/figs/s1_traces_all'], 10*[3 2], plotOptions)
close all

%%
subplot(3, 1, 1), plot(zscore(lnA_pinch.dg(xlims, 1)), 'color', 'r'), axis off
xlim([xlims(1)-xlims(1) xlims(end)-xlims(1)])
title("Thumb dg trace")

subplot(3, 1, 2), plot(zscore(lnA_pinch.dg(xlims, 2)), 'color', 'b'), axis off
xlim([xlims(1)-xlims(1) xlims(end)-xlims(1)])
title("Index dg trace")

subplot(3, 1, 3), plot(beh(xlims), 'color', 'm'), axis off
xlim([xlims(1)-xlims(1) xlims(end)-xlims(1)])
title("Screen cue")

%% PLOT WAVERFORMS DURING FINGER FLEXION

xlims = floor(1.0e+04 *[3.5 7.5]); xlims = xlims(1):xlims(2);

% Plot smoothed BB signal and finger position
figure(2), sgtitle("Fingerflex BB")
for k = 1:length(v)
    subplot(5, 1, k), plot(bb_clean(lnA_flex.data(xlims, v(k))), 'color', 'k')
    xlim([xlims(1)-xlims(1) xlims(end)-xlims(1)])
    title("Channel " + num2str(v(k)))
    box off
end

kjm_printfig(['fingerflex/' subject '/figs/s1_traces_all'], 10*[3 2], plotOptions)
close all

%%
subplot(3, 1, 1), plot(zscore(lnA_flex.dg(xlims, 1)), 'color', 'r'), axis off
xlim([xlims(1)-xlims(1) xlims(end)-xlims(1)])
title("Thumb dg trace")

subplot(3, 1, 2), plot(zscore(lnA_flex.dg(xlims, 2)), 'color', 'b'), axis off
xlim([xlims(1)-xlims(1) xlims(end)-xlims(1)])
title("Index dg trace")

subplot(3, 1, 3), plot(beh(xlims), 'color', 'm'), axis off
xlim([xlims(1)-xlims(1) xlims(end)-xlims(1)])
title("Screen cue")

%% CALCULATE STA-lnA FOR EACH TASK

llim = -500; uplim = 2000;
[bb_pinch, bb_flex, win] = gen_sta_lnA(subject, llim, uplim);

%% PLOT MTA FOR THESE 5 ELECTRODES

for k = 1:length(v)
    plot(win(1):win(2),exp(pc_clean(bb_pinch.sta_avg(v(k), :) )), ...
        'Linewidth', 1), hold on
end
legend("Channel " + v, 'Location', 'northeast', 'Fontsize', 14)
xline(0)
set(gca, 'xtick', 1000 * [0 1 2])
box off, dg_figfix

%% COMPARE MTA RESPONSES USING ROL

[rol, rolStats, diffrolMedian] = sdg_gen_rol(subject, task);


%%  GENERATE MEDIAN FOR EACH ROL WITH 95% CI THROUGH BOOTSTRAP

diffrolMedian = cellfun(@(x) median(x, 'all', 'omitnan'), diffrol);
diffrolCI = cellfun(@(x) bootci(1000, @median, x(~isnan(x))), diffrol, 'UniformOutput', false);

save([task '/' subject '/' subject '_rol_diffrol.mat'], 'rol*', 'diffrol*')





















