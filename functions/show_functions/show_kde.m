function show_kde( patient , hemi)
%SHOW_KDE

regions = parc_region_value();


for ii= 1:length(regions)
    
    pos = parc2pos(regions{ii});
    
%     if isempty(patient.sc_data.lh{2,pos}) || ...
%             isempty(patient.sc_data.rh{2,pos})
%         continue
%     end
    
    if strcmp(hemi,'lh')
        d_strcut = patient.sc_data.lh{2,pos};
    else
        d_strcut = patient.sc_data.rh{2,pos};
    end
    
    if isempty(d_strcut); continue; end
    
    
    show_kde_inner(d_strcut),colorbar
    title([regions{ii},'kde-',hemi])
    
    
    pause
    close;
end

close all;
end

function show_kde_inner(d_strcut)

if ~isfield(d_strcut,'Z')
    surf(d_strcut.X,d_strcut.Y,d_strcut.density,'Lynestyle','None');
    view(2);
    xlabel('Reconstruction Error');
    ylabel('Sparsity');
else
    isosurface(d_strcut.X,d_strcut.Y,d_strcut.Z,...
        reshape(d_strcut.density,size(d_strcut.X)));
    view(3),alpha(.3),box on,colormap cool,hold off;
    xlabel('Reconstruction Error');
    ylabel('Sparsity');
    zlabel('Mean Patch Value');
end

end

