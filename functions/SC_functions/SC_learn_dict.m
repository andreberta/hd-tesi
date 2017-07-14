function [ dpr ] = SC_learn_dict(patient_id , visits , curv_type , hemi , parameter)


octave = parameter.octave;
lamda = parameter.lambda;
dict_dim_mult = parameter.dim_dict_mult;
regions = parameter.regions; 
psz = parameter.psz;
dpr = cell(1,length(regions));

%% learn dictionary
for ii=1:length(regions)

    pos = parc2pos(regions{ii});

    clc;    
    disp('DICTIONARY LEARNING')
    disp(['Patient: ',num2str(patient_id)])
    disp(['Region: ',regions{ii},'(',num2str(ii),')']);
    disp(['Hemi: ',hemi]);
    if octave fflush(stdout); end

    %get patches from which learn the dictionary
    disp(' Loading patches...');
    if octave fflush(stdout); end
    S = get_patches(patient_id , visits , parameter , regions{ii} , hemi , curv_type);
    
    %skip 
    if isempty(S)
    disp(' Number of patches is 0, skipping to next region.');
    if octave fflush(stdout); end
      continue;  
    end
    
    %learn dict
    disp(' Learning dictionary...');
    if octave fflush(stdout); end
    D0 = randn(psz^2,round((psz^2)*dict_dim_mult));
    D= bpdndl(D0,S,lamda);
    
    disp(' Storing result...');
    if octave fflush(stdout); end
    dpr{1,pos} = D;

end


end