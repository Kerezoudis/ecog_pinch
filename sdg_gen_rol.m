function [rol, rolStats, diffrolMedian] = sdg_gen_rol(subject, task)

% [rol] = sdg_gen_rol(data)
% 
% This function calculates the response onset latency of selected channels
% following a stimulus, i.e. the latency to activation. 
% 
% Input:
%   data = channels x time x trials data matrix that serves as the basis of 
%          ROL estimation. 
% 
%   Reference: Foster, Brett L., et al. "Intrinsic and task-dependent 
%   coupling of neuronal population activity in human parietal cortex." 
%   Neuron 86.2 (2015): 578-590.
% 
% Panos Kerezoudis, CaMP lab, 2024.

% Load related datafiles --------------------------------------------------
lnA_pinch = load(['pinch/' subject '/' subject '_pc_ts.mat'], 'lnA').('lnA');
[movTimes, ~] = extract_times(subject, task);

% 3D matrix of BB-MTA signal: Channels x Time x Trials --------------------
llim = -500; uplim = 3000; win = [llim uplim];
kpts = movTimes(movTimes(:, 3) > 0, :);

lnA_mta = zeros(size(lnA_pinch, 2), length(win(1):win(2)), length(kpts));
for i = 1:size(lnA_pinch, 2)
    for j = 1:size(kpts, 1)
        temp = lnA_pinch(:, i);
        lnA_mta(i, :, j) = temp(kpts(j) + [win(1):win(2)]);
    end
end

% Transform the BB response -----------------------------------------------
for k = 1:size(lnA_mta, 1)
    for q = 1:size(lnA_mta, 3)
        data(k, :, q) = exp(pc_clean(lnA_mta(k, :, q) ));
    end
end

%% RESPONSE ONSET LATENCY ANALYSIS GROUPED BY MOVEMENT TYPE %%%%%%%%%%%%%%%

% Pre-allocate matrix
rol = zeros(size(data, 1), size(data, 3));

% Generate matrix
for chan = 1:size(data, 1)
    disp(['Calculating ROL for channel ' num2str(chan) ' / ' num2str(size(data, 1))])
    for trial = 1:size(data, 3)
    block = squeeze(data(chan, :, trial));

    % Baseline power = mean power in (-500 to 0ms) window -----------
    bsl_pwr = mean(block(1:abs(win(1))));

    % Define threshold: mean + 2*SD ---------------------------------
    thresh = bsl_pwr + 2 * std(block(1:abs(win(1)) ));

    % Find time periods, at least 100ms in duration, where  
    % log(BB) is at least +2SD above mean baseline power ------------
    srate = 1200; duration = 100 * (srate/1000);
    segments = supra_thresh(block, thresh, duration);

    % Return empty ROL for the trial if no segments are identified --
    if isempty(segments), rol(chan, trial) = NaN;
    else

    % Take the time period with the highest mean HFB power ----------
    [max_bb, max_seg] = max(cellfun(@mean, segments(:, 2) ));

    % Within that time period, take its first time point and 
    % define new smaller epoch that extends from -200ms to 100ms ----
    win2 = [-200 100];
    sup_thresh_pt = segments{max_seg, 1}(1);
    temp = (sup_thresh_pt + [win2(1) : win2(2)] );

    % Return the sup_thresh_pt as ROL if it is located within 
    % 200ms of the analysis window. ---------------------------------
    if temp(1) < 0, rol(chan, trial) = sup_thresh_pt - abs(win(1));
    else

    % This time period needs to be segmented into 21 segments, 
    % 100ms long, with 90% overlap ----------------------------------
    [time_win, epochs] = epoch_window(temp, srate, 0.1, 0.9);

    % OLS for each of the segments to fit a line --------------------
    [slope_val, slope_idx, best_seg] = best_fit(epochs, block);

    % First time point of that segment defines the ROL 
    % Subtract time point from pre-cue interval and cue-EMG interval ------
    rol(chan, trial) = epochs(1, best_seg) - abs(win(1)) - kpts(trial, 3);
    end
    end
    end
end


%% CALCULATE VARIOUS ROL STATS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Median with 95% CI for each ROL
rolStats = cell(size(rol, 1), 1);
for q = 1:size(rolStats, 1)
    temp = rol(q, :); % temporary variables for easier coding
    ci = bootci(1000, @median, temp(~isnan(temp)));
    rolStats{q}(1) = ci(1); % 25% percentile
    rolStats{q}(2) = median(temp, 'omitnan'); % Median
    rolStats{q}(3) = ci(2); % 75% percentile
end

% Vector of differences in ROL between channels
diffrol = cell(size(rol, 1), size(rol, 1));
for k = 1:size(rol, 1)
    for j = 1:size(rol, 1)
        diffrol{k, j} = rol(k, :) - rol(j, :);
    end
end

% Median difference in ROL
diffrolMedian = cellfun(@(x) median(x, 'all', 'omitnan'), diffrol);

save([task '/' subject '/' subject '_rol.mat'], 'rol*', 'diffrol*')

clearvars -except subjects subject rol* diffrol*


%% PLOTTING FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot segments that meet threshold criteria and their mean BB power ------
% figure(1), plot_segments(segments, block, thresh, win)

% Plot the sliding segments of the epoched window -------------------------
% figure(2), plot_slid_epochs(block, time_win, epochs)

% Plot the sliding segments along with their best line fit ----------------
% figure(3), plot_epoch_fit(block, epochs, time_win)


end




