function [ mask ] = get_maskshrink( parameter , hemi ,region )
%GET_MASKSHRINK 

pos = parc2pos(region);

if strcmp(hemi,'lh')
    mask = parameter.lh{pos}.parc_shrink == pos;
else if strcmp(hemi,'rh')
        mask = parameter.rh{pos}.parc_shrink == pos;
    else
        error('Hemi: %s does not exists',hemi);
    end
end


end

