function plot_segments(segments, data, thresh, win)

% plot_segments(segments, data, thresh)
% This function plots the time series and fills in red the segments that 
% are above the threshold (based on supra_thresh function). 
% 
% The second figure plots the mean power value in each segment (cluster).
%
% segments = cell array containing the indices and values
% data = vector where the segments are derived from
% thresh = theshold value
%
% Panos Kerezoudis, CaMP lab, 2023

if isempty(segments), sprintf('No segments were identified')

else
for i = 1:size(segments, 1)
    subplot(1, 2, 1), plot(win(1):win(2), data, 'k', 'Linewidth', 1)
    set(gca, 'xtick', 1000*[ 0 1 2])
    yline(thresh, 'g')
    hold on
    plot(segments{i, 1} + win(1), segments{i, 2}, 'r', 'Linewidth', 2)
    area(segments{i, 1} + win(1), segments{i, 2}, 'BASEVALUE', thresh, 'FaceColor', 'r')
    ylabel("BB power change from baseline")
    xlabel("Time from stimulus onset (ms)")

    xlabels = categorical(["Cluster " + num2str(i)]);
    subplot(1, 2, 2), bar(xlabels, mean(segments{i, 2}), xlabels), hold on
    ylabel("Mean BB power change from baseline")
end
end

end