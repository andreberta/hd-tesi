function mask = get_mask_step_psz(mask,step,psz)
%GET_MASK_STEP_PSZ Given the original mask, return the mask considering the
%step and the patch size (remove psz/2 border, skip step pixel alon rows and cols)

up_ = round(psz/2);
down_ = up_ - 1;


temp1 = mask(up_:end-down_,up_:end-down_);

temp2 = zeros(size(temp1));

temp2(1:step:end,1:step:end) = 1;

mask = temp1.*temp2;


end

