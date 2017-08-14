function kde_density = SC_kde(patch_phi,mean_phi,D,parameter)

octave = parameter.octave;
lambda = parameter.lambda;

disp(' Computing indicators...');
if octave fflush(stdout); end

%sparse coding
X = bpdn(D,patch_phi,lambda);


%learn density
disp(' Learning density...');
if octave fflush(stdout); end

%compute indicators
err = sqrt(sum((D*X-patch_phi).^2,1));
l1 = sum(abs(X),1);
indicators = [err',l1'];


[~,density,xx,yy]  = kde2d(indicators);
kde_density.density = density;
kde_density.X = xx;
kde_density.Y = yy;



end