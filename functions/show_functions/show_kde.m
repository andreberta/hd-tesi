function show_kde( patient )
%SHOW_KDE 

regions = parc_region_value();

figure
for ii= 1:length(regions)
    
    if isempty(patient.sc_data.lh{2,ii}) || ...
            isempty(patient.sc_data.rh{2,ii})
        continue
    end
    
    subplot(1,2,1),imagesc(patient.sc_data.lh{2,ii}.density),colorbar
    title([regions{ii},'kde-lh'])
    subplot(1,2,2),imagesc(patient.sc_data.rh{2,ii}.density),colorbar
    title([regions{ii},'-kde-rh'])
    pause
end

close


end

