function [lnA_pinch, lnA_flex, win] = gen_sta_lnA(subject, llim, uplim)

% [lnA_pinch, lnA_flex] = gen_sta_lnA(subject, llim, uplim)
%
% This function calculates the per-trial and stimulus triggered BB average for 
%   pinch, thumb flexion and index flexion.
% 
% INPUT:
%   subject = letter code for patient
%   llim = lower limit for window (wrt movement onset at t=0ms)
%   uplim = upper limit for window
%
% OUTPUT:
%   lnA_pinch = struct containg the following variables:
%       (1) data = original log(BB) timeseries
%       (2) trialnr = timeseries vector with trial numbers
%       (3) tr_sc = sequence of trials 
%       (4) move_tr = movement trials
%       (5) r = BB-R^2 values for movement vs rest per electrode
%       (6) p = p-value for BB-R^2 values for movement vs rest per electrode
%       (7) sta = BB signal pre-/post- stimulus (chan x time x trial)
%       (8) sta_avg = trial-average pre-/post- stim BB signal per electrode
%
%
%   lnA_flex = struct containg the following variables (thumb_ or index_):
%       (1) data = original log(BB) timeseries
%       (2) trialnr = timeseries vector with trial numbers
%       (3) tr_sc = sequence of trials 
%       (4) move_tr = movement trials
%       (5) _r = BB-R^2 values for movement vs rest per electrode
%       (6) _p = p-value for BB-R^2 values for movement vs rest per electrode
%       (7) _sta = BB signal pre-/post- stimulus (chan x time x trial)
%       (8) _sta_avg = trial-average pre-/post- stim BB signal per electrode
%
%   win = window defined by llim and uplim
%
% Panos Kerezoudis, CaMP lab, 2023

%% %%%%%%%%%%%%% Load pinch-related variables %%%%%%%%%%%%%%%
lnA_pinch.data = load(['pinch/' subject '/' subject '_pc_ts.mat'], 'lnA').('lnA');
lnA_pinch.trialnr = load(['pinch/' subject '/' subject '_trials'], 'trialnr').('trialnr');
lnA_pinch.move_tr = load(['pinch/' subject '/' subject '_trials'], 'pinch_move').('pinch_move');
lnA_pinch.tr_sc = load(['pinch/' subject '/' subject '_trials'], 'tr_sc').('tr_sc');
lnA_pinch.r = load(['pinch/' subject '/' subject '_lna_rhythm_stats.mat'], 'lnA_pinch_r').('lnA_pinch_r');
lnA_pinch.p = load(['pinch/' subject '/' subject '_lna_rhythm_stats.mat'], 'lnA_pinch_p').('lnA_pinch_p');

%% %%%%%%%%%%%%% Load fingerflex-related variables %%%%%%%%%%%%%%%
lnA_flex.data = load(['fingerflex/' subject '/' subject '_pc_ts.mat'], 'lnA').('lnA');
lnA_flex.trialnr = load(['fingerflex/' subject '/' subject '_trials'], 'trialnr').('trialnr');
lnA_flex.tr_sc = load(['fingerflex/' subject '/' subject '_trials'], 'tr_sc').('tr_sc');
lnA_flex.thumb_r = load(['fingerflex/' subject '/' subject '_lna_rhythm_stats.mat'], 'lnA_thumb_r').('lnA_thumb_r');
lnA_flex.index_r = load(['fingerflex/' subject '/' subject '_lna_rhythm_stats.mat'], 'lnA_index_r').('lnA_index_r');
lnA_flex.thumb_p = load(['fingerflex/' subject '/' subject '_lna_rhythm_stats.mat'], 'lnA_thumb_p').('lnA_thumb_p');
lnA_flex.index_p = load(['fingerflex/' subject '/' subject '_lna_rhythm_stats.mat'], 'lnA_index_p').('lnA_index_p');

%% %%%%%%%%%%%%% ST-BB for pinch %%%%%%%%%%%%%
% Create pre- / post- stim window
win = [llim uplim];

% Matrix of stim starting points
pts = [zeros(size(lnA_pinch.move_tr, 2), 2) ones(size(lnA_pinch.move_tr, 2), 1)];

for i = 1:size(lnA_pinch.move_tr, 2)
    block = find(lnA_pinch.trialnr == lnA_pinch.move_tr(i));
    pts(i, 1) = block(1); pts(i, 2) = block(end); 
end

kpts = pts(find(pts(:, 3) == 1), 1);
kpts = [kpts(1) kpts(find(diff(kpts) > uplim) + 1)'];

% 3D matrix of ST-BB signal
% Channels x Time x Trials
lnA_pinch.sta = zeros(size(lnA_pinch.data, 2), length(win(1):win(2)), length(kpts));

for i = 1:size(lnA_pinch.data, 2)
    for j = 1:size(kpts, 2)
        temp = lnA_pinch.data(:, i);
        lnA_pinch.sta(i, :, j) = temp(kpts(j) + [win(1):win(2)]);
    end
end
% Trial-average ST-BB signal
lnA_pinch.sta_avg = mean(lnA_pinch.sta, 3);

%% %%%%%%%%%%%%% ST-BB for fingerflex %%%%%%%%%%%%%

% Matrix of stim starting points
lnA_flex.finger_move = find(lnA_flex.tr_sc == 1 | lnA_flex.tr_sc == 2);
pts = zeros(size(lnA_flex.finger_move, 2), 3);

for i = 1:size(lnA_flex.finger_move, 2)
    block = find(lnA_flex.trialnr == lnA_flex.finger_move(i));
    pts(i, 1) = block(1); pts(i, 2) = block(end); 
    if lnA_flex.tr_sc(lnA_flex.finger_move(i)) == 1,  pts(i, 3) = 1;
    elseif lnA_flex.tr_sc(lnA_flex.finger_move(i)) == 2,  pts(i, 3) = 2;
    end
end

% %%%%%%%%%%%%%% Thumb %%%%%%%%%%%%%
% 3D matrix of ST-BB signal % Channels x Time x Trials
kpts = pts(find(pts(:, 3) == 1), 1);
kpts = [kpts(1) kpts(find(diff(kpts) > uplim) + 1)'];

% 3D array with averages around 
lnA_flex.thumb_sta = zeros(size(lnA_flex.data, 2), length(win(1):win(2)), length(kpts));

for i = 1:size(lnA_flex.data, 2)
    for j = 1:size(kpts, 2)
        temp = lnA_flex.data(:, i);
        lnA_flex.thumb_sta(i, :, j) = temp(kpts(j) + [win(1):win(2)]);
    end
end
lnA_flex.thumb_sta_avg = mean(lnA_flex.thumb_sta, 3);

clear kpts

% %%%%%%%%%%%%%%% Index %%%%%%%%%%%%%
% 3D matrix of ST-BB signal % Channels x Time x Trials
kpts = pts(find(pts(:, 3) == 2), 1);
kpts = [kpts(1) kpts(find(diff(kpts) > 3000) + 1)'];

% 3D array with averages around 
lnA_flex.index_sta = zeros(size(lnA_flex.data, 2), length(win(1):win(2)), length(kpts));

for i = 1:size(lnA_flex.data, 2)
    for j = 1:size(kpts, 2)
        temp = lnA_flex.data(:, i);
        lnA_flex.index_sta(i, :, j) = temp(kpts(j) + [win(1):win(2)]);
    end
end
lnA_flex.index_sta_avg = mean(lnA_flex.index_sta, 3);

clearvars -except lnA_flex lnA_pinch win subject llim uplim


end

