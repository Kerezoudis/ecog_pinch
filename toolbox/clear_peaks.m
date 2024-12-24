function [peaks_new] = clear_peaks(peaks, troughs, n_peaks)

% [peaks_new] = clear_peaks(troughs, peaks, n_peaks)
% 
% This function will delete peak values in-between local minima.
% (still needs to be refined)
% Aimed for breathing belt data, but can be used for any timeseries. 
%
% Inputs are the following: 
%   peaks = vector (row or column) of peak indices
%   troughs = vector (row or column) of trough indices
%   n_peaks = number of peaks to retain in inter-trough interval
% 
% Panos Kerezoudis, CaMP lamb, 2023

% Define intervals between consecutive troughs (save in cell)
for i = 1:length(troughs)-1
    tt{i} = troughs(i) : troughs(i+1);
end

% Create matrix (peaks (rows) x inter-trough intervals (cols) )
for k = 1:length(tt)
    for jj = 2:length(peaks)-1
        temp(jj, k) = ismember(peaks(jj), tt{k});
    end
end

% Find columns with more than pre-specified number of peaks
v = find(sum(temp, 1) > n_peaks);

% Delete the extra local maxima 
for i = 1:length(v)
    t{i} = find(temp(: , v(i)) == 1);
    temp(t{i}(2:end-n_peaks+1), v(i)) = 0;
end

% Save the entries of retained peaks
% Need to add first and last maxima back into the vector
peak_idx = 1;
for k = 1:size(temp, 2)
    t = find(temp(:, k) == 1)';
    peak_idx = [peak_idx t];
end
peak_idx = [peak_idx length(peaks)];

% Find the indices of retained peaks from input peak vector
peaks_new = peaks(peak_idx(1:end));


end