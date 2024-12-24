function [pc_weights, pc_vecs, pc_vals, f] = decoupling(subject, task)

% [pc_weights, pc_vecs, pc_vals, f] = decoupling(subject, task)
% 
% This function performs PCA on the power spectrum for decoupling.
%
% Panos Kerezoudis, CaMP lab, 2023
% Original method described by KJM, J Neurosci, 2007

% Load spectral data matrix
load([task '/' subject '/' subject '_' task], 'data', 'dg', 'srate'); data = car(data);
load([task '/' subject '/' subject '_psd.mat'])

nchan = size(data, 2); % N of channels

% Pre-allocate cells
ncomps = length(f);

pc_weights = zeros(ncomps, nchan, size(nps, 3)); % projection weights
pc_vecs = zeros(ncomps, nchan, length(f)); % eigenvectors
pc_vals = zeros(ncomps, nchan); % eigenvalues

% Run PCA
for chan = 1:nchan

    % Select proper data
    ts = squeeze(nps(chan, :, :)); 
    
    % Get evecs and evals
    [vecs, vals] = eig(ts*ts'); 
    [vals, v_inds] = sort(sort(sum(vals)), 'descend'); 
    vecs = vecs(:, v_inds); % reshape properly

    % assign values
    pc_weights(:, chan,:) = vecs(:, 1:ncomps)'*ts;
    pc_vecs(:, chan, :) = vecs(:, 1:ncomps)';
    pc_vals(:, chan) = vals(1:ncomps);
end

save([task '/' subject '/' subject '_decoupled'], 'pc_*','f')

clearvars -except q subject

end