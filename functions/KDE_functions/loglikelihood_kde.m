function v = loglikelihood_kde(kde_density,samples)
% compute the value of the density estimated via kde in the provided
% samples
% kde_density is a structure with the following fields:
% - X
% - Y
% -density
% which are the output of the function kde2d
% - samples: n_samplesx2 matrix with the coordinates of the points
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

if isfield(kde_density,'Z')
    %% 3D density
    temp = reshape(-log(kde_density.density),size(kde_density.X));
    v = interp3(kde_density.X,kde_density.Y,kde_density.Z,temp,...
        samples(:,1),samples(:,2),samples(:,3));
else if isfield(kde_density,'Y')
        %% 2D density
        temp = -log(kde_density.density);
        v = interp2(kde_density.X,kde_density.Y,temp,samples(:,1),samples(:,2));
    else
        %% 1D density
        temp = -log(kde_density.density);
        v = interp1(kde_density.X(:),temp,samples);
    end
end

% remove inf and nan values
a= (v(:)==inf | isnan(v(:)));
v(a) = -inf;
b = max(v(:));
v(a) = b;
end











