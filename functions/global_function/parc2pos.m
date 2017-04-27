function [ res ] = parc2pos( parc )
%PARC2POS Given a region name return its position, corresponding to 
% to the RGB value order

rgb_level = RGB_label_value_parc();
parc_value = parc_region_value();
[~,I] = sort(rgb_level);
found = 0;

for ii=1:length(parc_value)
    if strcmp(parc_value{ii},parc)
        found = 1;
        break;
    end
end

if found
    res = find(I == ii);
else
    error('The value: "%s", is not admissible.', parc);
end

end

