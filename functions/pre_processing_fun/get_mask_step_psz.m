function [mask] = get_mask_step_psz(mask,step,psz)
%%
%GET_MASK_STEP_PSZ Given the mask of a region, return the mask considering the
%step and the patch size (remove psz/2 border, skip step pixel along rows and cols)
%
%INPUT:
%   mask: a matrix containing only 0 and 1, 
%         where:
%               -mask(x,y) = 1 means that pixel (x,y) is in the region
%               -mask(x,y) = 0 means that pixel (x,y) is not in the region
%   step: ...
%   psz: patch size you are using in the analysis
%
%OUTPUT:
%   mask: the output mask

%% Computation
% compute the borders size
up_ = round(psz/2);
down_ = up_ - 1;
%remove the border
temp1 = mask(up_:end-down_,up_:end-down_);
%remove pixels to be skipped
temp2 = zeros(size(temp1));
temp2(1:step:end,1:step:end) = 1;
%compute the result
mask = temp1.*temp2;


end

