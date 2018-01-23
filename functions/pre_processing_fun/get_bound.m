function [bound] = get_bound(parameter,hemi,region)
%%
%GET_BOUND Return the bound of a region in a specific hemisphere. The bound
%are computed automatically during the parameter computation using
%parc_bounded.m

%INPUT: 
%   parameter: parameter variable computed using create_parameter_mat
%   script
%
%   hemi: the hemisphere you are considering
%
%   region: the region you are considering
%
%OUTPUT:
%   bound: the bound computed using the function parc_bounded

%% Computation
pos = parc2pos(region);

if strcmp(hemi,'lh')
    bound.lower_bound = parameter.lh{pos}.lower_bound;
    bound.upper_bound = parameter.lh{pos}.upper_bound;
    bound.right_bound = parameter.lh{pos}.right_bound;
    bound.left_bound  = parameter.lh{pos}.left_bound;
else if strcmp(hemi,'rh')
        bound.lower_bound = parameter.rh{pos}.lower_bound;
        bound.upper_bound = parameter.rh{pos}.upper_bound;
        bound.right_bound = parameter.rh{pos}.right_bound;
        bound.left_bound  = parameter.rh{pos}.left_bound;
    else
        error('Hemi: %s does not exists',hemi);
    end
end


end

