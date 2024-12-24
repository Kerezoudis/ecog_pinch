function gen_tf_plot(subject, task, chan2plot)

% This function generates Time-Frequency plots using Morlet wavelet convolution 
%
% Panos Kerezoudis, CaMP lab, 2023
% with help of KJM, 2020

% Load data files
load([task '/' subject '/' subject '_' task], 'data', 'dg', 'srate'); 
load([task '/' subject '/' subject '_lna_rhythm_stats.mat']);
load([task '/' subject '/' subject '_beh.mat']);

% Channel to plot per subject
switch subject
    case 'bp'; chan = 13; xlims = floor(1.0e+04 *[1 4]);  
    case 'cc'; chan = 14; xlims = floor(10^4 *[1.5 6]);
    case 'wm'; chan = 34; xlims = floor(1.0e+04 *[5 8]);  
end

% Check channel to plot
if ~exist('chan2plot', 'var'), chan2plot = chan; end

% Parameters for wavelet convolution 
frange = 1:200;
time = (1:length(data(xlims, chan2plot)))'/srate; xlims = xlims(1):xlims(2);
V = data(xlims, :);

[S, f] = getWavKjm(data(xlims, chan2plot), srate, frange, beh(xlims));
S = log(S);

% Smooth across time
z_S = zeros(size(S, 1), size(S, 2));
for k = 1:size(S, 1)
    z_S(k, :) = zscore(S(k, :)); % z-score
    z_S(k, :) = smooth(z_S(k, :), 1200);
end
z_S_copy = z_S;

% Average across neighboring frequencies
for k = 1:size(S, 2)
    for j = 6:(size(S, 1)-5)
        window = z_S_copy(j-5:j+5,k);
        z_S(j, k) = mean(window);
    end
end

% Plot dynamic spectrum
figure(1), imagesc(time, f, z_S(:, :));
axis xy
load('dg_colormap')
colorbar
colormap(cm)
caxis([-1 1])
xlabel('Time (s)', 'FontSize', 12)
ylabel('Frequency (Hz)', 'FontSize', 12)
box off
dg_figfix

% Compare with broadband activation 
d2 = abs(diff(dg(:, 2))); d2(d2<0) = 0; 
figure(2), hold on, plot(d2(xlims), 'color', 'k', 'linewidth', .75), axis off

clearvars -except q subject subjects

end


