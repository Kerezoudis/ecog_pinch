function plot_sta(subject)

% This function plots the different STA timeseries.
% User needs to have previously executed the gen_sta function.
% 
% Panos Kerezoudis, CaMP lab, 2023


% Load related data files
load(['pinch/' subject '/' subject '_sta'])
win = [llim uplim];

% Plotting parameters
bcol = [[0 0 .5]; [0 .5 0]; [.5 1 .5]; [0 .5 .5];  [.5 .5 1];[.3 .3 .3]];
fid = figure; fid.Position = [100 100 1000 800];
sgtitle("Stimulus triggered average timeseries")

% Average potential
subplot(6, 1, 1), plot([win(1):win(2)], sta.data, 'k')
axis tight
a = get(gca, 'ylim');
set(gca, 'ylim', [min([0 1.1*a(1)]) max([a(2) 1.1*a(2)])])
set(gca, 'ytick', 10*[ceil(.8*a(1)/10) floor(.8*a(2)/10)])
ylabel('\mu V')
set(gca, 'xtick', 1000*[ 0 1 2])
title("Event Related Potential")

% Average BB
subplot(6, 1, 2), plot([win(1):win(2)], exp(sta.lnA), 'color', [0.6350 0.0780 0.1840])
axis tight
a = get(gca,'ylim');
set(gca, 'ylim', [min([0 1.1*a(1)]) max([a(2) 1.1*a(2)])])
set(gca, 'ytick',[min([ceil(a(1)) floor(.8*a(2))-1]) floor(.8*a(2))])
ylabel('N.U.')
set(gca, 'xtick', 1000*[ 0 1 2])
text(win(1)+200, .8*a(2), ['Finger movement onset'], 'FontSize', 12)
title("Broadband")

% Time-frequency plot
subplot(6, 1, 3), imagesc(win(1):win(2), 0:50:200, sta.tf(:, 200:-1:1).')
a = get(gca,'yticklabel'); set(gca,'yticklabel',a(end:-1:1,:))
load('dg_colormap')
colormap(cm)

if mean(std(sta.tf,1))>.15
    set(gca,'clim',[0 2]),
    text(win(2)-500,20,'0 to 200%','FontSize',8)
else 
        set(gca,'clim',[.5 1.5]), 
        text(win(2)-500,20,'50 to 150%','FontSize',8)
end
ylabel('Frequency (Hz)')
set(gca,'ytick',[ 50 100 150 200]), set(gca,'yticklabel',[150 100 50 0]) 
set(gca,'xtick',[])
box off, dg_figfix

% Beta rhythm
subplot(6, 1, 4), plot([win(1):win(2)], sta.beta, 'color', bcol(1,:)), hold on
yline(0)
axis tight
a = get(gca, 'ylim');
set(gca,'ylim', [min([0 1.1*a(1)]) max([a(2) 1.1*a(2)])])
ylabel('N.U.')
set(gca, 'xtick', 1000*[ 0 1 2])
title("Beta rhythm (12-20 Hz)")

% Data glove trace % Thumb
subplot(6, 1, 5), plot([win(1):win(2)], sta.thumb, 'g')
set(gca, 'xtick', 1000*[ 0 1 2])
ylabel('N.U.')
title("Thumb movement")
% Index
subplot(6, 1, 6), plot([win(1):win(2)], sta.index, 'm')
set(gca, 'xtick', 1000*[0 1 2])
ylabel('N.U.')
xlabel('Time from stimulus onset (ms)')
title("Index movement")
dg_figfix


end