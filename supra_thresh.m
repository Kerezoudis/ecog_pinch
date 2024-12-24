function [output] = supra_thresh(data, thresh, duration)

% [output] = supra_thresh(data, thresh, duration)
% 
% This function will search a vector (row or column) for consecutive
% values above a certain threshold.
% 
% Input: 
%   data = vector (row or column)
%   thresh = threshold value 
%   duration = min length of elements above threshold 
%
% Output: cell format with 
%   rows = different vector segments meeting the criteria above
%   column 1 = segment indices
%   column 2 = segment values
% 
% Panos Kerezoudis, CaMP lab, 2024

% Identify segments above threshold
label = bwlabel( bwareafilt(data > thresh, [duration, Inf]) );

% Save output in cell
N = cell(max(label), 2); 

if ~ isempty(N)
    for kk = 1:max(label)
        output{kk, 1} = find(label == kk);
        output{kk, 2} = data(find(label == kk));
    end
else output = [];
end

end