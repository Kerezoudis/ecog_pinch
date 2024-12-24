function [output1, output2] = epoch_window(data, srate, tseg, overlap)

% This function will segment your time series into overlapping segments.
%
% [output1, output2] = epoch_window(data, srate, tseg, overlap)
%
% data = time series (row or column vector)
% srate = sampling rate
% tseg = length of the segment (in seconds)
% overlap = overlap length (in percentage of the segment)
%
% output1 = time vector of segments (in seconds)
% output2 = time indices of the segments

N = length(data);
t = (0:N-1)/srate; 
nseg = tseg * srate;
noverlap = overlap * nseg;
noffset = nseg - noverlap;
K = floor(1 + (N-nseg)/noffset);  % number of segments
% fprintf(['window length=%d, segment length=%d, offset length=%d, ...' 
%     'number of segments=%d.\n'], N, nseg, noffset, K)

output1 = zeros(nseg, K);
output2 = zeros(nseg, K); 

for i = 1:K
    output1(:, i) = t(1+(i-1) * noffset:(i-1) * noffset + nseg);
    output2(:, i) = data(1+(i-1) * noffset:(i-1) * noffset + nseg);
end

end

% Panos Kerezoudis, CaMP lab, 2023 
% with help of William Rose, Mathworks, 2023