function [lnA_pinch_p, lnA_pinch_r, rhy_pinch_p, rhy_pinch_r] = blocks_stats(subject, task)

% [lnA_pinch_p, lnA_pinch_r, rhy_pinch_p, rhy_pinch_r] = blocks_stats(subject, task)
% 
% This function calculates R^2 and p-values for mvmt vs rest.
% BB and canonical rhythm blocks
%
% Panos Kerezoudis, CaMP lab, 2023

load([task '/' subject '/' subject '_pwr_blocks'], 'rhythm_blocks', 'lnA_blocks');
load([task '/' subject '/' subject '_trials.mat']);
load([task '/' subject '/' subject '_fband.mat']);


% Broadband stats
for band = 1:size(fband, 1)
    for chan = 1:size(lnA_blocks, 2)

switch task
    case 'pinch'


    % Signed - r2
    lnA_pinch_r(chan) = rsa(lnA_blocks(pinch_move, chan), lnA_blocks(pinch_rest, chan));

    rhy_pinch_r{band}(chan) = rsa(rhythm_blocks{band}(pinch_move, chan), ...
                rhythm_blocks{band}(pinch_rest, chan));

    % pvalue - Now using t-test 
    [tmp, lnA_pinch_p(chan)] = ttest2(lnA_blocks(pinch_move, chan), lnA_blocks(pinch_rest, chan));
    
    [tmp, rhy_pinch_p{band}(chan)] = ttest2(...
                rhythm_blocks{band}(pinch_move, chan),...
                rhythm_blocks{band}(pinch_rest, chan));


    case 'fingerflex'

    % Signed - r2
    lnA_thumb_r(chan) = rsa(lnA_blocks(thumb_move, chan), ...
                lnA_blocks(thumb_rest, chan));
    lnA_index_r(chan) = rsa(lnA_blocks(index_move, chan), ...
                lnA_blocks(index_rest, chan));

    rhy_thumb_r{band}(chan) = rsa(rhythm_blocks{band}(thumb_move, chan), ...
                rhythm_blocks{band}(thumb_rest, chan));
    rhy_index_r{band}(chan) = rsa(rhythm_blocks{band}(index_move, chan), ...
                rhythm_blocks{band}(index_rest, chan));

    % pvalue - Now using t-test 
    [tmp, lnA_thumb_p(chan)] = ttest2(lnA_blocks(thumb_move, chan), lnA_blocks(thumb_rest, chan));
    [tmp, lnA_index_p(chan)] = ttest2(lnA_blocks(index_move, chan), lnA_blocks(index_rest, chan));
    
    [tmp, rhy_thumb_p{band}(chan)] = ttest2(...
                rhythm_blocks{band}(thumb_move, chan),...
                rhythm_blocks{band}(thumb_rest, chan));
    [tmp, rhy_index_p{band}(chan)] = ttest2(...
                rhythm_blocks{band}(index_move, chan),...
                rhythm_blocks{band}(index_rest, chan));

end

    end
end

save([task '/' subject '/' subject '_lna_rhythm_stats'], 'lnA_*', 'rhy_*')

clearvars -except q subject

end