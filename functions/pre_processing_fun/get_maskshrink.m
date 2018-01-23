function [mask] = get_maskshrink( parameter,hemi,region)
%%
%GET_MASKSHRINK Return the shrink mask, computed with create_parameter_mat
%script, given the hemisphere and the region
%
%INPUT: 
%   parameter: parameter variable computed using create_parameter_mat
%   script
%
%   hemi: the hemisphere you are considering
%
%   region: the region you are considering
%
%OUTPUT:
%   mask: the mask stored in the parameter variable

%% Computation
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

