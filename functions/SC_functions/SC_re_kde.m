function [ dpr ] = SC_re_kde(patient_id,visit_distr,curv_type,hemi,...
    parameter,percentage,dpr)
%%
%SC_RE_KDE Re-estimate the density.
%
%INPUTS:
%   patient_id: the id of the patient
%
%   visit_distr: a struct containing the distribution of visits, the struct
%   should have the following fields:
%                       -dict_learn: a vector containing the visits used to
%                       learn the dictionary
%                       -density_estimation: a vector containing the visits
%                       used to estimate the density
%                       -visit_tested: a vector containing the visits used
%                       for the test
%
%   curv_type: the type of curve you are considering for the analysis
%
%   hemi: the hemisphere you are considering for the analysis
%
%   parameter: parameter variable computed using create_parameter_mat
%
%   percentage: define the percentage of patches used to learn the
%   dictionary, while the reamaining are used to estimate the density
%
%   dpr (OPTIONAL): if you have partially computed the model for this
%   patient, you can specify this input parameter and skip the computation
%   of the already computed ones
%
%OUTPUT:
%   dpr: a cell array, which contains the resulting models for the
%   specified patient. The cell is has dimension 3xk, where k is the number
%   of regions:
%           -dpr{1,x} contains the dictionary of region in pos x
%           -dpr{2,x} contains the density of region in pos x
%           -dpr{3,x} contains the index of patches of region in pos x
%   (the pos of the region is computed using parc2pos function)

%% check parameter

if ~(strcmp(hemi,'lh') || strcmp(hemi,'rh'))
    error('Hemi: %s does not exists',hemi);
end

if ~any(strcmp(curvature_value(),curv_type))
    error('Curvature name: %s does not exists',curv_type);
end
%% Initialization
octave = parameter.octave;
regions = parameter.regions;
mean_ = parameter.mean;

whole_visit = [visit_distr.dict_learn,visit_distr.density_estimation];
whole_visit = unique(whole_visit);


%% Computation
for ii=1:length(regions)
    %get region position
    pos = parc2pos(regions{ii});
    %show info
    clc;
    disp('LEARNING MODEL')
    disp(['Patient: ',num2str(patient_id)])
    disp(['Region: ',regions{ii},'(',num2str(ii),')']);
    disp(['Hemi: ',hemi]);
    if octave fflush(stdout); end
    
    %get patches from which learn the dictionary
    disp(' Loading patches...');
    if octave fflush(stdout); end
    [S,S_mean,~] = get_patches_multiple(patient_id,whole_visit,parameter,regions{ii},...
        hemi,curv_type,1);
    %skip
    if isempty(S)
        disp(' Skipping to next region.');
        if octave fflush(stdout); end
        continue;
    end
    %get the learned dictionary
    D = dpr{1,pos};
    index = dpr{3,pos};
    %oreder patches, in order to get the same patches used previously to
    %estimate the density
    S = S(:,index);
    patch_number = size(S,2);
    patch_phi = S(:,round(patch_number*percentage):end);
    mean_phi = [];
    if mean_
        mean_phi = S_mean(round(patch_number*percentage):end);
    end
    %re-learn density
    kde_density = SC_kde(patch_phi,mean_phi,D,parameter);
    %store results
    disp(' Storing result...');
    if octave fflush(stdout); end
    dpr{2,pos} = kde_density;
    %save intermediate results
    if strcmp(hemi,'lh')
        save('dpr_lh.mat','dpr');
    else
        save('dpr_rh.mat','dpr');
    end
    
end


end

