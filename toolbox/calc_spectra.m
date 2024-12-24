function [ps,nps, mps, f] = calc_spectra(subject, task)

% ['ps','nps', 'mps', 'f'] = calc_spectra(data, task)
%
% This function calculates static power spectra.
% Channel x Freq x Trial
% Also calculates normalized (whitened) static power spectra.
%
% Panos Kerezoudis, CaMP lab, 2023


% Load relevant datasets %%%%
load([task '/' subject '/' subject '_' task], 'data', 'dg', 'srate'); data = car(data);
load([task '/' subject '/' subject '_trials.mat'])

% Exclude harmonics of 60 Hz
f = 1:300; no60 = [];
for k = 1:ceil(max(f/60))
    no60 = [no60 (60*k-3):(60*k+3)]; % 3 Hz up or down
end
no60 = [no60 247:253]; f(find(f>200)) = [];
f = setdiff(f, no60); % dispose of 60Hz stuff
if subject == 'cc', f(find(f<5))=[]; end

% Create PSD related variables
num_chan = size(data, 2); % N of channels
bsize = srate; % window size for spectral calculation
win_fxn = hann(bsize); % create Hann window
noverlap = bsize/2; % overlap in windowing

% Run pwelch function
for chan = 1:num_chan  
    disp(['Getting power spectrum for channel ' num2str(chan) ' / ' num2str(size(data, 2))])
    [mps(chan, :), f] = pwelch(data(:, chan), win_fxn, noverlap, f, srate); % mean power spectrum across whole experiment
    
        for curr_trial = 1:max(trials) % calculate spectra for each trial
        curr_data = data(find(trialnr == curr_trial), chan);
        
        if length(curr_data) < length(win_fxn), % zero pad to window size if needed
            curr_data = [curr_data; zeros(length(win_fxn)-length(curr_data), 1)];
        end        
        
        ps(chan, :, curr_trial) = pwelch(curr_data, win_fxn, noverlap, f, srate); % single trial power spectra
        nps(chan, :, curr_trial) = ps(chan, :, curr_trial) ./ mps(chan, :); % normalized single trial power spectra
        end
end

save([task '/' subject '/' subject '_psd'], 'ps','nps', 'mps', 'f')

clearvars -except q subject

end