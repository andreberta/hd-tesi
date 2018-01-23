function [ res ] = pos2parc( pos )
%POS2PARC Return the parc name given the position of its RGB value 
%   Note that the RGB value are considered sorted
%
% Some Notes:
%   This function is the iverse of parc2pos

%%
rgb_level = RGB_label_value_parc();
parc_value = parc_region_value();

if pos>length(rgb_level) || pos < 0
    error('The value: "%d", is not admissible.', pos);
end

[~,I] = sort(rgb_level);
sorted_parc = parc_value(I);

res = sorted_parc(pos);

end

