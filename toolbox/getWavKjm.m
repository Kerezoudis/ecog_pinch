function [S, f] = getWavKjm(V, srate, frange, beh)
    
    S = nan(length(frange), size(V, 1), size(V, 2));
    for ii = 1:size(V, 2)
        S(:, :, ii) = wavelet_pac(V(:, ii), srate, frange)';
    end
    S = abs(S).^2; % convert to power
    f = frange; 

% function [wsignal]=wavelet_pac(rawsignal,srate,frange)
% calculated wavelet fintered signal from frange (high:step:low)
% rawsignal=signal(:,44);
% frange=30:-1:1;
% srate=512;
% kjm
function wsignal = wavelet_pac(rawsignal, srate, frange, verbose)

    if nargin < 4, verbose = false; end

    wsignal = zeros(length(rawsignal), length(frange));
    fmax = frange(end);

    for kk = 1:length(frange)

        f = frange(kk);
        if mod(f, 10) == 0 && verbose, disp(['on ' num2str(f) ' of ' num2str(fmax)]), end

        %create wavelet
        t = 1:floor(10*srate/f);% N of cycles
        wvlt = exp(1i*2*pi*f*(t-floor(max(t)/2))/srate).*gausswin(max(t))'; %gaussian envelope

        %calculate convolution
        tconv = conv(wvlt, rawsignal);
        tconv([1:(floor(length(wvlt)/2)-1) floor(length(tconv)-length(wvlt)/2+1):length(tconv)]) = []; %eliminate edges 
        wsignal(:, kk) = tconv;
    end
end
end
