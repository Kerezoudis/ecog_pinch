function [output] = epoch_window(data, srate, tseg, overlap)

N = length(data);
t = (0:N-1) / srate;
nseg = tseg * srate;
noverlap = overlap * nseg;
noffset = nseg - noverlap;
K = floor(1 + (N-nseg)/noffset);  % number of segments
fprintf('N=%d, nseg=%d, noffset=%d, number of segments=%d.\n', N, nseg, noffset, K)

end