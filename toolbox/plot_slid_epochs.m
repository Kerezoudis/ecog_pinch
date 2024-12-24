function plot_slid_epochs(data, time, epochs)

% plot_slid_epochs(data, time, epochs)
%
% This function plots the sliding epoched windows (from epoch_window fn)
% data = original time series
% time = time vector (in seconds)
% epochs = matrix containining diff epochs in columns
% 
% Panos Kerezoudis, CaMP lab, 2023

for i = 1:size(epochs, 2)
    plot(time(:, i), data(epochs(:, i)) + (i-1)/5,'-r')
    hold on    
end
grid on; xlabel('Time (s)')
title("Window segments")
ylabel("BB power")


end