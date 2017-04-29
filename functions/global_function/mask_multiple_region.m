function [ mask ] = mask_multiple_region( parc , regions )
%MASK_MULTIPLE_REGION Given a parcellation image (see surf_to_pyramid_aparc)
% and a set of regions return the logical mask for those regions

mask = zeros(size(parc));

for ii=1:length(regions)

    pos = parc2pos(regions{ii});
    mask = mask + (parc == pos);
    
end

mask = logical(mask);

end

