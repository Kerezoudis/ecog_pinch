function kjm_printfig(fname, ppsize, plotOptions)

% This function exports the current figure in a reasonable way, in both eps
% and png formats kjm 05/10
%
% "fname" - desired filename. include path if desired
% "size" - size of figure in cm

set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperSize', ppsize);
set(gcf, 'PaperPosition',[0 0 2*ppsize])

if plotOptions == 1 
    print(gcf, fname, '-dpng', '-r300', '-painters')
else
    print(gcf, fname, '-dpng', '-r300', '-painters')
    print(gcf, fname, '-depsc2', '-r300', '-painters')
end



end


