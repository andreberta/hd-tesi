function [ res ] = parc2pos( region_name )
% PARC2POS Given a region name return its position, corresponding to 
% to the RGB value order
% Some Notes:
%   You can see the result of this function as an internal code, which can
%   be used to indetify a region
% 
%   The code returned by this function is unique for each region and
%   depends on its RGB code. However, the same region in the two hemi, has
%   the same RGB code, therefore, you need to keep separate them by
%   yourself

rgb_level = RGB_label_value_parc();
parc_value = parc_region_value();
[~,I] = sort(rgb_level);
found = 0;

for ii=1:length(parc_value)
    if strcmp(parc_value{ii},region_name)
        found = 1;
        break;
    end
end

if found
    res = find(I == ii);
else
    error('The value: "%s", is not admissible.', region_name);
end

end

