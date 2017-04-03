function [ patch_count ] = patch_count(parc , psz )
%PATCH_COUNT 

border = ones(size(parc));
border(1:psz,:) = 0;         %<--upper border
border(end-psz:end,:) = 0;   %<--lower border
border(:,1:psz) = 0;         %<--left border
border(:,end-psz:end) = 0;   %<--right border

rgb_values = unique(parc);
patch_count = zeros(1,max(rgb_values));
for ii=1:length(rgb_values)
    pos = rgb_values(ii);
    mask = parc == rgb_values(ii);
    patch_count(pos) = sum(sum(border.*mask));
end


end

