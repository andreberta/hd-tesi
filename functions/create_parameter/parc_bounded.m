function [parameter] = parc_bounded(parameter,region,hemi)
%%
%PARC_BOUNDED Define a small area in which the region is
%completely contained. The area is rectangular and defined by:
%   -lower_bound
%   -upper_bound
%   -right_bound
%   -left_bound
%This bounds are then used during the interpolation, in the 
%pre-processing phase, to reduce the number of vertex used and
%consequently to reduce the computational time.
%This function extract also a mask of the region, called parc_shrink.
%This mask should be used to identify pixels belonging to the region

%% get parc value from parameter
if strcmp(hemi,'lh')
    parc = parameter.parc_lh;
else if strcmp(hemi,'rh')
        parc = parameter.parc_rh;
    else
        error('Hemi: %s does not exists');
    end
end

%% rotate vertices according to the region  and the hemi
new_vert = rotate_vert( parameter , region , hemi );

%% compute parc img
parc_img = surf_to_pyramid_rect(new_vert,parc,parameter.resolution,1,1);

%% compute bound
pos = parc2pos(region);
[r,c] = ind2sub ([parameter.resolution+1,parameter.resolution+1],...
                     find((parc_img == pos)==1));

%% find bound max and min + psz
lower_bound = max(r) + parameter.psz;
upper_bound = min(r) - parameter.psz;
right_bound = max(c) + parameter.psz;
left_bound = min(c) - parameter.psz;

%% get shrink parc img
parc_shrink = parc_img(upper_bound:lower_bound,left_bound:right_bound);

%% store result in parameter struct
if strcmp(hemi,'lh')
    parameter.lh{pos}.parc_shrink = parc_shrink;
    parameter.lh{pos}.lower_bound = lower_bound;
    parameter.lh{pos}.upper_bound = upper_bound;
    parameter.lh{pos}.right_bound = right_bound;
    parameter.lh{pos}.left_bound  = left_bound;
else 
    parameter.rh{pos}.parc_shrink = parc_shrink;
    parameter.rh{pos}.lower_bound = lower_bound;
    parameter.rh{pos}.upper_bound = upper_bound;
    parameter.rh{pos}.right_bound = right_bound;
    parameter.rh{pos}.left_bound  = left_bound;
end

end