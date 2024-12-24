function gen_psd(subject, task, chan2plot)

% This function generates static power spectrum for a channel
% Average of movement vs rest
%
% If no channel argument is passed, it will plot 
% the channel with highest BB value
%
% Panos Kerezoudis, CaMP lab, 2023

% Load related data files
load([task '/' subject '/' subject '_psd.mat'])
load([task '/' subject '/' subject '_trials.mat']), 

% Highest BB channel
load([task '/' subject '/' subject '_lna_rhythm_stats.mat'])
[tmp, chan] = max(lnA_pinch_r); 

% Check channel to plot
if ~exist('chan2plot', 'var'), chan2plot = chan; end

% Generate figure
fid = figure; fid.Position = [100 100 1000 800];
hold on
plot(f, log(mean(ps(chan2plot, :, pinch_move), 3)), 'Color', 'r', 'LineWidth', 2), hold on
plot(f, log(mean(ps(chan2plot, :, pinch_rest), 3)), 'Color', 'k', 'LineWidth', 2)
xlim([0 200])
title("Channel " + num2str(chan2plot))
ylabel('Log average power/Hz', 'FontSize', 16)
xlabel('Frequency (Hz)', 'FontSize', 16)
legend('Movement', 'Rest', 'FontSize', 16, 'Position', [0.7 0.7 0.1 0.1])
box off
dg_figfix

clearvars -except q subject subjects

end