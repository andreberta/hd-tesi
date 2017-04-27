function show_sc_stat( patient )
%SHOW_SC_STAT 

visit = patient.visit;

figure
for ii= 2:length(visit)
    subplot(1,2,1),imagesc(visit{ii}.lh.stat),colormap(gray),colorbar,
    title(['visit-',num2str(ii),'-hemi-lh'])
    subplot(1,2,2),imagesc(visit{ii}.rh.stat),colormap(gray),colorbar,
    title(['visit-',num2str(ii),'-hemi-rh'])
    pause
end

close
end



