function D = SC_learn_dict(patch_D, parameter)
%%
% SC_LEARN_DICT Given a set of patches, patch_D, learn a dictionary D. The
% number of atoms is defined by parameter.dim_dict_mult
%
%INPUTS:
%   patch_D: a (psz)^2 x n matrix containing n patches of dimension (psz)^2.
%
%   parameter: parameter variable computed using create_parameter_mat
%
%OUTPUT:
%   D: the dictionary result of the dictionary learning

%% Computation

%initialization
psz = parameter.psz;
dict_dim_mult = parameter.dim_dict_mult;
lambda = parameter.lambda;
octave = parameter.octave;

disp(' Learning dictionary')
if octave fflush(stdout); end

%create the inital guess dictionary with random values
D0 = randn(psz^2,round((psz^2)*dict_dim_mult));
%Dictionary Learning
D= bpdndl(D0,patch_D,lambda);


end