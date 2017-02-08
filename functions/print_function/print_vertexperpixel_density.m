function  print_vertexperpixel_density( patient , visit_number , hemi )
%PRINT_VERTEXPERPIXEL_DENSITY 
%   

if strcmp(hemi,'lh')
    visit = patient.visit{visit_number}.lh;
else if strcmp(hemi,'rh')
        visit = patient.visit{visit_number}.rh;
    else
        error('Hemisphere "%s" does not exist.', hemi);
    end
end

vertex_per_pix = visit.vertex_per_pix;
resolutions = [100 300 500 700 1000];

for ii=1:length(vertex_per_pix)
    figure,
    %hist(vertex_per_pix{ii}); --> 1D version
    x = [resolutions(ii),resolutions(ii)];
    hist3(vertex_per_pix{ii},x);
end


end

