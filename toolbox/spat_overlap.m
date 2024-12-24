function  [wts, wt_lbls] = spat_overlap(subject, bonfen)

% [wts, wt_lbls] = spat_overlap(subject, bonfen)
%
% This function calculates the spatial overlap among channels
% using different metrics.
%
% Panos Kerezoudis, CaMP lab, 2023

load(['pinch/' subject '/' subject '_lna_rhythm_stats.mat'], 'lnA_pinch_r', 'lnA_pinch_p');
load(['fingerflex/' subject '/' subject '_lna_rhythm_stats.mat'], 'lnA_thumb_r', 'lnA_thumb_p', ...
    'lnA_index_r', 'lnA_index_p');

% Bonferroni-correction
if bonfen == 'y', thresh = 0.05/size(lnA_pinch_r, 2);
elseif bonfen == 'n', thresh = 0.05;
end

% Significant thumb, index channels with exclusion of negative BB
lnA_thumb_r2 = lnA_thumb_r .* (lnA_thumb_p < thresh); lnA_thumb_r2(lnA_thumb_r2 < 0) = 0; 
lnA_index_r2 = lnA_index_r .* (lnA_index_p < thresh); lnA_index_r2(lnA_index_r2 < 0) = 0; 

wts = zeros(size(lnA_pinch_r, 2), 6);

wts(:, 1) = lnA_pinch_r .* (lnA_pinch_p < thresh);
wts(:, 2) = lnA_thumb_r .* (lnA_thumb_p < thresh);
wts(:, 3) = lnA_index_r .* (lnA_index_p < thresh);
wts(:, 4) = sqrt(abs((lnA_thumb_r .* (lnA_thumb_p < thresh)) .* ...
    (lnA_index_r .* (lnA_index_p < thresh))));
wts(:, 5) = max((lnA_thumb_r .* (lnA_thumb_p < thresh)) , ...
    (lnA_index_r .* (lnA_index_p < thresh)));
wts(:, 6) = abs(1 - sqrt(abs( sqrt(1-lnA_thumb_r2) .* sqrt(1-lnA_index_r2) )));

wt_lbls = {'Pinch', 'Thumb', 'Index', 'Geom-Mean', 'Max', 'Mod-Geom-Mean'};

save(['pinch/' subject '/' subject '_overlap_stats'], 'wts', 'wt_lbls');

clearvars -except q subject subjects

end