function kde_density = SC_kde(patch_phi,mean_phi,D,parameter)

%% initialization
octave = parameter.octave;
lambda = parameter.lambda;
mean_ = parameter.mean;

disp(' Computing indicators...');
if octave fflush(stdout); end

%% sparse coding
X = bpdn(D,patch_phi,lambda);


%% learn density


%compute indicators
err = sqrt(sum((D*X-patch_phi).^2,1));
l1 = sum(abs(X),1);


if ~mean_
    %% 2d KDE
    disp(' Learning density (2D)...');
    if octave fflush(stdout); end
    indicators = [err',l1'];
    [~,density,xx,yy]  = kde2d(indicators);
    kde_density.density = density;
    kde_density.X = xx;
    kde_density.Y = yy;
else
    %% 3d KDE
    disp(' Learning density (3D)...');
    if octave fflush(stdout); end
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
    
    % run adaptive kde
    density=akde(indicators,grid);
    kde_density.density = density;
    kde_density.X = X1;
    kde_density.Y = X2;
    kde_density.Z = X3;
end



end