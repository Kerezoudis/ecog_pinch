function [movTimes, meanReact] = extract_times(subject, task)

% Load related datafiles --------------------------------------------------
load([task '/' subject '/' subject '_beh'])
load([task '/' subject '/' subject '_pinch'], 'stim')
load([task '/' subject '/' subject '_trials'])

% Behavioral vector -------------------------------------------------------
[behKpts, behPts] = extract_start(tr_sc, trialnr);

% Stimulus vector ---------------------------------------------------------
[stimnr, stim_sc, stimTrials] = mk_tr_vec(stim);
[stimKpts, stimPts] = extract_start(stim_sc, stimnr);

% Matrix with reaction times per movement trial ---------------------------
movTimes = zeros(size(behPts, 1), 3);
movTimes(:, 1:2) = [stimPts(:, 1) behPts(:, 1)];
movTimes(:, 3) = behPts(:, 1) - stimPts(:, 1); 

meanReact = mean(movTimes(:, 3));

% save output -------------------------------------------------------------
save([task '/' subject '/' subject '_movTimes.mat'], 'movTimes', 'meanReact')


end










