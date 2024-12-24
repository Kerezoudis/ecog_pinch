function [lnA] = bb_ts(subject, task)

% [lnA] = bb_ts(subject, task)
% 
% This function outputs the log(BB) timeseries
% Based on wavelet convolution. 
%
% Panos Kerezoudis, CaMP lab, 2023

load([task '/' subject '/' subject '_' task], 'data', 'dg', 'srate'); data = car(data);
load([task '/' subject '/' subject '_psd.mat'])
load([task '/' subject '/' subject '_decoupled.mat'])

f0 = f;
lnA = 0*data; % broadband data

for chan = 1:size(data, 2)
    disp([' channel ' num2str(chan) ' / ' num2str(size(data, 2))])
    dt = data(:, chan); 
    mm = squeeze(pc_vecs(:, chan, :))';  % mixing matrix
    pcvec1 = mm(:, 1);  
    lnA(:, chan) = dg_tf_pwr_rm(dt, pcvec1, f0);
end

save([task '/' subject '/' subject '_pc_ts'], 'lnA')

clearvars -except q subject

end