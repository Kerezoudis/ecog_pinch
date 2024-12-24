function [bb] = bb_clean(data, winlength)

% [bb] = bb_clean(data, winlength)
% 
% This function smoothes (by time-convolution) with a Gaussian window
% of length 'winlength', z-scores, and exponentiates the log(BB) power.
%
% Panos Kerezoudis, CaMP lab, 2023 (modified kjm function)

% Transpose data if not organized in time x chan format
if size(data, 1) < size(data, 2)
    data_new = data';
else data_new = data;
end

% Set fixed winlength if argument is absent
if ~exist('winlength', 'var'), winlength = 250; end

% BB cleaning
for k = 1:size(data_new, 2)

    data_smooth(:, k) = conv(data_new(:, k), gausswin(winlength), 'same');
    
    data_z(:, k) = zscore(data_smooth(:, k));

    bb(:, k) = exp(data_z(:, k));
end

% Transpose output to original dimensions
if size(data, 1) < size(data, 2)
    bb = bb';

clear k data_smooth data_z

end