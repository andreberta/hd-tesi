function res = compute_image_over(dict_per_region,img,visit)
if strcmp(visit,'v3')
    INDEX = 5;
else if strcmp(visit,'v2') 
        INDEX = 8;
    else
        error('Visit "%s" does not exist.', visit);
    end
end

full_mask_lh = zeros(size(dict_per_region{INDEX,1}));
for ii=1:size(dict_per_region,2)
    full_mask_lh = full_mask_lh + dict_per_region{INDEX,ii};
end
[res] = overlap_mask(img,logical(full_mask_lh));

end
