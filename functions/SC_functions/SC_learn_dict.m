function D = SC_learn_dict(patch_D, parameter)

psz = parameter.psz;
dict_dim_mult = parameter.dim_dict_mult;
lambda = parameter.lambda;
octave = parameter.octave;

disp(' Learning dictionary')
if octave fflush(stdout); end

D0 = randn(psz^2,round((psz^2)*dict_dim_mult));
D= bpdndl(D0,patch_D,lambda);


end