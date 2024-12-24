ffunction gen_waveforms(subject, task)

% This function generates example waveform timeseries related to the channel with the
% highest BB R2 value. 
%
% Panos Kerezoudis, CaMP lab, 2023

% Load relevant data files
load([task '/' subject '/' subject '_' task], 'data', 'dg', 'srate', 'stim'); 
load([task '/' subject '/' subject '_pc_ts.mat'])
load([task '/' subject '/' subject '_lna_rhythm_stats.mat'])
load([task '/' subject '/' subject '_fband.mat'])

% Set xlims
switch subject
    case 'bp'; xlims = floor(1.0e+04 *[1 4]);  
    case 'cc'; xlims = floor(10^4 *[1.5 6]);
    case 'wm'; xlims = floor(1.0e+04 *[5 8]);  
end

% Extract BB signal from channel with highest RSA
[tmp, d1chan] = max(lnA_pinch_r); 
d1dt = exp(pc_clean(lnA(:, d1chan))); 
xlims = xlims(1):xlims(2);

% Plot smoothed BB signal and finger position
figure(1)
subplot(6, 1, 1), plot(zscore(data(xlims, d1chan)), 'color', 'k'), axis off
xlim([xlims(1)-xlims(1) xlims(end)-xlims(1)])

subplot(6, 1, 2), plot(zscore(dg(xlims, 1)), 'color', 'g'), axis off
xlim([xlims(1)-xlims(1) xlims(end)-xlims(1)])

subplot(6, 1, 3), plot(zscore(dg(xlims, 2)), 'color', 'b'), axis off
xlim([xlims(1)-xlims(1) xlims(end)-xlims(1)])

subplot(6, 1, 4), plot(zscore(d1dt(xlims)), 'color', [.85 .4 .6 ]), axis off
xlim([xlims(1)-xlims(1) xlims(end)-xlims(1)])

subplot(6, 1, 5), plot(beh(xlims)), axis off
xlim([xlims(1)-xlims(1) xlims(end)-xlims(1)])

subplot(6, 1, 6), plot(zscore(real(fband{3}(xlims, d1chan))), 'color', [0.9290 0.6940 0.1250])
xlim([xlims(1)-xlims(1) xlims(end)-xlims(1)])

h = gca; set(h, 'Color', 'None', 'box', 'off'), h.YAxis.Visible = 'off'; 
xlim([xlims(1)-xlims(1) xlims(end)-xlims(1)])
set(gca, 'XTick', 0:1*10^4:4*10^4)
set(gca, 'XTickLabel', 0:10:40)
xlabel("Time (s)")

clearvars -except q subject subjects

end