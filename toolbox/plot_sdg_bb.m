function plot_sdg_bb(subject, task, bonfen)

% This function plots the brain renderings with electrode positions
% assigned broadband power weights in R-B colormap
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

switch task
    case 'pinch'

    % Weights to be plotted
    wts = lnA_pinch_r .* (lnA_pinch_p < thresh);
    rb_dot_surf_view(brain, locs, wts, vth, vph); axis tight
    % Text
    text(tx, ty, tz, ['pinch max r^2= ' num2str(round(max(abs(wts)), 2))], 'Fontsize', 16)  
    dg_figfix

    case 'fingerflex'
    
    for q = {'thumb', 'index'}
    figure
    wts = eval(['lnA_' q{1} '_r' '.*' '(lnA_' q{1} '_p' '<0.05)']);
    rb_dot_surf_view(brain, locs, wts, vth, vph); axis tight
    text(tx, ty, tz, [[upper(q{1}(1)) q{1}(2:end)] ' lnA_r, max r^2= ' num2str(round(max(abs(wts)), 2))], 'Fontsize', 16)
    dg_figfix
    end

clearvars -except q subject subjects

end