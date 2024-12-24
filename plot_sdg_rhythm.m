function plot_sdg_rhythm(subject, task, bonfen)

% This function plots the brain renderings with electrode positions
% assigned canonical rhythm weights in R-B colormap
%
% Panos Kerezoudis, CaMP lab, 2023


% Load related related files
load([task '/' subject '/' subject '_brain.mat']), 
load([task '/' subject '/' subject '_lna_rhythm_stats.mat'])

% Subject-specific views
switch subject
    case 'bp'; vth = 250; vph = 15;  
    case 'cc'; vth = 80; vph = 40; 
    case 'wm'; vth = 100; vph = 15;  
end

% Position limits
if vth < 180, tx = max(brain.vert(:, 1)); else tx = min(brain.vert(:,1)); end
ty = 0; tz = min(brain.vert(:, 3))-10;

% Bonferroni-correction
if bonfen == 'y', thresh = 0.05/size(lnA_blocks, 2);
elseif bonfen == 'n', thresh = 0.05;
end

% Define bands
bands = [[4 8] ; [8 12] ; [12 20]];
k = {'theta', 'alpha', 'beta'};

% Weights to be plotted and text
for band = 1:size(k, 2)
    subplot(1, 3, band)
    wts = rhy_pinch_r{band} .* (rhy_pinch_p{band} < thresh);
    rb_dot_surf_view(brain, locs, wts, vth, vph); axis tight
    text(tx, ty, tz, [k{band} ', max r^2= ' num2str(round(max(abs(wts)), 2))], 'FontSize', 16)
    dg_figfix
end

clearvars -except q subject subjects

end