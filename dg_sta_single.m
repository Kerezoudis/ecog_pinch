function sta=dg_sta(dt,events,win)

sta=zeros(length(win(1):win(2)),1);

for k = 1:length(events)
    sta=sta+dt(events(k)+[win(1):win(2)]);
end

