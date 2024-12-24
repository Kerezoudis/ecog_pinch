function plot_sdg_locs(subject, task)

% This function plots the brain renderings with the subdural grids
% Electrodes are plotted as red dots

% Load brain datafile
load([task '/' subject '/' subject '_brain.mat'])

% Subject-specific views
switch subject
    case 'bp'; vth = 250; vph = 15;  
    case 'cc'; vth = 80; vph = 40; 
    case 'wm'; vth = 100; vph = 15;  
end

% Position limits
if vth < 180, tx = max(brain.vert(:, 1)); else tx = min(brain.vert(:,1)); end
ty = 0; tz = min(brain.vert(:, 3))-10;

subplot(1, 2, 1), rb_dot_surf_view(brain, [locs; [0 0 0]], [0.4+zeros(size(locs, 1), 1); 1], vth, vph)

subplot(1, 2, 2), ctmr_gauss_plot(brain, [0 0 0], 0), label_add(locs), loc_view(vth, vph)

clearvars -except q subject subjects

end