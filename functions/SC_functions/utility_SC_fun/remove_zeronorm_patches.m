function [ res , temp3] = remove_zeronorm_patches( S )
%REMOVE_ZERONORM_PATCHES Recevie a vector of patches and remove the ones
%with zero norm

 temp1 = abs(S);
 temp2 = sum(temp1,1);
 temp3 = temp2 ~= 0;
 res = S(:,temp3);
 
end

