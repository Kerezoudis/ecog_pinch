function [slope_val, slope_idx, best_seg] = best_fit(epochs, data)

% [slope_val, slope_idx, best_seg] = best_fit(epochs, data)
%
% This function fits least squares line to epochs extracted data vector
% epochs = matrix containing the different epochs in columns
% data = original data the epochs are derived from 
%
% slope_val = vector containg values of OLS slopes in ascending order 
% slope_idx = vector containing the indices corresponding to ascending
%             values of OLS slopes
% best_seg = number correspoding to the epoch to be selected for ROL
%
% Panos Kerezoudis, CaMP lab, 2023

for i = 1:size(epochs, 2)
    f = polyfit(epochs(:, i), data(epochs(:, i)), 1);
    slope(1, i) = f(1);

    y_est = polyval(f, epochs(:, i));
    rsd(1, i) = immse(y_est', data(epochs(:, i)) );
end

[slope_val, slope_idx] = sort(slope, 'ascend');
best_seg = find(rsd == min(rsd(slope_idx(end-4:end))));

end

