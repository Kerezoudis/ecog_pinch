function plot_epoch_fit(data, epochs, time, thresh)

% plot_epoch_fit(data, epochs, thresh)
% 
% This funtion plots the sliding epoched windows of a segment (in black), 
% along with their OLS linear fit (in red)
% The threshold value is shown in light green
% 
% data = time series where epochs are derived from
% epochs = time segments generated from epoch_window fn
% thresh = threshold value
% 
% Panos Kerezoudis, CaMP lab, 2023

for i = 1:size(epochs, 2)
    f = polyfit(epochs(:, i), data(epochs(:, i)), 1);
    y_est(:, i) = polyval(f, epochs(:, i));
end

tiledlayout(7, 3);
for i = 1:size(epochs, 2)
    nexttile()
    plot(time(:, i)*1000, data(epochs(:, i)), 'k', "Linewidth", 1), hold on
    plot(time(:, i)*1000, y_est(:, i), 'r', "Linewidth", 1)
    xlabel("Time (ms)")
    ylabel("BB power change")
    box off
    title("Epoch " + num2str(i))
    dg_figfix

    if exist('thresh', 'var')
    yline(thresh, 'g')
    end
end

end