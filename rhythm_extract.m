function [fband] = rhythm_extract(subject, bands, task)

% [fband] = rhythm_extract(subject, bands, task)
%
% This function extracts canonical rhythms.
% Filter: 3rd order Butterworth filter
% Hilbert transformed data
%
% Panos Kerezoudis, CaMP lab, 2023

load([task '/' subject '/' subject '_' task], 'data', 'dg', 'srate'); data = car(data);

num_chans = size(data, 2);
num_bins = 24; % N of phase bins
rh_window = [-249: 250]; % window for calculation of rhythm influence about each event

fband = cell(3, 1);

for k = 1:size(bands, 1)
    band = bands(k, :);
    disp(['getting rhythm from band ' num2str(bands(k, 1)) '-' num2str(bands(k, 2)) ' Hz'])
    [bf_b bf_a] = getButterFilter(band, srate); % band pass
    for chan = 1:size(data, 2) % loop to save
        fband{k}(:, chan) = hilbert(filtfilt(bf_b, bf_a, data(:, chan))); % band pass
    end
end

save([task '/' subject '/' subject '_fband'], 'fband')

clearvars -except q subject

end