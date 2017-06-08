function [ dpr ] = SC_learn_dict(patient_id , visits , curv_type , hemi , parameter)



lamda = parameter.lambda;
dict_dim_mult = parameter.dim_dict_mult;
regions = parc_region_value(); 
psz = parameter.psz;
dpr = cell(1,length(regions));

%% learn dictionary
for ii=1:length(regions)

    pos = parc2pos(regions{ii});

    clc;    
    disp('DICTIONARY LEARNING')
    disp(['Patient: ',num2str(patient_id)])
    disp(['Region: ',regions{ii},'(',num2str(ii),')']);
    fflush(stdout);

    %get patches from which learn the dictionary
    disp(' Loading patches...');
    fflush(stdout);
    S = get_patches(patient_id , visits , parameter , regions{ii} , hemi , curv_type);
    
    %skip 
    if isempty(S)
    disp(' Number of patches is 0, skipping to next region.');
    fflush(stdout);
      continue;  
    end
    
    %learn dict
    disp(' Learning dictionary...');
    fflush(stdout);
    D0 = randn(psz^2,round((psz^2)*dict_dim_mult));
    D= bpdndl(D0,S,lamda);
    
    disp(' Storing result...');
    fflush(stdout);
    dpr{1,pos} = D;

end


end