function [ output ] = patch_wise_difference( src , src_hat , p_dim)
%PATCH_WISE_DIFFERENCE Patch-wise difference between two images

[size_z1,size_z2] = size(src);

output = zeros(size_z1,size_z2);
src_hat_pad = padarray(src_hat,[p_dim p_dim],'symmetric');
src_pad= padarray(src,[p_dim p_dim],'symmetric');
for x1=1:size_z1
    for x2=1:size_z2
         x1_ = x1+ p_dim;
         x2_ = x2+ p_dim;
         P_hat= src_hat_pad(x1_-p_dim:x1_+p_dim , x2_-p_dim:x2_+p_dim);
         P = src_pad(x1_-p_dim:x1_+p_dim , x2_-p_dim:x2_+p_dim);
         output(x1,x2) = norm(P_hat - P);
    end
end
end

