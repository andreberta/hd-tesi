function mask = mask_region(parc,regions)
% MASK_REGION given a set of region and parc info for a patient, return a
% logical mask for the regions in the set

mask = zeros(size(parc));
for ii=1:length(regions)
    pos = parc2pos(regions{ii});
    mask = mask + (parc == pos);
end

mask = logical(mask);

end

