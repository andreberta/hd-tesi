function [stat,X] = sparse_coding(data)
% Function to compute the sparse coding of the test images
% returns the value of the density over all the pixels of the test image
% 
% Revision history
% May 2016 - First Release
%
% References
% [1] Giacomo Boracchi, Diego Carrera, Brendt Wohlberg
%     Novelty Detection in Images by Sparse Representations
%     IEEE Symposium Series on Computational Intelligence (SSCI), 2014
%     doi:10.1109/INTELES.2014.7008985
% 
% [2] Diego Carrera, Fabio Manganini, Giacomo Boracchi, Ettore Lanzarone
%     Defect Detection in Nanostructures
%     http://bibliograzia.imati.cnr.it/sites/bibliograzia.vp1.it/files/16-03.pdf
%
% Author: Diego Carrera
% diego.carrera@polimi.it

img = data.img;
psz = data.psz;
step = data.step;
lambda = data.lambda;
D = data.D;
kde_density = data.kde_density;

S = im2colstep(img,[psz,psz],[step,step]);
S = bsxfun(@minus,S,mean(S,1));
[S,index_nozeronorm] = remove_zeronorm_patches(S);

X = bpdn(D,S,lambda);
err = sqrt(sum((D*X-S).^2));
l1 = sum(abs(X));

test_ind = [err(:),l1(:)];

stat = loglikelihood_kde(kde_density,test_ind);

whole_stat(index_nozeronorm) = stat;
whole_stat(~index_nozeronorm) = 0;
stat = reconstruct_stat(whole_stat,img,psz,step);

end

%% function

function stat = reconstruct_stat(stat,img,psz,step)


[M,N] = size(img);

MM = length(1:step:(M-psz+1));
NN = length(1:step:(N-psz+1));

small_stat = reshape(stat,MM,NN);
stat = zeros(M-psz+1,N-psz+1);
for ii=1:step
    vi = 1:step:(M-psz+1);
    vi = vi + ii - 1;
    wi = 1:MM;
    if (vi(end) > M-psz+1)
        vi(end) = [];
        wi(end) = [];
    end
    for jj=1:step
        vj = 1:step:(N-psz+1);
        vj = vj + jj - 1;
        wj = 1:NN;
        if (vj(end) > N-psz+1)
            vj(end) = [];
            wj(end) = [];
        end
        stat(vi,vj) = small_stat(wi,wj);
    end
end
end

