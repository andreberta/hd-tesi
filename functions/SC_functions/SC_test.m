function [ res ] = SC_test(dpr , patient_id , visits , curv_type , hemi , parameter)

lambda = parameter.lambda;
regions = parc_region_value();
res.vsitis = visits;
res.values = cell(length(regions),length(visits));

for jj=1:length(visits)
    for ii=1:length(regions)
        whole_stat = [];
        pos = parc2pos(regions{ii});
        
        clc;        
        disp('TESTING')
        disp(['Patient: ',num2str(patient_id)])
        disp(['Visit: ',num2str(visits(jj))]);
        disp(['Region: ',regions{ii},'(',num2str(ii),')']);
        fflush(stdout);
        
        %get patches to test
        disp(' Loading patches...');
        fflush(stdout);
        S = get_patches_test(patient_id,visits(jj),parameter,...
                                    regions{ii},hemi,curv_type);

        
        %skip
        if isempty(S)
            disp(' Number of patches is 0, skipping to next region.');
            fflush(stdout);
            continue;
        end
        
        %learn density
        disp(' Computing indicators...');
        fflush(stdout);
        D = dpr{1,pos};
        kde = dpr{2,pos};
        X = bpdn(D,S,lambda);
        
        err = sqrt(sum((D*X-S).^2));
        l1 = sum(abs(X));
        test_ind = [err(:),l1(:)];
        
        stat = loglikelihood_kde(kde,test_ind);      

        disp(' Storing result...');
        fflush(stdout);
        res.values{pos,jj} = stat;
    end
end




end

