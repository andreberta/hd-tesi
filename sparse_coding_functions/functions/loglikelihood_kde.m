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

if (isfield(kde_density,'Y'))
    x_grid = kde_density.X(1,:)';
    y_grid = kde_density.Y(:,1)';
    xq = samples(:,1);
    yq = samples(:,2);
    x_ind = interp1(x_grid,1:length(x_grid),xq,'nearest');
    y_ind = interp1(y_grid,1:length(y_grid),yq,'nearest');
    
    ind = x_ind + length(x_grid)*(y_ind-1);
    
    v = -log(kde_density.density(ind))';
    
else
    x_grid = kde_density.X(:)';
    xq = samples(:);
    x_ind = interp1(x_grid,1:length(x_grid),xq,'nearest');
    v = -log(kde_density.density(x_ind))';
end

a = find(v==inf);
v(a) = -inf;
b = max(v);
v(a) = b;










