function  show_dictionaries(patient,hemi,regions,no_noisy)
%SHOW_DICTIONARIES show the dictionaries learned from the sparse coding

%% check input parameter
if nargin == 2
    no_noisy = 0;
    regions = parc_region_value();    
end

if strcmp(hemi,'lh')
 data = patient.sc_data.lh;
else if strcmp(hemi,'rh')
        data = patient.sc_data.rh;
    else
        error('%s does not exist',hemi);
    end
end
     

%% show
figure,
for ii=1:length(regions)
    if isempty(data{1,ii})
        continue
    end
    [img,~] = show_dictionary(data{1,ii},0,no_noisy);
    imagesc(img),colormap(gray),title(regions{ii}),pause;
end



end

