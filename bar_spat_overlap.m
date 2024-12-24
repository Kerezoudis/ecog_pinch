function bar_spat_overlap(subject)

% This function plots a histogram with the spatial overlap 
% among electrodes using different metrics. 
%
% Panos Kerezoudis, CaMP lab, 2023

% Load datafile
load(['pinch/' subject '/' subject '_overlap_stats'], 'wts', 'wt_lbls');

% Initialize matrices
OL_pct = zeros(5, 1); OLM = zeros(5, 1); 
p_val = zeros(5, 1); rs_kurt = zeros(5, 1);

for i = 2:size(wts, 2)
    [OL_pct(i), OLM(i), p_val(i), rs_kurt(i)] = spat_reshuffle(wts(:, 1), wts(:, i)); 
end
OL_pct(1) = [];

% Bar graph of percent overlap
x_labels = categorical({'Pinch-Thumb flex', 'Pinch-Index flex', ...
    'Pinch-Geom mean', 'Pinch-Max val', 'Pinch-Mod Geom mean'});
x_labels = reordercats(x_labels, {'Pinch-Thumb flex', 'Pinch-Index flex', ...
    'Pinch-Geom mean', 'Pinch-Max val', 'Pinch-Mod Geom mean'});
bar(x_labels, abs(OL_pct), 0.4, 'FaceColor', "#F984E4")
text(1:length(OL_pct), OL_pct, num2str(round(OL_pct, 2)), 'vert', 'bottom', 'horiz', 'center'); 
ylabel('Overlap ', 'FontSize', 16)
ylim([0 1])
box off
dg_figfix

end