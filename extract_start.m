function [kpts, pts] = extract_start(tr_sc, trialnr)

% [kpts] = extract_start(tr_sc, trialnr)
%
% This function extracts the first time points of the input vector 
% that correspond to movements trials. 
% 
% Panos Kerezoudis, CaMP lab, 2024. 

% Set up parameters and time points ---------------------------------------
uplim = 3000;
moveTrial = find(tr_sc == 1 | tr_sc == 2 | tr_sc == 3);
pts = zeros(size(moveTrial, 2), 3);

% Extract start and end times for each movement type ----------------------
for i = 1:size(moveTrial, 2)
    block = find(trialnr == moveTrial(i));
    pts(i, 1) = block(1); pts(i, 2) = block(end); 
    if tr_sc(moveTrial(i)) == 1,  pts(i, 3) = 1;
    elseif tr_sc(moveTrial(i)) == 2,  pts(i, 3) = 2;
    end
end

kpts = pts(find(pts(:, 3) == 1), 1);
kpts = [kpts(1) kpts(find(diff(kpts) > uplim) + 1)'];

end