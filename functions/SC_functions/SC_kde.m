function kde_density = SC_kde(patch_phi,mean_phi,D,parameter)
%%
% SC_KDE given a set of patches, patch_phi, compute their indicators w.r.t.
% D, then estimate the density based on the computed indicators using 2D KDE.
% If parameter.mean is set to 1 then, add to the indicator the average
% patch_wise value and compute the desnity using 3D KDE
%
%INPUTS:
%   patch_phi: a (psz)^2 x n matrix containing n patches of dimension (psz)^2. 
%   
%   mean_phi: the corresponding average patch-wise value, if parameter.mean
%   is set to 0, this input parameter in not considered
%
%   D: a dictionary
%
%   parameter: parameter variable computed using create_parameter_mat
%
%OUTPUT:
%   kde_density: a struct containing the result of KDE. The struct contain
%   the following fields:
%           -density: estimated value on the grid          
%           -X: values of the X axis of the grid
%           -Y: values of the Y axis of the grid
%           -Z: values of the Z axis of the grid (only if parameter.mean = 1)
%
%Some Notes:
%   -For 2D KDE the grid size is the defualt value set by the function kde2d
%    which is 2^8, --> 256x256 grid
%   -For 3D KDE i have set the grid size to 100 --> 100x100x100 grid

%% check parameter

if ~(size(patch_phi,2) == length(mean_phi))
    error('The size of patch_phi and the length of mean_phi should be equal');
end

%% initialization
octave = parameter.octave;
lambda = parameter.lambda;
mean_ = parameter.mean;

disp(' Computing indicators...');
if octave fflush(stdout); end

%% sparse coding
X = bpdn(D,patch_phi,lambda);


%% learn density


%compute reconstruction error and sparsity for the indicator
err = sqrt(sum((D*X-patch_phi).^2,1));
l1 = sum(abs(X),1);


if ~mean_
    %% 2d KDE
    disp(' Learning density (2D)...');
    if octave fflush(stdout); end
    %compose the 2D indicator
    indicators = [err',l1'];
    %KDE computation
    [~,density,xx,yy]  = kde2d(indicators);
    kde_density.density = density;
    kde_density.X = xx;
    kde_density.Y = yy;
else
    %% 3d KDE
    disp(' Learning density (3D)...');
    if octave fflush(stdout); end
    %compose the 3D indicator
    indicators = [err',l1',mean_phi'];
    % total grid points = ng^d
    [~,d]=size(indicators);
    ng=100;
    
    
    % create meshgrid in 3-dimensions
    MAX=max(indicators,[],1);
    MIN=min(indicators,[],1);
    scaling=MAX-MIN;
    [X1,X2,X3]=meshgrid(MIN(1):scaling(1)/(ng-1):MAX(1),...
        MIN(2):scaling(2)/(ng-1):MAX(2),MIN(3):scaling(3)/(ng-1):MAX(3));
    
    % create points for plotting
    grid=reshape([X1(:),X2(:),X3(:)],ng^d,d);
    
    %KDE computation
    density=akde(indicators,grid);
    kde_density.density = density;
    kde_density.X = X1;
    kde_density.Y = X2;
    kde_density.Z = X3;
end



end