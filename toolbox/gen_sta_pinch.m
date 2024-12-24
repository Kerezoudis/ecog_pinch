function [sta] = gen_sta_pinch(subject, chan, llim, uplim)

% [sta] = gen_sta(subject, chan, llim, uplim)
%
% This function calculates the stimulus triggered average of 
% different timeseries/waveforms. 
% 
% Inputs:
% subject = letter code for patient
% chan = channel to analyze
% llim = lower limit for window (wrt movement onset at t=0ms)
% uplim = lower limit for window
%
% Panos Kerezoudis, CaMP lab, 2023

% Load datafiles
load(['pinch/' subject '/' subject '_pinch.mat'], 'data', 'dg', 'srate'); data = car(data);
load(['pinch/' subject '/' subject '_pc_ts.mat']);
load(['pinch/' subject '/' subject '_trials']);
load(['pinch/' subject '/' subject '_lna_rhythm_stats.mat'], 'lnA_pinch_r', 'lnA_pinch_p');
load(['pinch/' subject '/' subject '_fband.mat']);

% Relevant parameters
sf = 0.0298; % Convert from amp units to microvolts
win = [llim uplim]; % Window for STAs
beta = fband{3};

% Matrix with start and end movement times
pinch_move = find(tr_sc == 1);
pts = [zeros(size(pinch_move, 2), 2) ones(size(pinch_move, 2), 1)];

for i = 1:size(pinch_move, 2)
    block = find(trialnr == pinch_move(i));
    pts(i, 1) = block(1); pts(i, 2) = block(end); 
end

% Stimulus-triggered average across different timeseries
kpts = pts(find(pts(:, 3) == 1), 1);
kpts = [kpts(1) kpts(find(diff(kpts) > uplim) + 1)'];% 

% Generate STA struct
sta = struct;
sta.lnA = dg_sta(pc_clean(zscore(lnA(:, chan))), kpts, win);
sta.data = dg_sta(sf * data(:, chan), kpts, win);
sta.thumb = dg_sta(dg(:, 1), kpts, win);
sta.index = dg_sta(dg(:, 2), kpts, win);
sta.tf = dg_tf_sta_pwr(sf * data(:, chan), kpts, win);

m0 = mean(abs(beta)); s0 = std(abs(beta));
sta.beta = dg_sta(abs(beta(:, chan)) .^ .5, kpts, win);
sta.beta = ((sta.beta .^ 2) - m0) / s0; clear m0 s0 % put in z-score units

save(['pinch/' subject '/' subject '_sta'], 'sta', 'llim', 'uplim')

end
