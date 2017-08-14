function hist_as(patient_id,hemi,curv_type )

%% iniziatilization
regions = parc_region_value();

% read data
path = ['extracted_data/',curv_type,'/','patient_',num2str(patient_id),'/'];
load([path,'patient.mat']);
%select hemi res
if strcmp(hemi,'lh')
    res = patient.res.lh;
else
    res = patient.res.rh;
end
%extract visit number 
visit_number = size(res,2);


%%
for ii=1:length(regions)

    pos = parc2pos(regions{ii});
    if ii==5 || ii==36, continue; end %skip regions
    
    jj = 1;
    curr_value = res{pos,jj};    
    hist_property = histogram(curr_value);
    edges = hist_property.BinEdges;
    title([num2str(patient_id),'-',regions{ii},'-',hemi,'-',num2str(jj)]);
    pause;
    for jj=2:visit_number
        curr_value = res{pos,jj};
        histogram(curr_value,edges);        
        title([num2str(patient_id),'-',regions{ii},'-',hemi,'-',num2str(jj)]);
        pause;
    end
    
    
end



end

