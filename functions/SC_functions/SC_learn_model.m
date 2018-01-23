function [ dpr ] = SC_learn_model(patient_id,visits,hemi,parameter,dpr)
%%
%SC_LEARN_MODEL given a patient id learn the region-wise model <D,phi>
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

%% initialization
octave = parameter.octave;
regions = parameter.regions;
mean_ = parameter.mean;
random_ = 1;
curv_type = parameter.curv_type;
percentage = parameter.percentage;

if ~exist('dpr','var')
    dpr = cell(3,length(regions));
end


%% learn the region-wise model
for ii=1:length(regions)
    
    pos = parc2pos(regions{ii});
    
    if  ~isempty(dpr{1,pos}), continue; end
    
    %Print info
    clc;
    disp('LEARNING MODEL')
    disp(['Patient: ',num2str(patient_id)])
    disp(['Region: ',regions{ii},'(',num2str(ii),')']);
    disp(['Hemi: ',hemi]);
    if octave fflush(stdout); end
    
    
    disp(' Loading patches...');
    if octave fflush(stdout); end
    %pre-process: load patches, patthces are randomized
    [S,S_mean,index] = get_patches_multiple(patient_id,visits,parameter,regions{ii},...
        hemi,curv_type,random_);
    %skip this region if the number of patches extracted is 0
    if isempty(S)
        disp(' Skipping to next region.');
        if octave fflush(stdout); end
        continue;
    end
    %Divide the patches into 2 subset: patch_D to learn the dictionary and
    %patch_phi to learn the denisty
    mean_phi = [];
    patch_number = size(S,2);
    patch_D = S(:,1:round(patch_number*percentage));
    patch_phi = S(:,round(patch_number*percentage):end);
    %if the parameter.mean is set to 1, prepare also the average patch-wise
    %value of the patches used to learn the density
    if mean_
        mean_phi = S_mean(round(patch_number*percentage):end);
    end
    
    %learn dict
    D = SC_learn_dict(patch_D, parameter);
    %learn density
    kde_density = SC_kde(patch_phi,mean_phi,D,parameter);
    %print info
    disp(' Storing result...');
    if octave fflush(stdout); end
    %store the result in the output parameter
    dpr{1,pos} = D;
    dpr{2,pos} = kde_density;
    dpr{3,pos} = index;
    
    %Save temporary the results (in case of shut down...)
    if strcmp(hemi,'lh')
        save('dpr_lh.mat','dpr');
    else
        save('dpr_rh.mat','dpr');
    end
    
end


end

