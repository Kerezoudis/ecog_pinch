function [tr_sc, trialnr, trials, pinch_move, pinch_rest] = calc_trial(subject, task)

% [tr_sc, trialnr, trials, pinch_move, pinch_rest] = calc_trial(subject, task)
%
% This function creates the time series vector of trials
% also the trial sequence vector 
%
% Panos Kerezoudis, CaMP lab, 2023

load([task '/' subject '/' subject '_beh'])

disp(['Generating ' task ' move/rest conditions for subject ' subject])

trialnr = 0*beh; tr_sc = 0; 
trtemp = 1; trialnr(1) = trtemp;
for n = 2:length(beh)
    if beh(n) ~= beh(n-1),
        trtemp = trtemp + 1; tr_sc = [tr_sc beh(n)];
    end
    trialnr(n) = trtemp;
end
trials = unique(trialnr);

% Reject short rest periods
lengthtrial = [];
for k = 1:length(trials)
    lengthtrial = [lengthtrial; length(find(trialnr == k))];
end

% Nullify if any epochs are < 1 second
shortrest = ((lengthtrial < 1000)' & tr_sc == 0);
tr_sc(find(shortrest)) = -1;

% Movement/rest blocks depending on task
switch task
    case 'pinch'
        
    pinch_move = find(tr_sc == 1); 
    tr_sc(find(and(tr_sc == 0, [0 tr_sc(1:(end-1))] == 1))) = 10; 
    pinch_rest = find(tr_sc == 10); 
    
    save([task '/' subject '/' subject '_trials'], 'tr*', 'pinch*')

    case 'fingerflex'

    thumb_move = find(tr_sc == 1); index_move = find(tr_sc == 2);
    tr_sc(find(and(tr_sc == 0, [0 tr_sc(1:(end-1))] == 1))) = 10; 
    tr_sc(find(and(tr_sc == 0, [0 tr_sc(1:(end-1))] == 2))) = 20; 
    thumb_rest = find(tr_sc == 10); index_rest = find(tr_sc == 20);

    save([task '/' subject '/' subject '_trials'], 'tr*', 'thumb*', 'index*')

clearvars -except subjects subject task

end

end