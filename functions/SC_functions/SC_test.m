function values = SC_test(dpr,patient_id,visits,hemi,parameter,values)

%% 
%SC_TEST Compute anomaly scores for a patient, defined by patient_id, in
%the visits defined by visits
%
%INPUT:
%   dpr: the cell array returned by SC_learn_model function
%
%   patient_id: the id of the patient
%
%   visits: a vector containing the visits to test
%
%   curv_type: the curvature type you are considering
%
%   hemi: the hemisphere you are considering
%
%   parameter: parameter variable computed using create_parameter_mat
%
%   values (OPTIONAL): 
%
%OUTPUT:
%

%% check input
if ~(strcmp(hemi,'lh') || strcmp(hemi,'rh'))
    error('Hemi: %s does not exists',hemi);
end


%% Initaliziation
lambda = parameter.lambda;
regions = parameter.regions;
octave = parameter.octave;
mean_ = parameter.mean;
curv_type = parameter.curv_type;


if ~exist('values','var')
    values = cell(length(parc_region_value()),length(visits));
end

%% Computation



for jj=1:length(visits)
    for ii=1:length(regions)
        pos = parc2pos(regions{ii});
        
        if ~isempty(values{pos,jj}), continue; end
        
        clc;
        disp('TESTING')
        disp(['Patient: ',num2str(patient_id)])
        disp(['Visit: ',num2str(visits(jj))]);
        disp(['Region: ',regions{ii},' (',num2str(ii),')']);
        disp(['Hemi: ',hemi]);
        if octave fflush(stdout); end
        
        %get patches to test
        disp(' Loading patches...');
        if octave fflush(stdout); end
        [S,~,S_mean] = get_patches(patient_id,visits(jj),...
            parameter,regions{ii},hemi,curv_type);
        
        
        %skip
        if isempty(S)
            disp(' Number of patches is 0, skipping to next region.');
            if octave fflush(stdout); end
            continue;
        end
        
        %compute indicators
        disp(' Computing indicators...');
        if octave fflush(stdout); end
        D = dpr{1,pos};
        kde = dpr{2,pos};
        X = bpdn(D,S,lambda);
        
        err = sqrt(sum((D*X-S).^2));
        l1 = sum(abs(X));
        
        if ~mean_
            test_ind = [err(:),l1(:)];
        else
            test_ind = [err(:),l1(:),S_mean'];
        end
        
        stat = loglikelihood_kde(kde,test_ind);
        
        disp(' Storing result...');
        if octave fflush(stdout); end
        values{pos,jj} = stat;
    end
end




end

