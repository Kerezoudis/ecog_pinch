function [lnA_blocks, rhythm_blocks] = calc_blocks(subject, task)

% [lnA_blocks, rhythm_blocks] = calc_blocks(subject, task)
% 
% This function calculates mean block power of log(BB) and rhythms.
%
% Panos Kerezoudis, CaMP lab, 2023

load([task '/' subject '/' subject '_' task], 'data', 'dg', 'srate'); data = car(data);
load([task '/' subject '/' subject '_pc_ts.mat']);
load([task '/' subject '/' subject '_fband.mat']);
load([task '/' subject '/' subject '_trials.mat']);


num_chans = size(data, 2);

% Z-score broadband 
for k = 1:num_chans, lnA(:, k) = zscore(lnA(:, k)); end

fprintf(1, 'Calculating power and modulation for all trials ...\n');

for band = 1:size(fband, 1)
    for cur_trial = 1:max(trialnr)

            % Index counter for display
        if (mod(cur_trial+1, 20) == 0), fprintf(1, '%03d ', cur_trial+1); 
            if (mod(cur_trial+1, 100) == 0), fprintf(1, '* /%d\r', max(trialnr)); 
            end
        end

            % Isolate relevant data 
    tt = find(trialnr == cur_trial);
    lnA_blocks(cur_trial, :) = mean(lnA(tt, :), 1);
    
            % Rhythm amplitude - square if want power instead of amplitude
    rhythm_blocks{band}(cur_trial, :) = mean(abs(fband{band}(tt, :)), 1); 
    end
end 

% Subtract mean of BB in resting state (ie between movements)
tr_rest = find(tr_sc == 0 | tr_sc == 10 | tr_sc ==20);

for chan = 1:size(lnA_blocks, 2)
    lnA_blocks(:, chan) = lnA_blocks(:, chan) - ...
    mean(lnA_blocks(tr_rest, chan)); 
end

save([task '/' subject '/' subject '_pwr_blocks'], 'rhythm_blocks', 'lnA_blocks')

clearvars -except q subject

end

