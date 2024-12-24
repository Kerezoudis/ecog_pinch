function plot_spat_overlap(subject)

% This function plots the topology maps of the different metrics 
%
% Panos Kerezoudis, CaMP lab, 2023

% Load datafile
load(['pinch/' subject '/' subject '_overlap_stats'], 'wts');
load(['pinch/' subject '/' subject '_brain'])

% Subject-specific views
switch subject
    case 'bp'; vth = 250; vph = 15;  
    case 'cc'; vth = 80; vph = 40; 
    case 'wm'; vth = 100; vph = 15;  
end

% Position limits
if vth < 180, tx = max(brain.vert(:, 1)); else tx = min(brain.vert(:,1)); end
ty = 0; tz = min(brain.vert(:, 3))-10;

% Plot titles
q = {'Pinch', 'Thumb', 'Index', 'Geom Mean(thmb, idx)', 'Max(thmb, idx)', 'Modified Geom Mean'};

for i = 1:size(wts, 2)
    subplot(2, 3, i)
    figure(1)
    rb_dot_surf_view(brain, locs, wts(:, i), vth, vph); axis tight
    dg_figfix
    title(q{i}, 'FontSize', 16)
end

end